---@class CustomEvents
local M = {}

--- @param wezterm table
--- @param colors Theme
local function format_workspace_name(wezterm, colors)
	return function(window, _)
		local workspace = window:active_workspace()

		window:set_left_status(wezterm.format({
			{ Attribute = { Intensity = "Normal" } },
			{ Background = { Color = colors.indexed[18] or colors.background } },
			{ Foreground = { Color = colors.ansi[8] } },
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
--- @param colors Theme
--- @param utils Utils
function M.register_events(wezterm, tab_fns, colors, utils)
	wezterm.on("format-tab-title", tab_fns.format_tab_title(colors))
	wezterm.on("update-status", format_workspace_name(wezterm, colors))

	workspace_switching(wezterm, utils)
end

return M
