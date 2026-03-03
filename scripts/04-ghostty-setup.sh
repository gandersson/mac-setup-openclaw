#!/usr/bin/env bash
# Set up Ghostty terminal configuration.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
GHOSTTY_CONFIG_DIR="$HOME/.config/ghostty"

mkdir -p "$GHOSTTY_CONFIG_DIR"

if [[ -f "$GHOSTTY_CONFIG_DIR/config" ]]; then
  echo "Ghostty config already exists, backing up ..."
  cp "$GHOSTTY_CONFIG_DIR/config" "$GHOSTTY_CONFIG_DIR/config.bak"
fi

cp "$REPO_DIR/configs/ghostty/config" "$GHOSTTY_CONFIG_DIR/config"

echo "Ghostty config deployed to $GHOSTTY_CONFIG_DIR/config"
