-- Pull in the wezterm API
local wezterm = require("wezterm")
local constants = require("constants")
local commands = require("commands")

-- This will hold the configuration.
local config = wezterm.config_builder()

local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

-- ======================================
-- FONT SETTINGS
-- ======================================
config.font_size = 12
config.line_height = 1.0
config.font = wezterm.font("JetBrainsMonoNL Nerd Font", { weight = "ExtraLight" })

-- ======================================
-- COLORS
-- ======================================

config.colors = {
	cursor_bg = "white",
	cursor_fg = "black",
	cursor_border = "white",
}

-- ======================================
-- WINDOW
-- ======================================

-- config.window_decorations = "RESIZE"
-- config.hide_tab_bar_if_only_one_tab = true
config.enable_tab_bar = false
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- ======================================
-- THEME
-- ======================================

-- config.window_background_image = constants.bg_image_darker_blurred
config.background = {
	{
		source = { File = constants.bg_image_darker_blurred },
		vertical_align = "Middle",
		horizontal_align = "Center",
		-- width = "100%",
		-- height = "100%"
	},
}
config.color_scheme = "Abernathy"

-- ======================================
-- MISCELLANEOUS
-- ======================================

config.enable_kitty_graphics = true
config.max_fps = 60
config.prefer_egl = true

-- ======================================
-- CUSTOM COMMANDS
-- ======================================

wezterm.on("augment-command-palette", function()
	return commands
end)

-- ======================================
-- TAB BAR
-- ======================================
-- I don't like the look of "fancy" tab bar
config.use_fancy_tab_bar = false

-- ======================================
-- EXTRA
-- ======================================
--
-- For example, changing the color scheme:
-- config.color_scheme = 'AdventureTime'

-- and finally, return the configuration to wezterm
return config
