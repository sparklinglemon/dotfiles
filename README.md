# dotfiles

Personal dotfiles managed with GNU Stow.

## Install

```bash
git clone https://github.com/sparklinglemon/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow --no-folding -d ~/dotfiles -t ~ stow
```

Use `--no-folding` so only individual files are symlinked. This prevents tools like Pi from writing runtime/session data back into this repo.

## Pi

Portable Pi configuration is stored at:

```text
stow/.pi/agent/settings.json
```

This should include reproducible settings and package/extension declarations, such as downloaded Pi packages. Runtime state is intentionally ignored, including auth, sessions, model caches, and installed package directories.

After stowing on a new machine, Pi should install missing packages from settings on startup, or you can run:

```bash
pi update --extensions
```
