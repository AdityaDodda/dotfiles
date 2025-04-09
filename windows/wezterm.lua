-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Changing the color scheme:
config.color_scheme = "Tomorrow (dark) (terminal.sexy)"

-- Changing the font scheme:
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 10

-- Starting programs
config.default_prog = { "powershell.exe", "-NoLogo" }

-- Changing the tab bar
config.enable_tab_bar = true

-- Background opacity
config.window_background_opacity = 0.9

-- Return the configuration to wezterm
return config
