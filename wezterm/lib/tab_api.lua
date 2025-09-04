---@module "wezterm"

---@class TabApi
local M = {}

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
---@param max_width number
local function tab_title(tab, max_width)
	local utils = require("lib.utils")

	-- we add space at the end, so we count it right away
	max_width = max_width - 1

	local pane = tab.active_pane
	local index = tab.tab_index + 1

	local result = " " .. index .. ": "
	local curr_tab_title = tab.tab_title

	if curr_tab_title and #curr_tab_title > 0 then
		-- if the tab title is explicitly set, take that
		return result .. curr_tab_title
	end

	local title = utils.basename(pane.foreground_process_name)
	local path = pane.current_working_dir

	if path ~= nil then
		local dir_name = utils.basename(path.file_path)

		if #result + #title + #dir_name + 2 > max_width then
			-- -1 for the appended dot
			local dir_len = max_width - #result - #title - 2 - 1
			dir_name = string.sub(dir_name, 1, dir_len) .. "."
		end

		title = title .. "(" .. dir_name .. ")"
	end

	result = result .. title
	return result .. " "
end

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

---@diagnostic disable-next-line: unused-local
function M.format_tab_title(tab, _tabs, _panes, _config, _hover, max_width)
	local title = tab_title(tab, max_width)
	return { { Text = title }, }
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
