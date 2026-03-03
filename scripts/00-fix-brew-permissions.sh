#!/usr/bin/env bash
# Configure sudoers so the secondary user can run brew as the Homebrew owner
# without a password prompt. Must be run as an admin user (will prompt for sudo).
set -euo pipefail

BREW_PREFIX="/opt/homebrew"

if [[ ! -d "$BREW_PREFIX" ]]; then
  echo "ERROR: $BREW_PREFIX does not exist. Install Homebrew on the primary user first."
  exit 1
fi

BREW_OWNER="$(stat -f '%Su' "$BREW_PREFIX/bin/brew")"
CURRENT_USER="$(whoami)"

if [[ "$CURRENT_USER" == "$BREW_OWNER" ]]; then
  echo "You are the Homebrew owner ($BREW_OWNER). This script sets up OTHER users."
  echo ""
fi

read -rp "Which user should be allowed to run brew? " SECONDARY_USER

if ! id "$SECONDARY_USER" &>/dev/null; then
  echo "ERROR: User '$SECONDARY_USER' does not exist."
  exit 1
fi

SUDOERS_FILE="/etc/sudoers.d/homebrew-${SECONDARY_USER}"

echo "Creating $SUDOERS_FILE ..."
echo "  $SECONDARY_USER can run '$BREW_PREFIX/bin/brew' as $BREW_OWNER without a password."

sudo tee "$SUDOERS_FILE" > /dev/null <<EOF
$SECONDARY_USER ALL=($BREW_OWNER) NOPASSWD: $BREW_PREFIX/bin/brew
EOF
sudo chmod 0440 "$SUDOERS_FILE"

echo ""
echo "Done. When logged in as '$SECONDARY_USER', brew commands will run as '$BREW_OWNER'."
echo "The .zshrc deployed by this repo sets up the alias automatically."
