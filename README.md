# dotfiles

Personal dotfiles for `sparklinglemon`, managed with GNU Stow and intended to be reproducible across machines.

## What is included

- Shell startup files: `.bashrc`, `.bash_profile`
- Fish shell config and prompt
- tmux config (plugins are installed by tpm on first start)
- Neovim config: submodule pointing to `sparklinglemon/kickstart.nvim`
- Claude Code global instructions (`CLAUDE.md`) and statusline script
- Nix/NixOS flake files: `flake.nix`, `flake.lock`, `configuration.nix`
- Windows-side configs (not stowed): WezTerm (`.wezterm.lua`) and kanata (`kanata.kbd`)

## What is intentionally excluded

Secrets and machine/session-specific state should not be committed. This includes:

- Claude Code credentials, history, sessions, caches, logs, and other runtime state
- Tokens, API keys, private credentials, local history, or generated caches

## Install on a new machine

```bash
git clone --recurse-submodules https://github.com/sparklinglemon/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow --no-folding -d ~/dotfiles -t ~ stow
```

Use `--no-folding` so Stow symlinks individual files instead of whole directories. This prevents applications from writing runtime/session data back into the repo.

If the repo was cloned without `--recurse-submodules`, fetch the Neovim config with:

```bash
git submodule update --init
```

To pull the latest Neovim config later, run `git submodule update --remote` and commit the new submodule pointer.

## Claude Code setup

Portable Claude Code configuration is stored at:

```text
stow/.claude/CLAUDE.md
stow/.claude/statusline-command.sh
```

`CLAUDE.md` holds global agent instructions (`~/.claude/CLAUDE.md`), and `statusline-command.sh` is the script referenced by `statusLine` in `~/.claude/settings.json`. Do not commit the rest of `~/.claude`, such as `.credentials.json`, `history.jsonl`, `sessions/`, `projects/`, `cache/`, or logs.

## Windows setup

WezTerm and kanata run on the Windows host, not inside WSL, so their configs live in `windows/` and are not stowed. From PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File \\wsl.localhost\<distro>\home\<user>\dotfiles\windows\install.ps1
```

This copies:

- `windows/.wezterm.lua` to `%USERPROFILE%\.wezterm.lua`
- `windows/kanata.kbd` to `%APPDATA%\kanata\kanata.kbd` (kanata's default config path; or run `kanata.exe --cfg <path>`)

The files are copied, not linked, so re-run the script after changing them in the repo. Any differing existing file is backed up as `.bak`.

## Notes

`CLAUDE.md` is a symlink to `AGENTS.md` so agent instructions stay in one place.
