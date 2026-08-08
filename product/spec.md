# Repository Specification: `n8n`

> **Belongs to Product**: [`ai-automation-service`](../../../products/ai-automation-service/prd.md)  
> **Repository URL**: [`https://github.com/fromsukong/n8n`](https://github.com/fromsukong/n8n)  
> **Visibility**: Public  
> **Maintainer**: @fromsukong  

---

## 1. Description & Scope
Workspace repo for the self-hosted n8n instance at `n8n.fromsukong.com`. Holds the opencode project config that exposes the n8n MCP server (OAuth) to coding agents, plus notes/specs for workflow automation operated through n8n.

---

## 2. Tech Stack & Environment
- **Language**: N/A (config & docs)
- **Package Manager**: N/A
- **Runtime**: self-hosted n8n (docker-compose, see `fromsukong/infra`)

---

## 3. Directory Structure
```
n8n/
├── opencode.json       # opencode config: n8n MCP server (remote, OAuth)
├── product/            # Spec (synced into products-dev via sparse submodule)
└── src/                # Workflow specs, notes, scripts
```

---

## 4. Integration Contracts
- **MCP server**: `https://n8n.fromsukong.com/mcp-server/http` (OAuth, automatic flow)
- **Products-dev**: registered as a sparse submodule at `products-dev/repos/n8n` (checks out `product/` only).
