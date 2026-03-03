# Mac Setup for OpenClaw (ai-assistant user)

Automated setup for a dedicated `ai-assistant` macOS user account running OpenClaw.

## Prerequisites

The `ai-assistant` user **must be an admin** on the Mac. This is required because:
- Cask apps (VS Code, Ghostty, etc.) install to `/Applications` which requires admin rights
- The sudoers rule for Homebrew requires an admin user to set up

When creating the user in System Settings > Users & Groups, make sure "Allow user to administer this computer" is enabled.

## Quick Start

### 1. Set up Homebrew sharing (run as the primary admin user, one-time)

This creates a sudoers rule so the `ai-assistant` user can run `brew` commands without permission issues:

```bash
bash scripts/00-fix-brew-permissions.sh
```

### 2. Log in as the ai-assistant user, clone this repo, and run setup

```bash
git clone https://github.com/gandersson/mac-setup-openclaw.git ~/dev/new-mac
cd ~/dev/new-mac
chmod +x setup.sh scripts/*.sh
./setup.sh
```

## What Gets Installed

| Step | Script | What |
|------|--------|------|
| 00 | `fix-brew-permissions.sh` | Sudoers rule for shared Homebrew (admin only) |
| 01 | `brew-install.sh` | Homebrew update + Brewfile packages |
| 02 | `node-setup.sh` | fnm + Node.js 22 (per-user) |
| 03 | `shell-setup.sh` | oh-my-zsh, powerlevel10k, plugins |
| 04 | `ghostty-setup.sh` | Ghostty terminal config |
| 05 | `apps.sh` | Verify cask app installations |
| 06 | `openclaw-install.sh` | OpenClaw + launchd daemon |
| 07 | `dotfiles.sh` | Deploy .zshrc, .p10k.zsh |

## Selective Execution

```bash
./setup.sh --skip 06        # Skip OpenClaw install
./setup.sh --only 02        # Run only Node setup
./setup.sh --skip 05 --skip 06  # Skip multiple steps
```

## Architecture

See [docs/MULTI-USER-BREW.md](docs/MULTI-USER-BREW.md) for details on the multi-user Homebrew approach.

Key design choices:
- **Shared Homebrew** via `sudo -Hu` (the only approach that doesn't break over time)
- **Per-user Node.js** via fnm (no brew node collisions)
- **Per-user shell** config (oh-my-zsh, p10k, plugins)
- **Minimal Brewfile** - only what the OpenClaw user needs

## API Keys

After setup, add your API keys to `~/.env.local`:

```bash
export ANTHROPIC_API_KEY="sk-..."
export OPENAI_API_KEY="sk-..."
export GOOGLE_API_KEY="..."
```

This file is sourced by `.zshrc` and is gitignored.
