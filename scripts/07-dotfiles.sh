#!/usr/bin/env bash
# Deploy dotfiles (.zshrc, .p10k.zsh) to the user's home directory.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# Back up existing dotfiles
for file in .zshrc .p10k.zsh; do
  if [[ -f "$HOME/$file" ]]; then
    echo "Backing up $HOME/$file -> $HOME/${file}.bak"
    cp "$HOME/$file" "$HOME/${file}.bak"
  fi
done

echo "Deploying .zshrc ..."
cp "$REPO_DIR/configs/zshrc" "$HOME/.zshrc"

echo "Deploying .p10k.zsh ..."
cp "$REPO_DIR/configs/p10k.zsh" "$HOME/.p10k.zsh"

echo "Dotfiles deployed. Restart your shell or run: source ~/.zshrc"
