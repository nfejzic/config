local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)


local catppuccin_mocha_hard = wezterm.get_builtin_color_schemes()["Catppuccin Mocha"]
catppuccin_mocha_hard.background = "#11111b"

local gruvbox_dark_hard = wezterm.get_builtin_color_schemes()["GruvboxDarkHard"]
gruvbox_dark_hard.background = "#1d2021"

local theme = "Gruvbox Dark Hard"
-- local theme = "Kanagawa (Gogh)"

-- if wezterm.gui.get_appearance():find "Light" then
--   theme = "Gruvbox Light"
-- end

return {
  font = wezterm.font("JetBrains Mono"),
  font_size = 17,

  color_schemes = {
    ["Catppuccin Dark"] = catppuccin_mocha_hard,
    ["Gruvbox Dark Hard"] = gruvbox_dark_hard,
  },

  color_scheme = theme,
  hide_tab_bar_if_only_one_tab = true,

  window_padding = {
    left = "0.0cell",
    right = "0.0cell",
    top = "0.0cell",
    bottom = "0.0cell",
  },

  window_decorations = "RESIZE",
  warn_about_missing_glyphs = true,
  hide_mouse_cursor_when_typing = false,
  enable_scroll_bar = false
}
