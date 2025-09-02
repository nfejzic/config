---@module "wezterm"

---@class CustomEvents
local M = {}

local last_workspace = nil

--- @param wezterm Wezterm
--- @param utils Utils
local function workspace_switching(wezterm, utils)
	wezterm.on(utils.events.WORKSPACE_SWITCHED, function(_, _)
		last_workspace = wezterm.mux.get_active_workspace()
	end)

	wezterm.on(utils.events.SWITCH_TO_LAST_WORKSPACE, function(window, pane)
		if last_workspace == nil then
			return
		end

		local current_workspace = wezterm.mux.get_active_workspace()

		window:perform_action(
			wezterm.action.SwitchToWorkspace({ name = last_workspace }), pane)

		last_workspace = current_workspace
	end)
end

--- @param wezterm Wezterm
--- @param tab_fns TabApi
--- @param colors Theme
--- @param utils Utils
function M.register_events(wezterm, tab_fns, colors, utils)
	wezterm.on("format-tab-title", tab_fns.format_tab_title(colors))
	wezterm.on("update-status", tab_fns.format_workspace_name(wezterm, colors))

	workspace_switching(wezterm, utils)
end

return M
