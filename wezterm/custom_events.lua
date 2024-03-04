local M = {}

local function setup_gui(mux)
	return function(cmd)
		local _, _, window = mux.spawn_window(cmd or {})
		local gui = window:gui_window()

		gui:maximize()
	end
end

local function update_dpi(get_screens)
	return function(window)
		-- calculate correct DPI
		local active_screen = get_screens().active
		local screen_infos = require("screen_info")

		if screen_infos[active_screen.name] then
			local config_overrides = window:get_config_overrides() or {}
			local screen_info = screen_infos[active_screen.name]
			local w = active_screen.width
			local h = active_screen.height

			local dpi = math.sqrt(w * w + h * h) / screen_info.size

			if dpi ~= config_overrides.dpi then
				config_overrides.dpi = dpi
				window:set_config_overrides(config_overrides)
			end
		end
	end
end

local function format_workspace_name(wezterm, colors, theme)
	return function(window, _)
		local workspace = window:active_workspace()

		local foreground_color = colors.ansi[1]
		if theme == "rose-pine" then
			foreground_color = colors.brights[8]
		end

		window:set_left_status(wezterm.format({
			{ Attribute = { Intensity = "Normal" } },
			{ Background = { Color = colors.brights[5] } },
			{ Foreground = { Color = foreground_color } },
			{ Text = " [" .. workspace .. "] " },
		}))
	end
end

function M.register_events(wezterm, tab_fns, colors, theme)
	wezterm.on("gui-startup", setup_gui(wezterm.mux))
	wezterm.on("window-resized", update_dpi(wezterm.gui.screens))
	wezterm.on("format-tab-title", tab_fns.format_tab_title(colors))
	wezterm.on("update-status", format_workspace_name(wezterm, colors, theme))
end

return M
