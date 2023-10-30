local M = {}

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
local function basename(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab)
  local pane = tab.active_pane
  local index = tab.tab_index + 1
  local title = basename(pane.foreground_process_name)
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return index .. ': ' .. title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return index .. ': ' .. tab.active_pane.title
end

M.format_tab_title = function(colors)
  return function(tab, _tabs, _panes, _config, _hover, _max_width)
    local title = tab_title(tab)
    return {
      { Text = ' ' .. title .. ' ' },
    }
  end
end

M.tab_bar_colors = function(colors)
  return {
    -- The color of the inactive tab bar edge/divider
    inactive_tab_edge = colors.brights[1],
    background = colors.background,

    active_tab = {
      -- The color of the background area for the tab
      bg_color = colors.ansi[8],
      -- The color of the text for the tab
      fg_color = colors.ansi[1],

      -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
      -- label shown for this tab.
      -- The default is "Normal"
      intensity = 'Bold',

      -- Specify whether you want "None", "Single" or "Double" underline for
      -- label shown for this tab.
      -- The default is "None"
      underline = 'None',

      -- Specify whether you want the text to be italic (true) or not (false)
      -- for this tab.  The default is false.
      italic = false,

      -- Specify whether you want the text to be rendered with strikethrough (true)
      -- or not for this tab.  The default is false.
      strikethrough = false,
    },
    inactive_tab = {
      bg_color = colors.background,
      fg_color = colors.foreground,
      intensity = 'Half',
    },
    new_tab = {
      bg_color = colors.background,
      fg_color = colors.foreground,
    },
    new_tab_hover = {
      bg_color = colors.brights[1],
      fg_color = colors.foreground,
    },
  }
end

return M
