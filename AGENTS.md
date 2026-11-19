# Agent Instructions

## Repository context

This repository is `sparklinglemon/dotfiles`. It stores personal dotfiles managed with GNU Stow and a small Nix/NixOS flake setup. The goal is to keep portable, reproducible configuration in Git while excluding secrets, auth state, caches, and session/history context.

Important files and directories:

- `stow/` — files that are symlinked into `$HOME` with GNU Stow.
- `configuration.nix`, `flake.nix`, `flake.lock` — Nix/NixOS configuration files.
- `windows/` - Windows host configs (WezTerm, kanata) installed with `windows/install.ps1`, not stowed.
- `README.md` — user-facing setup instructions.
- `CLAUDE.md` — symlink to this file.

## Rules for agents

- Do not commit secrets, tokens, auth files, machine-local caches, or session/history context.
- Do not add Pi or GitHub CLI (`gh`) config to this repo.
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
