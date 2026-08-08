#!/usr/bin/env bash
set -euo pipefail

# Sync workflows from src/workflows/*.json to the n8n instance.
#
# Upserts each workflow by name: creates it if missing, otherwise updates it.
# With --publish, publishes (activates) each workflow after syncing.
#
# Usage:
#   N8N_URL=https://n8n.fromsukong.com N8N_API_KEY=n8n_api_xxx ./scripts/sync-workflows.sh [--publish]

PUBLISH=0
if [[ "${1:-}" == "--publish" ]]; then
  PUBLISH=1
fi

if [[ -z "${N8N_URL:-}" ]]; then
  N8N_URL="https://n8n.fromsukong.com"
fi
export N8N_URL

if [[ -z "${N8N_API_KEY:-}" ]]; then
  echo "ERROR: N8N_API_KEY is not set" >&2
  echo "Create one at ${N8N_URL}/settings/api and export it:" >&2
  echo "  export N8N_API_KEY=your_api_key" >&2
  exit 1
fi

cd "$(dirname "$0")/.."
shopt -s nullglob

changed=0
for file in src/workflows/*.json; do
  name=$(jq -r '.name' "$file")
  echo "Syncing: $name"

  id=$(n8n-cli workflow list --name="$name" --format=json \
    | jq -r --arg n "$name" '.[] | select(.name == $n) | .id' | head -1)

  if [[ -n "$id" ]]; then
    n8n-cli workflow update "$id" --file="$file" --format=id-only -q
    echo "  -> updated $id"
  else
    id=$(n8n-cli workflow create --file="$file" --format=id-only -q)
    echo "  -> created $id"
  fi

  if [[ "$PUBLISH" == "1" ]]; then
    n8n-cli workflow activate "$id" -q
    echo "  -> published $id"
  fi
  changed=1
done

if [[ "$changed" == "0" ]]; then
  echo "No workflow JSON files found in src/workflows/"
  exit 1
fi

echo "Done."
