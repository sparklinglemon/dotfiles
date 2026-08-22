# dotfiles

Personal dotfiles for `sparklinglemon`, managed with GNU Stow and intended to be reproducible across machines.

## What is included

- Shell startup files: `.bashrc`, `.bash_profile`
- Fish shell config and prompt
- tmux config
- GitHub CLI preferences, excluding account/auth state
- Pi portable settings and package declarations
- Nix/NixOS flake files: `flake.nix`, `flake.lock`, `configuration.nix`

## What is intentionally excluded

Secrets and machine/session-specific state should not be committed. This includes:

- GitHub CLI auth/account state: `stow/.config/gh/hosts.yml`
- Pi auth, sessions, model cache, installed npm packages, and runtime state
- Tokens, API keys, private credentials, local history, or generated caches

## Install on a new machine

```bash
git clone https://github.com/sparklinglemon/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow --no-folding -d ~/dotfiles -t ~ stow
```

Use `--no-folding` so Stow symlinks individual files instead of whole directories. This prevents tools such as Pi from writing runtime/session data back into the repo.

## Pi setup

Portable Pi configuration is stored at:

```text
stow/.pi/agent/settings.json
```

This file should contain everything needed to reproduce the Pi setup, including default model settings and downloaded Pi packages/extensions, for example:

```json
{
  "packages": [
    "npm:@burneikis/pi-vim"
  ]
}
```

After stowing on a new machine, Pi should install missing packages from settings on startup. You can also reconcile extensions manually:

```bash
pi update --extensions
```

Do not commit Pi runtime files such as `auth.json`, `sessions/`, `models-store.json`, or `npm/`.

## Notes

`CLAUDE.md` is a symlink to `AGENTS.md` so agent instructions stay in one place.
