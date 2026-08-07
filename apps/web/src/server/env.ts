import { env as workerEnv } from "cloudflare:workers";

export interface Env {
  DB: D1Database;
  TUNNEL_DO?: DurableObjectNamespace;
  BASE_DOMAIN: string;
  APP_URL: string;
  GITHUB_CLIENT_ID: string;
  GITHUB_CLIENT_SECRET: string;
  BETTER_AUTH_SECRET: string;
  /**
   * Marketing-page endpoints (see src/landing/endpoints.ts). Unset on forks
   * and local dev: /api/subscribe reports signup as not configured, and the
   * download redirect skips server-side click tracking.
   */
  LANDING_POSTHOG_KEY?: string;
  RESEND_API_KEY?: string;
  RESEND_AUDIENCE_ID?: string;
  /**
   * Incus provisioning API. The Worker reaches Incus through the authenticated
   * Caddy reverse proxy at INCUS_API_URL (bearer INCUS_API_SECRET). All other
   * Incus settings have safe defaults and only need overriding for testing.
   */
  INCUS_API_URL: string;
  INCUS_API_SECRET: string;
  INCUS_PROJECT?: string;
  INCUS_TEMPLATE?: string;
  INCUS_STORAGE_POOL?: string;
}

export function getEnv(): Env {
  return workerEnv as unknown as Env;
}
