-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- Changing the color scheme:
config.color_scheme = "Tokyo Night (Gogh)"

-- Changing the font scheme:
config.font = wezterm.font("JetBrains Mono Nerd Font")
config.font_size = 12

-- Starting programs
config.default_prog = { "/bin/bash" }

-- Changing the tab bar
config.enable_tab_bar = true

-- Background opacity
config.window_background_opacity = 0.8

-- Return the configuration to wezterm
return config
