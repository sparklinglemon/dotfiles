local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.front_end = 'Software' -- options : 'OpenGL, WebGpu, Software'

-- Shell to launch (PowerShell 7, if installed)
config.default_prog = { 'powershell.exe'}
-- Or for Windows PowerShell: { 'powershell.exe' }
-- Or for WSL: { 'wsl.exe' }

-- Appearance
config.color_scheme = 'Catppuccin Mocha'
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 14.0

-- Window
config.window_background_opacity = 1
config.window_decorations = "INTEGRATED_BUTTONS"
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false

-- Padding
config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}

-- Keybinds (no leader, so nothing conflicts with tmux inside a session)
config.keys = {
  -- Split panes
  {
    key = '%',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '"',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },

  -- Navigate panes (vim-style h/j/k/l)
  { key = 'h', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Right' },

  -- Close pane
  { key = 'x', mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentPane { confirm = true } },
}

return config