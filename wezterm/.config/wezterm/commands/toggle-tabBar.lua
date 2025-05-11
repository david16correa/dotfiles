local wezterm = require("wezterm")

local command = {
	brief = "Toggle tabs",
	-- icon = "md_circle_opacity",
	action = wezterm.action_callback(function(window)
		local overrides = window:get_config_overrides() or {}

		-- if  overrides.enable_tab_bar or overrides.hide_tab_bar_if_only_one_tab then
		if overrides.enable_tab_bar then
			-- hide tabs
			-- overrides.hide_tab_bar_if_only_one_tab = false
			overrides.enable_tab_bar = false
		else
			overrides.enable_tab_bar = true
			-- overrides.hide_tab_bar_if_only_one_tab = true
		end

		window:set_config_overrides(overrides)
	end),
}

return command
