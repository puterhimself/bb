import { readdirSync, readFileSync } from "node:fs";
import { join } from "node:path";
import { fileURLToPath } from "node:url";
import Database from "better-sqlite3";
import { drizzle } from "drizzle-orm/better-sqlite3";
import { eq } from "drizzle-orm";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import {
  cloudWorkspace,
  schema,
  server,
  user,
} from "@bb/connect-db";
import { type Deps, claimHandle } from "./api.js";
import type { IncusClient, IncusInstanceState } from "./incus.js";
import {
  createCloudWorkspace,
  getCloudWorkspaceStatus,
  retryCloudWorkspace,
  startProvisioning,
  reconcileWorkspace,
  type ProvisioningDeps,
} from "./provisioning.js";

const MIGRATIONS_DIR = fileURLToPath(
  new URL("../../../../packages/connect-db/migrations", import.meta.url),
);

let sqlite: Database.Database;
let db: ReturnType<typeof drizzle>;
let deps: Deps;

beforeEach(() => {
  sqlite = new Database(":memory:");
  sqlite.pragma("foreign_keys = ON");
  for (const file of readdirSync(MIGRATIONS_DIR).sort()) {
    if (file.endsWith(".sql"))
      sqlite.exec(readFileSync(join(MIGRATIONS_DIR, file), "utf8"));
  }
  db = drizzle(sqlite, { schema });
  deps = {
    db,
    baseDomain: "getbb.app",
    appUrl: "https://getbb.app",
  };
});

afterEach(() => {
  sqlite.close();
});

function seedUser(id: string): void {
  const now = new Date();
  db.insert(user)
    .values({
      id,
      name: "Test",
      email: `${id}@example.com`,
      emailVerified: true,
      createdAt: now,
      updatedAt: now,
    })
    .run();
}

function mockIncus(overrides: Partial<IncusClient> = {}): IncusClient {
  return {
    cloneTemplate: vi.fn(async () => {}),
    injectWorkspaceConfig: vi.fn(async () => {}),
    startInstance: vi.fn(async () => {}),
    getInstanceState: vi.fn(async () => ({
      status: "Running",
      pid: 123,
      network: {},
    })),
    deleteInstance: vi.fn(async () => {}),
    ...overrides,
  };
}

function provisioningDeps(incus: IncusClient): ProvisioningDeps {
  return { ...deps, incus };
}

// ── Ticket 1: create / read / retry ──────────────────────────────────────

describe("createCloudWorkspace", () => {
  it("returns no-handle when the user has no profile", async () => {
    seedUser("u1");
    const result = await createCloudWorkspace(deps, "u1");
    expect(result).toEqual({ error: "no-handle" });
  });

  it("creates a pending workspace linked to the primary server", async () => {
    seedUser("u2");
    await claimHandle(deps, "u2", "alice");

    const result = await createCloudWorkspace(deps, "u2");
    expect("ok" in result && result.ok).toBe(true);
    if (!("ok" in result)) return;
    expect(result.workspace.status).toBe("pending");
    expect(result.workspace.containerName).toBeNull();
    expect(result.workspace.serverId).not.toBeNull();
  });

  it("is idempotent — duplicate calls return the same workspace", async () => {
    seedUser("u3");
    await claimHandle(deps, "u3", "bob");

    const first = await createCloudWorkspace(deps, "u3");
    const second = await createCloudWorkspace(deps, "u3");
    expect("ok" in first).toBe(true);
    expect("ok" in second).toBe(true);
    if (!("ok" in first) || !("ok" in second)) return;
    expect(second.workspace.id).toBe(first.workspace.id);
  });

  it("enforces one workspace per user via unique index", async () => {
    seedUser("u4");
    await claimHandle(deps, "u4", "carol");
    await createCloudWorkspace(deps, "u4");

    const now = new Date();
    expect(() =>
      db
        .insert(cloudWorkspace)
        .values({
          id: "second",
          userId: "u4",
          serverId: null,
          status: "pending",
          createdAt: now,
          updatedAt: now,
        })
        .run(),
    ).toThrow();
  });
});

