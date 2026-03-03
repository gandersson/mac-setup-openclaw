#!/usr/bin/env bash
# Main orchestrator for OpenClaw user (ai-assistant) Mac setup.
# Usage: ./setup.sh [--skip STEP_NUMBER ...]
#
# Examples:
#   ./setup.sh                    # Run all steps
#   ./setup.sh --skip 05 --skip 06  # Skip apps check and OpenClaw install
#   ./setup.sh --only 02          # Run only Node setup
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log()  { echo -e "${BLUE}[setup]${NC} $*"; }
ok()   { echo -e "${GREEN}[  OK ]${NC} $*"; }
warn() { echo -e "${YELLOW}[ WARN]${NC} $*"; }
err()  { echo -e "${RED}[ERROR]${NC} $*"; }

# Parse args
SKIP=()
ONLY=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --skip)
      SKIP+=("$2")
      shift 2
      ;;
    --only)
      ONLY="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [--skip STEP] [--only STEP]"
      echo ""
      echo "Steps:"
      echo "  01  Homebrew install + Brewfile"
      echo "  02  fnm + Node.js 22"
      echo "  03  oh-my-zsh + powerlevel10k + plugins"
      echo "  04  Ghostty config"
      echo "  05  Verify app installations"
      echo "  06  OpenClaw install + onboard"
      echo "  07  Deploy dotfiles (.zshrc, .p10k.zsh)"
      exit 0
      ;;
    *)
      err "Unknown option: $1"
      exit 1
      ;;
  esac
done

should_run() {
  local step="$1"
  if [[ -n "$ONLY" ]]; then
    [[ "$ONLY" == "$step" ]]
    return
  fi
  for s in "${SKIP[@]}"; do
    [[ "$s" == "$step" ]] && return 1
  done
  return 0
}

# Preflight checks
if [[ "$(uname)" != "Darwin" ]]; then
  err "This script is for macOS only."
  exit 1
fi

log "Starting Mac setup for OpenClaw user"
log "User: $(whoami)"
log "Home: $HOME"
echo ""

# Step 01: Homebrew
if should_run "01"; then
  log "Step 01: Homebrew install + Brewfile"
  bash "$SCRIPT_DIR/scripts/01-brew-install.sh"
  ok "Homebrew done"
  echo ""
fi

# Step 02: Node.js
if should_run "02"; then
  log "Step 02: fnm + Node.js setup"
  bash "$SCRIPT_DIR/scripts/02-node-setup.sh"
  ok "Node.js done"
  echo ""
fi

# Step 03: Shell
if should_run "03"; then
  log "Step 03: Shell setup (oh-my-zsh + p10k + plugins)"
  bash "$SCRIPT_DIR/scripts/03-shell-setup.sh"
  ok "Shell done"
  echo ""
fi

# Step 04: Ghostty
if should_run "04"; then
  log "Step 04: Ghostty config"
  bash "$SCRIPT_DIR/scripts/04-ghostty-setup.sh"
  ok "Ghostty done"
  echo ""
fi

# Step 05: Apps
if should_run "05"; then
  log "Step 05: Verify app installations"
  bash "$SCRIPT_DIR/scripts/05-apps.sh"
  ok "Apps check done"
  echo ""
fi

# Step 06: OpenClaw
if should_run "06"; then
  log "Step 06: OpenClaw install + onboard"
  bash "$SCRIPT_DIR/scripts/06-openclaw-install.sh"
  ok "OpenClaw done"
  echo ""
fi

# Step 07: Dotfiles
if should_run "07"; then
  log "Step 07: Deploy dotfiles"
  bash "$SCRIPT_DIR/scripts/07-dotfiles.sh"
  ok "Dotfiles done"
  echo ""
fi

echo ""
log "Setup complete!"
log "Next steps:"
echo "  1. Restart your shell: exec zsh"
echo "  2. Run 'p10k configure' to customize your prompt"
echo "  3. Add API keys to ~/.env.local"
echo "  4. Verify: openclaw doctor && openclaw status"
