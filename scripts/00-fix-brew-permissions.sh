#!/usr/bin/env bash
# Fix /opt/homebrew group permissions so multiple admin users can share it.
# Must be run as an admin user (will prompt for sudo).
set -euo pipefail

BREW_PREFIX="/opt/homebrew"

if [[ ! -d "$BREW_PREFIX" ]]; then
  echo "ERROR: $BREW_PREFIX does not exist. Install Homebrew on the primary user first."
  exit 1
fi

echo "Fixing group permissions on $BREW_PREFIX ..."
sudo chgrp -R admin "$BREW_PREFIX"
sudo chmod -R g+rwX "$BREW_PREFIX"

echo "Done. All admin users can now use brew."
