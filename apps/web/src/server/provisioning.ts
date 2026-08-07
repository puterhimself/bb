import { and, eq } from "drizzle-orm";
import {
  SERVER_OFFLINE_AFTER_MS,
  cloudWorkspace,
  profile,
  server,
  type CloudWorkspaceStatus,
} from "@bb/connect-db";
import type { Deps } from "./api.js";
import { createConnectCode } from "./api.js";
import type { Env } from "./env.js";
import { depsFromEnv } from "./api.js";
import {
  createIncusClient,
  type IncusClient,
  type IncusInstanceState,
} from "./incus.js";

// ── Types ───────────────────────────────────────────────────────────────────

export interface CloudWorkspaceSummary {
  id: string;
  serverId: string | null;
  status: CloudWorkspaceStatus;
  containerName: string | null;
  error: string | null;
  createdAt: number;
  updatedAt: number;
}

export interface ProvisioningDeps extends Deps {
  incus: IncusClient;
}

// ── Factory ─────────────────────────────────────────────────────────────────

export function provisioningDepsFromEnv(env: Env): ProvisioningDeps {
  return {
    ...depsFromEnv(env),
    incus: createIncusClient({
      apiUrl: env.INCUS_API_URL,
      apiSecret: env.INCUS_API_SECRET,
      project: env.INCUS_PROJECT ?? "default",
      template: env.INCUS_TEMPLATE ?? "bb-template",
      storagePool: env.INCUS_STORAGE_POOL ?? "btrfs-fast",
    }),
  };
}

// ── Helpers ─────────────────────────────────────────────────────────────────

function toSummary(
  row: typeof cloudWorkspace.$inferSelect,
): CloudWorkspaceSummary {
  return {
    id: row.id,
    serverId: row.serverId,
    status: row.status,
    containerName: row.containerName,
    error: row.error,
    createdAt: row.createdAt.getTime(),
    updatedAt: row.updatedAt.getTime(),
  };
}

async function setStatus(
  db: ProvisioningDeps["db"],
  id: string,
  status: CloudWorkspaceStatus,
  extra?: { containerName?: string | null; error?: string | null },
): Promise<void> {
  await db
    .update(cloudWorkspace)
    .set({ status, updatedAt: new Date(), ...(extra ?? {}) })
    .where(eq(cloudWorkspace.id, id))
    .run();
}

// ── Ticket 1: create / read / retry (DB only, no Incus) ─────────────────────

type CreateError = "no-handle";

export async function createCloudWorkspace(
  deps: Deps,
  userId: string,
): Promise<
  { ok: true; workspace: CloudWorkspaceSummary } | { error: CreateError }
> {
  const { db } = deps;

  const existing = await db
    .select()
    .from(cloudWorkspace)
    .where(eq(cloudWorkspace.userId, userId))
    .get();
  if (existing) return { ok: true, workspace: toSummary(existing) };

  const prof = await db
    .select()
    .from(profile)
    .where(eq(profile.userId, userId))
    .get();
  if (!prof) return { error: "no-handle" };

  const primary = await db
    .select()
    .from(server)
    .where(and(eq(server.userId, userId), eq(server.subdomain, prof.handle)))
    .get();
  if (!primary) return { error: "no-handle" };

  const now = new Date();
  const id = crypto.randomUUID();
  const row = {
    id,
    userId,
    serverId: primary.id,
    containerName: null,
    status: "pending" as CloudWorkspaceStatus,
    error: null,
    createdAt: now,
    updatedAt: now,
  };
  await db.insert(cloudWorkspace).values(row).run();
  return { ok: true, workspace: toSummary({ ...row }) };
}

export async function getCloudWorkspaceStatus(
  deps: Deps,
  userId: string,
): Promise<CloudWorkspaceSummary | null> {
  const row = await deps.db
    .select()
    .from(cloudWorkspace)
    .where(eq(cloudWorkspace.userId, userId))
    .get();
  return row ? toSummary(row) : null;
}

export async function retryCloudWorkspace(
  deps: Deps,
  userId: string,
): Promise<
  { ok: true; workspace: CloudWorkspaceSummary } | { error: "not-found" }
