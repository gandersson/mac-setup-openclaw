#!/usr/bin/env bash
# Install oh-my-zsh, powerlevel10k, and zsh plugins.
set -euo pipefail

# oh-my-zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "Installing oh-my-zsh ..."
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "oh-my-zsh already installed."
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# powerlevel10k
if [[ ! -d "$HOME/powerlevel10k" ]]; then
  echo "Installing powerlevel10k ..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
else
  echo "powerlevel10k already installed."
fi

# zsh-autosuggestions
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
  echo "Installing zsh-autosuggestions ..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  echo "zsh-autosuggestions already installed."
fi

# zsh-syntax-highlighting
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
  echo "Installing zsh-syntax-highlighting ..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
  echo "zsh-syntax-highlighting already installed."
fi

echo "Shell setup complete."
