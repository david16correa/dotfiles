local wezterm = require("wezterm")
local constants = require("constants")

-- NOTE: NONE OF THIS WORKS
-- I changed the API to config.background being some lua table
local command = {
	brief = "Toggle terminal transparency",
	icon = "md_circle_opacity",
	action = wezterm.action_callback(function(window)
		local overrides = window:get_config_overrides() or {}

		if not overrides.window_background_opacity or overrides.window_background_opacity == 1 then
			overrides.window_background_opacity = 0.8
			-- overrides.window_background_image = ""
			overrides.background = {}
		else
			overrides.window_background_opacity = 1
			-- overrides.window_background_image = constants.bg_image_darker_blurred
			overrides.background = {
				{
					source = { File = constants.bg_image_darker_blurred },
					vertical_align = "Middle",
					horizontal_align = "Center",
					-- width = "100%",
					-- height = "100%"
				},
			}
		end

		window:set_config_overrides(overrides)
	end),
}

return command
