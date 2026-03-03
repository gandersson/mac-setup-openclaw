# Multi-User Homebrew on macOS (Apple Silicon)

## The Problem

Homebrew on Apple Silicon installs to `/opt/homebrew`. It is **not designed for multi-user use**. A second user gets permission errors and git `safe.directory` errors when running `brew install` or `brew update`.

The common "fix group permissions" approach (`chmod -R g+rwX`) **breaks after every `brew install`** because Homebrew creates new files with the default umask (022), making them unwritable for other users. This requires constant maintenance and is not a real solution.

## The Solution: sudo -Hu

The only reliable approach is to run all `brew` management commands as the Homebrew owner via `sudo -Hu`:

```bash
# In the secondary user's .zshrc:
_brew_owner="$(stat -f '%Su' /opt/homebrew/bin/brew)"
if [[ "$_brew_owner" != "$(whoami)" ]]; then
  alias brew="sudo -Hu $_brew_owner /opt/homebrew/bin/brew"
fi
unset _brew_owner
```

This means:
- All files stay owned by one user - no permission drift
- No `safe.directory` issues - git runs as the repo owner
- No maintenance - it just works, forever
- Installed binaries in `/opt/homebrew/bin` are already readable by all users

## Password-Free Setup

To avoid typing the owner's password on every `brew` command, add a sudoers rule. Run `scripts/00-fix-brew-permissions.sh` as an admin user - it creates `/etc/sudoers.d/homebrew-<username>`:

```
ai-assistant ALL=(goranandersson) NOPASSWD: /opt/homebrew/bin/brew
```

## Node.js Isolation

Node.js versions are managed per-user via `fnm` (Fast Node Manager), completely independent of Homebrew:

- Each user installs fnm: `curl -fsSL https://fnm.vercel.app/install | bash`
- Node.js is installed in `~/.local/share/fnm/` - fully user-scoped
- `which node` points to `~/.local/share/fnm/...`, not `/opt/homebrew/bin/node`

## References

- [Homebrew FAQ - "not designed for multi-user"](https://docs.brew.sh/FAQ)
- [Using Homebrew on a multi-user system (don't)](https://www.codejam.info/2021/11/homebrew-multi-user.html)
- [fnm - Fast Node Manager](https://github.com/Schniz/fnm)
