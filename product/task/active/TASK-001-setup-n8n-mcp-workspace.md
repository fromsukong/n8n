---
id: TASK-001
title: "Set up n8n MCP workspace"
status: active
product: ai-automation-service
---

# TASK-001: Set up n8n MCP workspace

## Objective
Make the n8n MCP server available to coding agents working in this repo via opencode (OAuth flow).

## Acceptance Criteria
- [ ] `opencode.json` in repo root points to `https://n8n.fromsukong.com/mcp-server/http` with `type: remote`
- [ ] `opencode mcp auth n8n` completes the OAuth authorization against the n8n instance
- [ ] n8n MCP tools load successfully in this workspace