describe("getCloudWorkspaceStatus", () => {
  it("returns null when no workspace exists", async () => {
    seedUser("u5");
    const result = await getCloudWorkspaceStatus(deps, "u5");
    expect(result).toBeNull();
  });

  it("returns the workspace summary when one exists", async () => {
    seedUser("u6");
    await claimHandle(deps, "u6", "dave");
    await createCloudWorkspace(deps, "u6");

    const result = await getCloudWorkspaceStatus(deps, "u6");
    expect(result).not.toBeNull();
    expect(result!.status).toBe("pending");
  });
});

describe("retryCloudWorkspace", () => {
  it("returns not-found when no workspace exists", async () => {
    seedUser("u7");
    const result = await retryCloudWorkspace(deps, "u7");
    expect(result).toEqual({ error: "not-found" });
  });

  it("resets a failed workspace to pending and clears error", async () => {
    seedUser("u8");
    await claimHandle(deps, "u8", "eve");
    await createCloudWorkspace(deps, "u8");

    db.update(cloudWorkspace)
      .set({ status: "failed", error: "boom", updatedAt: new Date() })
      .where(eq(cloudWorkspace.userId, "u8"))
      .run();

    const result = await retryCloudWorkspace(deps, "u8");
    expect("ok" in result && result.ok).toBe(true);
    if (!("ok" in result)) return;
    expect(result.workspace.status).toBe("pending");
    expect(result.workspace.error).toBeNull();
  });

  it("is a no-op when the workspace is not failed", async () => {
    seedUser("u9");
    await claimHandle(deps, "u9", "frank");
    await createCloudWorkspace(deps, "u9");

    const result = await retryCloudWorkspace(deps, "u9");
    expect("ok" in result && result.ok).toBe(true);
    if (!("ok" in result)) return;
    expect(result.workspace.status).toBe("pending");
  });
});

// ── Ticket 3: startProvisioning ──────────────────────────────────────────

describe("startProvisioning", () => {
  it("clones, injects, starts, and sets status to starting", async () => {
    seedUser("u10");
    await claimHandle(deps, "u10", "grace");
    const created = await createCloudWorkspace(deps, "u10");
    expect("ok" in created).toBe(true);
    if (!("ok" in created)) return;

    const incus = mockIncus();
    const pdeps = provisioningDeps(incus);
    const result = await startProvisioning(pdeps, "u10", created.workspace);

    expect(result.status).toBe("starting");
    expect(result.containerName).not.toBeNull();
    expect(result.containerName).toMatch(/^bb-ws-/);
    expect(incus.cloneTemplate).toHaveBeenCalledTimes(1);
    expect(incus.injectWorkspaceConfig).toHaveBeenCalledTimes(1);
    expect(incus.startInstance).toHaveBeenCalledTimes(1);
  });

  it("sets failed with error message when clone throws", async () => {
    seedUser("u11");
    await claimHandle(deps, "u11", "heidi");
    const created = await createCloudWorkspace(deps, "u11");
    if (!("ok" in created)) return;

    const incus = mockIncus({
      cloneTemplate: vi.fn(async () => {
        throw new Error("pool full");
      }),
    });
    const pdeps = provisioningDeps(incus);
    const result = await startProvisioning(pdeps, "u11", created.workspace);

    expect(result.status).toBe("failed");
    expect(result.error).toBe("pool full");
  });

  it("deletes leftover container before cloning", async () => {
    seedUser("u12");
    await claimHandle(deps, "u12", "ivan");
    const created = await createCloudWorkspace(deps, "u12");
    if (!("ok" in created)) return;

    const incus = mockIncus();
    const pdeps = provisioningDeps(incus);
    await startProvisioning(pdeps, "u12", created.workspace);

    // deleteInstance is called first (cleanup attempt), then clone
    expect(incus.deleteInstance).toHaveBeenCalledTimes(1);
    expect(incus.cloneTemplate).toHaveBeenCalledTimes(1);
  });

  it("is a no-op when status is not pending", async () => {
    seedUser("u13");
    await claimHandle(deps, "u13", "judith");
    await createCloudWorkspace(deps, "u13");
    db.update(cloudWorkspace)
      .set({ status: "ready", updatedAt: new Date() })
      .where(eq(cloudWorkspace.userId, "u13"))
      .run();

    const workspace = await getCloudWorkspaceStatus(deps, "u13");
    expect(workspace).not.toBeNull();

    const incus = mockIncus();
    const pdeps = provisioningDeps(incus);
    const result = await startProvisioning(pdeps, "u13", workspace!);

    expect(result.status).toBe("ready");
    expect(incus.cloneTemplate).not.toHaveBeenCalled();
  });
});

