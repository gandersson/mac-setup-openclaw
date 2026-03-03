#!/usr/bin/env bash
# Install Homebrew if missing, then bundle the Brewfile.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# Install Homebrew if not found
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew ..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add brew to PATH for the rest of this session
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# When sharing /opt/homebrew between users, git's safe.directory check
# blocks brew update because the repos are owned by a different user.
echo "Marking Homebrew directories as safe for git ..."
git config --global --add safe.directory /opt/homebrew/Homebrew/Library/Taps/homebrew/homebrew-core
git config --global --add safe.directory /opt/homebrew/Homebrew/Library/Taps/homebrew/homebrew-cask
git config --global --add safe.directory /opt/homebrew/Homebrew

echo "Updating Homebrew ..."
brew update

echo "Installing packages from Brewfile ..."
brew bundle --file="$REPO_DIR/Brewfile" --no-lock

echo "Brew setup complete."