> {
  const { db } = deps;
  const row = await db
    .select()
    .from(cloudWorkspace)
    .where(eq(cloudWorkspace.userId, userId))
    .get();
  if (!row) return { error: "not-found" };
  if (row.status !== "failed") return { ok: true, workspace: toSummary(row) };

  await setStatus(db, row.id, "pending", { error: null });
  return {
    ok: true,
    workspace: toSummary({ ...row, status: "pending", error: null }),
  };
}

// ── Ticket 3: start provisioning (Incus calls) ──────────────────────────────

/**
 * Drive a `pending` workspace through: mint connect code → clone template →
 * inject first-boot config → start container → persist state.
 *
 * Completes within a single request (~2-3s for btrfs CoW clone + start).
 * The container's BB server boots asynchronously after this returns.
 */
export async function startProvisioning(
  deps: ProvisioningDeps,
  userId: string,
  workspace: CloudWorkspaceSummary,
): Promise<CloudWorkspaceSummary> {
  const { db, incus } = deps;

  if (workspace.status !== "pending") return workspace;

  try {
    await setStatus(db, workspace.id, "provisioning");

    // Mint a fresh connect code for the workspace's server.
    if (!workspace.serverId) throw new Error("workspace has no linked server");
    const codeResult = await createConnectCode(deps, userId, {
      serverId: workspace.serverId,
      reuse: false,
    });
    if ("error" in codeResult) {
      throw new Error(`connect code minting failed: ${codeResult.error}`);
    }

    const containerName = `bb-ws-${workspace.id.slice(0, 12)}`;

    // Clean up any leftover container from a failed attempt.
    try {
      await incus.deleteInstance(containerName);
    } catch {
      // Container doesn't exist — expected.
    }

    // Clone golden template on btrfs-fast.
    await incus.cloneTemplate(containerName);

    // Inject first-boot env: the connect code + server URL the container
    // uses to auto-pair its tunnel on boot.
    await incus.injectWorkspaceConfig(containerName, {
      BB_CONNECT_CODE: codeResult.code,
      BB_CONNECT_SERVER_URL: codeResult.serverUrl,
    });

    // Start the container.
    await incus.startInstance(containerName);

    await setStatus(db, workspace.id, "starting", {
      containerName,
      error: null,
    });
    return {
      ...workspace,
      status: "starting",
      containerName,
      error: null,
    };
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    await setStatus(db, workspace.id, "failed", { error: message });
    return { ...workspace, status: "failed", error: message };
  }
}

// ── Ticket 4: reconcile ─────────────────────────────────────────────────────

/**
 * Check actual Incus + Connect state and drive the workspace status forward.
 * Called on every dashboard poll.
 *
 *   starting   → container RUNNING but Connect not yet paired
 *   connecting → Connect paired (credentialHash set) but tunnel not yet live
 *   ready      → Connect paired AND heartbeated within the offline window
 */
export async function reconcileWorkspace(
  deps: ProvisioningDeps,
  userId: string,
): Promise<CloudWorkspaceSummary | null> {
  const { db, incus } = deps;

  const row = await db
    .select()
    .from(cloudWorkspace)
    .where(eq(cloudWorkspace.userId, userId))
    .get();
  if (!row) return null;

  if (
    row.status === "pending" ||
    row.status === "ready" ||
    row.status === "failed"
  ) {
    return toSummary(row);
  }

  if (!row.containerName) return toSummary(row);

  let state: IncusInstanceState;
  try {
    state = await incus.getInstanceState(row.containerName);
  } catch {
    return toSummary(row);
  }

  if (state.status !== "Running") {
    const msg = `container is ${state.status.toLowerCase()}`;
    await setStatus(db, row.id, "failed", { error: msg });
    return { ...toSummary(row), status: "failed", error: msg };
  }

  if (!row.serverId) return toSummary(row);

  const srv = await db
    .select()
    .from(server)
    .where(eq(server.id, row.serverId))
    .get();

  const paired = srv?.credentialHash != null && srv.revokedAt == null;
  if (!paired) return toSummary(row);

  const lastSeenMs = srv!.lastSeenAt?.getTime() ?? null;
  const online =
    lastSeenMs != null && Date.now() - lastSeenMs < SERVER_OFFLINE_AFTER_MS;

  if (online) {
    await setStatus(db, row.id, "ready", { error: null });
    return { ...toSummary(row), status: "ready", error: null };
  }

  if (row.status !== "connecting") {
    await setStatus(db, row.id, "connecting");
  }
  return { ...toSummary(row), status: "connecting" };
}
