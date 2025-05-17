---@class TabApi
local M = {}

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
local function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
---@param max_width number
local function tab_title(tab, max_width)
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

	local title = basename(pane.foreground_process_name)
	local path = pane.current_working_dir

	if path ~= nil then
		local dir_name = basename(path.file_path)

		require("wezterm").log_info("#result + #title + #dir_name + 2 = " ..
			#result + #title + #dir_name + 2)
		require("wezterm").log_info("             max_width = " .. max_width)

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

--- @param colors ColorTheme
---@diagnostic disable-next-line: unused-local
M.format_tab_title = function(colors)
	---@diagnostic disable-next-line: unused-local
	return function(tab, _tabs, _panes, _config, _hover, max_width)
		local title = tab_title(tab, max_width)
		return {
			{ Text = title },
		}
	end
end

--- @param colors ColorTheme
--- @param is_transparent boolean
function M.tab_bar_colors(colors, is_transparent)
	local term_bg = colors.background_secondary

	if is_transparent then
		term_bg = "rgba(0% 0% 0% 0%)"
	end

	return colors.tab_bar(term_bg, colors)
end

local function active_tab_idx(mux_win)
	for _, item in ipairs(mux_win:tabs_with_info()) do
		-- wezterm.log_info('idx: ', idx, 'tab:', item)
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