// ── Ticket 4: reconcileWorkspace ─────────────────────────────────────────

describe("reconcileWorkspace", () => {
  it("returns null when no workspace exists", async () => {
    seedUser("u20");
    const incus = mockIncus();
    const result = await reconcileWorkspace(provisioningDeps(incus), "u20");
    expect(result).toBeNull();
  });

  it("returns pending workspaces as-is without Incus calls", async () => {
    seedUser("u21");
    await claimHandle(deps, "u21", "karl");
    await createCloudWorkspace(deps, "u21");

    const incus = mockIncus();
    const result = await reconcileWorkspace(provisioningDeps(incus), "u21");
    expect(result!.status).toBe("pending");
    expect(incus.getInstanceState).not.toHaveBeenCalled();
  });

  it("transitions to connecting when connect credential is set", async () => {
    seedUser("u22");
    await claimHandle(deps, "u22", "liam");
    await createCloudWorkspace(deps, "u22");
    // Simulate provisioning completed: container started
    db.update(cloudWorkspace)
      .set({
        status: "starting",
        containerName: "bb-ws-test",
        updatedAt: new Date(),
      })
      .where(eq(cloudWorkspace.userId, "u22"))
      .run();

    // Simulate connect paired but no heartbeat yet
    const ws = await getCloudWorkspaceStatus(deps, "u22");
    if (ws?.serverId) {
      db.update(server)
        .set({ credentialHash: "abc123" })
        .where(eq(server.id, ws.serverId))
        .run();
    }

    const incus = mockIncus();
    const result = await reconcileWorkspace(provisioningDeps(incus), "u22");
    expect(result!.status).toBe("connecting");
  });

  it("transitions to ready when connect is online", async () => {
    seedUser("u23");
    await claimHandle(deps, "u23", "mona");
    await createCloudWorkspace(deps, "u23");
    db.update(cloudWorkspace)
      .set({
        status: "connecting",
        containerName: "bb-ws-test2",
        updatedAt: new Date(),
      })
      .where(eq(cloudWorkspace.userId, "u23"))
      .run();

    // Simulate connect paired + heartbeat
    const ws = await getCloudWorkspaceStatus(deps, "u23");
    if (ws?.serverId) {
      db.update(server)
        .set({
          credentialHash: "abc123",
          lastSeenAt: new Date(),
        })
        .where(eq(server.id, ws.serverId))
        .run();
    }

    const incus = mockIncus();
    const result = await reconcileWorkspace(provisioningDeps(incus), "u23");
    expect(result!.status).toBe("ready");
  });

  it("marks failed when container is not running", async () => {
    seedUser("u24");
    await claimHandle(deps, "u24", "nina");
    await createCloudWorkspace(deps, "u24");
    db.update(cloudWorkspace)
      .set({
        status: "starting",
        containerName: "bb-ws-dead",
        updatedAt: new Date(),
      })
      .where(eq(cloudWorkspace.userId, "u24"))
      .run();

    const incus = mockIncus({
      getInstanceState: vi.fn(async (): Promise<IncusInstanceState> => ({
        status: "Stopped",
        pid: 0,
        network: {},
      })),
    });
    const result = await reconcileWorkspace(provisioningDeps(incus), "u24");
    expect(result!.status).toBe("failed");
    expect(result!.error).toContain("stopped");
  });
});
