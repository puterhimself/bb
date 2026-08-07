/**
 * Minimal Incus REST API client for workspace provisioning.
 *
 * Talks to the authenticated Incus gateway (Caddy → Unix socket) exposed at
 * incus.zopu.puter.wtf. All mutating operations (clone, start, delete) are
 * async — the API returns an operation URL that we poll via /wait.
 */

export interface IncusConfig {
  apiUrl: string;
  apiSecret: string;
  project: string;
  template: string;
  storagePool: string;
}

export interface IncusInstanceState {
  status: string;
  pid: number;
  network: Record<
    string,
    { addresses: Array<{ address: string; scope: string }> }
  >;
}

export interface IncusClient {
  cloneTemplate(containerName: string): Promise<void>;
  injectWorkspaceConfig(
    containerName: string,
    env: Record<string, string>,
  ): Promise<void>;
  startInstance(containerName: string): Promise<void>;
  getInstanceState(containerName: string): Promise<IncusInstanceState>;
  deleteInstance(containerName: string): Promise<void>;
}

interface IncusResponse {
  type: "sync" | "async";
  status: string;
  status_code: number;
  operation?: string;
  error?: string;
  metadata?: unknown;
}

function authHeaders(secret: string): Record<string, string> {
  return { Authorization: `Bearer ${secret}` };
}

async function waitForOperation(
  config: IncusConfig,
  operationUrl: string,
): Promise<void> {
  const url = `${config.apiUrl}${operationUrl}/wait?timeout=30&project=${config.project}`;
  const resp = await fetch(url, { headers: authHeaders(config.apiSecret) });
  if (!resp.ok) {
    throw new Error(`Incus operation wait HTTP ${resp.status}`);
  }
  const data = (await resp.json()) as IncusResponse;
  if (data.status_code !== 200) {
    throw new Error(
      `Incus operation failed: ${data.error ?? data.status}`,
    );
  }
}

export function createIncusClient(config: IncusConfig): IncusClient {
  const base = `${config.apiUrl}/1.0`;
  const projectQ = `project=${encodeURIComponent(config.project)}`;

  return {
    async cloneTemplate(containerName: string): Promise<void> {
      const resp = await fetch(`${base}/instances?${projectQ}`, {
        method: "POST",
        headers: {
          ...authHeaders(config.apiSecret),
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          name: containerName,
          source: { type: "copy", source: config.template },
          pool: config.storagePool,
          config: {
            "limits.cpu": "2",
            "limits.memory": "2GiB",
            "limits.processes": "512",
            "boot.autostart": "true",
          },
        }),
      });
      if (!resp.ok) {
        throw new Error(`Incus clone failed: HTTP ${resp.status}`);
      }
      const data = (await resp.json()) as IncusResponse;
      if (data.type === "async" && data.operation) {
        await waitForOperation(config, data.operation);
      }
    },

    async injectWorkspaceConfig(
      containerName: string,
      env: Record<string, string>,
    ): Promise<void> {
      const content = Object.entries(env)
        .map(([k, v]) => `${k}=${v}`)
        .join("\n");
      const resp = await fetch(
        `${base}/instances/${encodeURIComponent(containerName)}/files?${projectQ}&path=${encodeURIComponent("/etc/bb/first-boot.env")}`,
        {
          method: "POST",
          headers: {
            ...authHeaders(config.apiSecret),
            "Content-Type": "application/octet-stream",
            "X-Incus-type": "file",
            "X-Incus-mode": "0600",
          },
          body: content,
        },
      );
      if (!resp.ok) {
        throw new Error(`Incus file push failed: HTTP ${resp.status}`);
      }
    },

    async startInstance(containerName: string): Promise<void> {
      const resp = await fetch(
        `${base}/instances/${encodeURIComponent(containerName)}/state?${projectQ}`,
        {
          method: "PUT",
          headers: {
            ...authHeaders(config.apiSecret),
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ action: "start" }),
        },
      );
      if (!resp.ok) {
        throw new Error(`Incus start failed: HTTP ${resp.status}`);
      }
      const data = (await resp.json()) as IncusResponse;
      if (data.type === "async" && data.operation) {
        await waitForOperation(config, data.operation);
      }
    },

    async getInstanceState(
      containerName: string,
    ): Promise<IncusInstanceState> {
      const resp = await fetch(
        `${base}/instances/${encodeURIComponent(containerName)}/state?${projectQ}`,
        { headers: authHeaders(config.apiSecret) },
      );
      if (!resp.ok) {
        throw new Error(`Incus state fetch failed: HTTP ${resp.status}`);
      }
      const data = (await resp.json()) as IncusResponse;
      return data.metadata as IncusInstanceState;
    },

    async deleteInstance(containerName: string): Promise<void> {
      const resp = await fetch(
        `${base}/instances/${encodeURIComponent(containerName)}?${projectQ}`,
        {
          method: "DELETE",
          headers: authHeaders(config.apiSecret),
        },
      );
      if (!resp.ok) {
        throw new Error(`Incus delete failed: HTTP ${resp.status}`);
      }
      const data = (await resp.json()) as IncusResponse;
      if (data.type === "async" && data.operation) {
        await waitForOperation(config, data.operation);
      }
    },
  };
}
