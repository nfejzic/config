---@class CustomEvents
local M = {}

local function update_dpi(get_screens)
	return function(window)
		-- calculate correct DPI
		local active_screen = get_screens().active
		local screen_infos = require("lib.screen_info")

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

--- @param wezterm table
--- @param colors ColorTheme
local function format_workspace_name(wezterm, colors)
	return function(window, _)
		local workspace = window:active_workspace()

		local foreground_color = colors.foreground

		window:set_left_status(wezterm.format({
			{ Attribute = { Intensity = "Normal" } },
			{ Background = { AnsiColor = "Black" } },
			{ Foreground = { AnsiColor = "BrWhite" } },
			{ Text = " [" .. workspace .. "] " },
		}))
	end
end

local last_workspace = nil

--- @param wezterm table
--- @param utils Utils
local function workspace_switching(wezterm, utils)
	wezterm.on(utils.events.WORKSPACE_SWITCHED, function(_, _)
		last_workspace = wezterm.mux.get_active_workspace()
		wezterm.log_info("Update last_workspace = '" .. last_workspace .. "'")
	end)

	wezterm.on(utils.events.SWITCH_TO_LAST_WORKSPACE, function(window, pane)
		if last_workspace == nil then
			wezterm.log_warn("No last workspace, nothing to switch to")
			return
		end

		local current_workspace = wezterm.mux.get_active_workspace()

		wezterm.log_info("Switching from '" ..
			current_workspace .. "' to '" .. last_workspace .. "'")
		window:perform_action(
			wezterm.action.SwitchToWorkspace({ name = last_workspace }), pane)

		last_workspace = current_workspace
	end)
end

--- @param wezterm table
--- @param tab_fns table
--- @param colors ColorTheme
--- @param hostconf HostConfig
--- @param utils Utils
function M.register_events(wezterm, tab_fns, colors, hostconf, utils)
	wezterm.on("format-tab-title", tab_fns.format_tab_title(colors))
	wezterm.on("update-status", format_workspace_name(wezterm, colors))

	workspace_switching(wezterm, utils)

	if hostconf.update_dpi then
		wezterm.on("window-resized", update_dpi(wezterm.gui.screens))
	end
end

return M
