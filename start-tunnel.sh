#!/usr/bin/env bash
set -Eeuo pipefail
cd /workspaces/autodraft-browser-mcp
export CONTROL_PLANE_TUNNEL_ID="tunnel_6ae34ef64d1c81918e7e9282af602a9c"
export CONTROL_PLANE_API_KEY="${CONTROL_PLANE_API_KEY:-${OPENAI_API_KEY:-}}"

if [[ -z "$CONTROL_PLANE_API_KEY" ]]; then
  echo "MISSING API KEY: Add CONTROL_PLANE_API_KEY to Codespaces Secrets."
  exit 1
fi

command -v go >/dev/null || { echo "Go missing"; exit 1; }
command -v npx >/dev/null || { echo "Node/npx missing"; exit 1; }

if [[ ! -d .tunnel-client ]]; then
  git clone https://github.com/openai/tunnel-client.git .tunnel-client
fi

(cd .tunnel-client && go build -o ../tunnel-client ./cmd/client)

exec ./tunnel-client run \
  --control-plane.tunnel-id "$CONTROL_PLANE_TUNNEL_ID" \
  --mcp.command "npx -y @playwright/mcp@latest --headless"
