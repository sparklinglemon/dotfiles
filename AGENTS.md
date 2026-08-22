# Agent Instructions

- This repository contains personal dotfiles managed with GNU Stow.
- Do not commit secrets, tokens, auth files, machine-local caches, or session/history context.
- Keep Pi setup reproducible by committing portable configuration in `stow/.pi/agent/settings.json`.
- Do not commit Pi runtime data such as `auth.json`, `sessions/`, `models-store.json`, `npm/`, or installed package contents.
- For Stow, prefer:

```bash
stow --no-folding -d ~/dotfiles -t ~ stow
```
