---@module "wezterm"

---@class TabApi
local M = {}

--- @param wezterm Wezterm
function M.format_workspace_name(wezterm)
	return function(window, _)
		local workspace = window:active_workspace()

		window:set_left_status(wezterm.format({
			{ Attribute = { Intensity = "Normal" } },
			-- { Background = { Color = colors.tab_bar_bg } },
			-- { Foreground = { Color = colors.palette.ansi[8] } },
			{ Text = " [" .. workspace .. "] " },
		}))
	end
end

local function active_tab_idx(mux_win)
	for _, item in ipairs(mux_win:tabs_with_info()) do
		if item.is_active then
			return item.index
		end
	end
end

function M.spawn_tab_next_to_active(wezterm)
	return function(win, pane)
		local mux_win = win:mux_window()
		local idx = active_tab_idx(mux_win)
		local _ = mux_win:spawn_tab({})
		win:perform_action(wezterm.action.MoveTab(idx + 1), pane)
	end
end

return M
