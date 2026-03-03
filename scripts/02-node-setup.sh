#!/usr/bin/env bash
# Install fnm (Fast Node Manager) and Node 22 per-user.
set -euo pipefail

NODE_VERSION="22"

# Install fnm if not present
if ! command -v fnm &>/dev/null; then
  echo "Installing fnm ..."
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell

  # Source fnm for the rest of this session
  export PATH="$HOME/.local/share/fnm:$PATH"
  eval "$(fnm env)"
fi

echo "Installing Node.js $NODE_VERSION via fnm ..."
fnm install "$NODE_VERSION"
fnm default "$NODE_VERSION"
fnm use "$NODE_VERSION"

echo "Node $(node --version) installed at $(which node)"
echo "npm $(npm --version)"
