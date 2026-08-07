import { createServerFn } from "@tanstack/react-start";
import {
  checkAvailability,
  claimHandle,
  createConnectCode,
  createMachineCode,
  createServer,
  depsFromEnv,
  disconnectServer,
  removeServer,
  revokeMachine,
  getAccountState,
  type AccountState,
} from "./api.js";
import {
  createCloudWorkspace,
  getCloudWorkspaceStatus,
  retryCloudWorkspace,
  startProvisioning,
  reconcileWorkspace,
  provisioningDepsFromEnv,
  type CloudWorkspaceSummary,
} from "./provisioning.js";
import { getEnv } from "./env.js";
import { getSessionUserId } from "./current-user.server.js";

// The ONLY server module the client route imports. Everything here is a
// createServerFn, so the client receives RPC stubs and none of the server-only
// imports (D1, better-auth, cloudflare:workers) land in the client bundle.

export type DashboardState =
  | { authed: false }
  | ({ authed: true } & AccountState & {
      cloudWorkspace: CloudWorkspaceSummary | null;
    });

export const getDashboard = createServerFn({ method: "GET" }).handler(
  async (): Promise<DashboardState> => {
    const userId = await getSessionUserId();
    if (!userId) return { authed: false };
    const deps = provisioningDepsFromEnv(getEnv());
    const [accountState, cloudWorkspace] = await Promise.all([
      getAccountState(deps, userId),
      reconcileWorkspace(deps, userId),
    ]);
    return {
      authed: true,
      ...accountState,
      cloudWorkspace,
    };
  },
);

export const claimHandleFn = createServerFn({ method: "POST" })
  .validator((handle: string) => String(handle))
  .handler(async ({ data: handle }) => {
    const userId = await getSessionUserId();
    if (!userId) return { error: "unauthenticated" as const };
    return claimHandle(depsFromEnv(getEnv()), userId, handle);
  });

export const checkAvailabilityFn = createServerFn({ method: "POST" })
  .validator((label: string) => String(label))
  .handler(async ({ data: label }) => {
    const userId = await getSessionUserId();
    if (!userId) return { error: "unauthenticated" as const };
    return checkAvailability(depsFromEnv(getEnv()), label);
  });

export const createServerRowFn = createServerFn({ method: "POST" })
  .validator((label: string) => String(label))
  .handler(async ({ data: label }) => {
    const userId = await getSessionUserId();
    if (!userId) return { error: "unauthenticated" as const };
    return createServer(depsFromEnv(getEnv()), userId, label);
  });

/** Parse the connect-code request at the boundary: an optional server + reuse flag. */
export const createCodeFn = createServerFn({ method: "POST" })
  .validator((input: { serverId?: string; reuse?: boolean } | undefined) => ({
    serverId: typeof input?.serverId === "string" ? input.serverId : undefined,
    reuse: input?.reuse === true,
  }))
  .handler(async ({ data }) => {
    const userId = await getSessionUserId();
    if (!userId) return { error: "unauthenticated" as const };
    return createConnectCode(depsFromEnv(getEnv()), userId, data);
  });

export const createMachineCodeFn = createServerFn({ method: "POST" })
  .validator((input: { serverId?: string } | undefined) => ({
    serverId: typeof input?.serverId === "string" ? input.serverId : undefined,
  }))
  .handler(async ({ data }) => {
    const userId = await getSessionUserId();
    if (!userId) return { error: "unauthenticated" as const };
    return createMachineCode(depsFromEnv(getEnv()), userId, data.serverId);
  });

export const disconnectFn = createServerFn({ method: "POST" })
  .validator((input: { serverId: string }) => ({
    serverId: String(input.serverId),
  }))
  .handler(async ({ data }) => {
    const userId = await getSessionUserId();
    if (!userId) return { error: "unauthenticated" as const };
    if (!data.serverId) return { error: "not-found" as const };
    return disconnectServer(depsFromEnv(getEnv()), userId, data.serverId);
  });

export const removeServerFn = createServerFn({ method: "POST" })
  .validator((input: { serverId: string }) => ({
    serverId: String(input.serverId),
  }))
  .handler(async ({ data }) => {
    const userId = await getSessionUserId();
    if (!userId) return { error: "unauthenticated" as const };
    if (!data.serverId) return { error: "not-found" as const };
    return removeServer(depsFromEnv(getEnv()), userId, data.serverId);
  });

export const revokeMachineFn = createServerFn({ method: "POST" })
  .validator((machineId: string) => String(machineId))
  .handler(async ({ data: machineId }) => {
    const userId = await getSessionUserId();
    if (!userId) return { error: "unauthenticated" as const };
    if (!machineId) return { error: "not-found" as const };
    return revokeMachine(depsFromEnv(getEnv()), userId, machineId);
  });

// ── Cloud workspace provisioning ────────────────────────────────────

export const createCloudWorkspaceFn = createServerFn({ method: "POST" })
  .validator((input: undefined) => input)
  .handler(async () => {
    const userId = await getSessionUserId();
    if (!userId) return { error: "unauthenticated" as const };
    const deps = provisioningDepsFromEnv(getEnv());
    const result = await createCloudWorkspace(deps, userId);
    if ("error" in result) return result;
    if (result.workspace.status === "pending") {
      const updated = await startProvisioning(deps, userId, result.workspace);
      return { ok: true as const, workspace: updated };
    }
    return result;
  });

export const getCloudWorkspaceStatusFn = createServerFn({ method: "GET" })
  .validator((input: undefined) => input)
  .handler(async () => {
    const userId = await getSessionUserId();
    if (!userId) return { error: "unauthenticated" as const };
    const deps = provisioningDepsFromEnv(getEnv());
    const workspace = await reconcileWorkspace(deps, userId);
    return { workspace };
  });

export const retryCloudWorkspaceFn = createServerFn({ method: "POST" })
  .validator((input: undefined) => input)
  .handler(async () => {
    const userId = await getSessionUserId();
    if (!userId) return { error: "unauthenticated" as const };
    const deps = provisioningDepsFromEnv(getEnv());
    const result = await retryCloudWorkspace(deps, userId);
    if ("error" in result) return result;
    if (result.workspace.status === "pending") {
      const updated = await startProvisioning(deps, userId, result.workspace);
      return { ok: true as const, workspace: updated };
    }
    return result;
  });
