local window = require("wezterm").window

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
local function tab_title(tab)
	local pane = tab.active_pane
	local index = tab.tab_index + 1

	local title = tab.tab_title

	if not title or #title == 0 then
		title = basename(pane.foreground_process_name)
	end

	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return index .. ": " .. title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return index .. ": " .. tab.active_pane.title
end

--- @param colors ColorTheme
---@diagnostic disable-next-line: unused-local
M.format_tab_title = function(colors)
	---@diagnostic disable-next-line: unused-local
	return function(tab, _tabs, _panes, _config, _hover, _max_width)
		local title = tab_title(tab)
		return {
			{ Text = " " .. title .. " " },
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

return M
