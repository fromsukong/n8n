# n8n — Workflows as Code (GitOps)

> **Belongs to Product**: [`ai-automation-service`](https://github.com/fromsukong/products-dev/blob/main/products/ai-automation-service/prd.md)
> **Repository URL**: [`https://github.com/fromsukong/n8n`](https://github.com/fromsukong/n8n)
> **Maintainer**: @fromsukong

Self-hosted n8n at `n8n.fromsukong.com`. Workflows are authored as code and synced to the instance on every push (GitOps).

## Structure

```
n8n/
├── opencode.json                  # opencode config: n8n MCP server (remote, OAuth)
├── src/workflows/                 # Workflow JSON (export format) — source of truth
├── scripts/sync-workflows.sh      # Upsert every workflow in src/workflows/ via n8n CLI
├── .github/workflows/sync-workflows.yml  # Runs the sync on every push
└── product/                       # Spec & tasks (synced into products-dev)
```

## n8n CLI setup (local machine)

The official [n8n CLI](https://docs.n8n.io/connect/n8n-cli.md) (`@n8n/cli`) talks to the
instance over its REST API from any machine. No server access needed.

```bash
# 1. Install
npm install -g @n8n/cli

# 2. Point it at the instance
n8n-cli config set-url https://n8n.fromsukong.com

# 3. Get an API key: n8n UI → Settings → n8n API → Create API key
n8n-cli config set-api-key n8n_api_xxxxxxxx

# 4. Verify
n8n-cli config show
n8n-cli workflow list
```

Alternatively use env vars: `export N8N_URL=... N8N_API_KEY=...` (useful in CI).

## Sync to n8n (update on push)

Local: `./scripts/sync-workflows.sh --publish` (upserts by workflow name, then publishes).

CI: every push touching `src/workflows/` runs the sync via the GitHub Action.

GitHub repo settings needed once:

| Setting          | Value                                  |
| ---------------- | -------------------------------------- |
| `N8N_URL` (var)  | `https://n8n.fromsukong.com`           |
| `N8N_API_KEY` (secret) | your API key (see above)         |

## Demo workflow

`src/workflows/demo-echo.json` — Webhook → Set → Respond to Webhook.
Live endpoint: `POST https://n8n.fromsukong.com/webhook/demo/echo` with
`{"name": "World"}` returns `{"greeting": "Hello, World!", ...}`.

## MCP

`opencode.json` exposes the n8n MCP server (`https://n8n.fromsukong.com/mcp-server/http`,
OAuth). Coding agents can create/validate/update workflows via the n8n Workflow SDK —
the SDK output should then be exported into `src/workflows/` and committed, so git
stays the source of truth.

Created from [`repo-template`](https://github.com/fromsukong/repo-template).
