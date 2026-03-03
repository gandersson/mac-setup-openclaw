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

# When running brew as another user, they can't read files in our home dir.
# Copy the Brewfile to /tmp so the brew owner can access it.
BREWFILE="$REPO_DIR/Brewfile"
if [[ "$(whoami)" != "$BREW_OWNER" ]]; then
  BREWFILE="/tmp/Brewfile.$$"
  cp "$REPO_DIR/Brewfile" "$BREWFILE"
  chmod 644 "$BREWFILE"
  trap 'rm -f "$BREWFILE"' EXIT
fi

echo "Installing packages from Brewfile ..."
brew bundle --file="$BREWFILE"

echo "Brew setup complete."
