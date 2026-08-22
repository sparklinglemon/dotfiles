# Agent Instructions

## Repository context

This repository is `sparklinglemon/dotfiles`. It stores personal dotfiles managed with GNU Stow and a small Nix/NixOS flake setup. The goal is to keep portable, reproducible configuration in Git while excluding secrets, auth state, caches, and session/history context.

Important files and directories:

- `stow/` — files that are symlinked into `$HOME` with GNU Stow.
- `stow/.pi/agent/settings.json` — portable Pi settings and package declarations.
- `stow/.config/gh/config.yml` — GitHub CLI preferences that are safe to share.
- `stow/.config/gh/hosts.yml` — GitHub CLI account/auth state; must remain ignored and untracked.
- `configuration.nix`, `flake.nix`, `flake.lock` — Nix/NixOS configuration files.
- `README.md` — user-facing setup instructions.
- `CLAUDE.md` — symlink to this file.

## Rules for agents

- Do not commit secrets, tokens, auth files, machine-local caches, or session/history context.
- Do not commit Pi runtime data such as `auth.json`, `sessions/`, `models-store.json`, `npm/`, installed package contents, logs, or caches.
- Keep Pi setup reproducible by committing portable configuration in `stow/.pi/agent/settings.json`.
- If Pi packages/extensions are installed with `pi install`, ensure the resulting package declaration is represented in `stow/.pi/agent/settings.json` when it is meant to be reused across machines.
- Keep `stow/.config/gh/hosts.yml` ignored and untracked.
- Avoid committing generated files unless they are intentionally part of the reproducible setup.
- Preserve existing unstaged user changes unless explicitly asked to modify them.

## Stow usage

Prefer this command when applying the dotfiles:

```bash
stow --no-folding -d ~/dotfiles -t ~ stow
```

`--no-folding` is important because it prevents whole directories from being symlinked into `$HOME`. That helps avoid applications writing runtime/session files directly into this Git repo.

## Git workflow

- Check `git status --short` before editing and before committing.
- Stage only relevant files.
- Leave unrelated local modifications alone.
- Use concise commit messages that describe the dotfiles/config change.
