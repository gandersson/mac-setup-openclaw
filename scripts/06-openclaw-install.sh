#!/usr/bin/env bash
# Install OpenClaw globally via npm and run onboarding.
set -euo pipefail

# Ensure fnm/node are available in this session
export PATH="$HOME/.local/share/fnm:$PATH"
eval "$(fnm env)"

if ! command -v node &>/dev/null; then
  echo "ERROR: Node.js not found. Run 02-node-setup.sh first."
  exit 1
fi

echo "Installing OpenClaw ..."
npm install -g openclaw@latest

echo ""
echo "Running OpenClaw onboarding ..."
echo "This is interactive - follow the prompts to configure channels and API keys."
echo ""
openclaw onboard --install-daemon
