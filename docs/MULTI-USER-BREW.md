# Multi-User Homebrew on macOS (Apple Silicon)

## The Problem

Homebrew on Apple Silicon installs to `/opt/homebrew`. By default, only the user who installed it has write access. A second admin user gets "permission denied" errors when running `brew install`.

## The Solution

Share the single `/opt/homebrew` installation by fixing group permissions:

```bash
sudo chgrp -R admin /opt/homebrew
sudo chmod -R g+rwX /opt/homebrew
```

This makes `/opt/homebrew` writable by all members of the `admin` group (which includes all admin users on macOS).

## Why Not Per-User Homebrew?

- Homebrew bottles (pre-built binaries) are compiled for `/opt/homebrew` on Apple Silicon
- Installing to a different prefix forces building everything from source
- Two full Homebrew installations waste disk space and cause PATH confusion

## Node.js Isolation

The biggest conflict between users is often Node.js versions. We avoid this entirely by using `fnm` (Fast Node Manager):

- Each user installs fnm independently: `curl -fsSL https://fnm.vercel.app/install | bash`
- Node.js is installed per-user in `~/.local/share/fnm/`
- `which node` points to `~/.local/share/fnm/...`, not `/opt/homebrew/bin/node`
- Users can have completely different Node.js versions without conflict

## After Changing Permissions

If Homebrew complains after permission changes, run:

```bash
brew doctor
```

Common fix if ownership gets reset (e.g., after a Homebrew update):

```bash
sudo chgrp -R admin /opt/homebrew
sudo chmod -R g+rwX /opt/homebrew
```

## References

- [Homebrew docs on permissions](https://docs.brew.sh/FAQ)
- [fnm - Fast Node Manager](https://github.com/Schniz/fnm)
