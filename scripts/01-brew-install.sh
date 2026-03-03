#!/usr/bin/env bash
# Install Brewfile packages. Uses the brew alias (sudo -Hu) if set up.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# Ensure brew is on PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

# Detect if we're the Homebrew owner or need sudo
BREW_OWNER="$(stat -f '%Su' /opt/homebrew/bin/brew)"
if [[ "$(whoami)" != "$BREW_OWNER" ]]; then
  brew() { sudo -Hu "$BREW_OWNER" /opt/homebrew/bin/brew "$@"; }
  echo "Running brew as $BREW_OWNER (via sudo -Hu) ..."
fi

echo "Updating Homebrew ..."
brew update

echo "Installing packages from Brewfile ..."
brew bundle --file="$REPO_DIR/Brewfile"

echo "Brew setup complete."
