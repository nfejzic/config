local tab_fns = require("tab_config")
local keys = require("key_config")

local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

local theme = "Gruvbox dark, hard (base16)"
theme = "Catppuccin Mocha"
-- theme = "Kanagawa (Gogh)"
local colors = wezterm.color.get_builtin_schemes()[theme]

wezterm.on(
  'format-tab-title',
  tab_fns.format_tab_title(colors)
)

wezterm.on('update-status', function(window, _pane)
  local workspace = window:active_workspace()
  window:set_left_status(
    wezterm.format({
      { Attribute = { Intensity = 'Half' } },
      { Background = { Color = colors.ansi[5] } },
      { Foreground = { Color = colors.ansi[1] } },
      { Text = ' [' .. workspace .. '] ' },
    }))
end)

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- ->
config.font = wezterm.font("JetBrains Mono")
config.font_size = 20
config.bold_brightens_ansi_colors = "BrightAndBold"

config.color_scheme = theme

config.window_padding = {
  left = "0cell",
  right = "0cell",
  top = "0cell",
  bottom = "0.0cell",
}

-- window_decorations = "RESIZE",
config.warn_about_missing_glyphs = true
config.hide_mouse_cursor_when_typing = false
config.enable_scroll_bar = false

config.window_decorations = "RESIZE|MACOS_FORCE_DISABLE_SHADOW"
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.window_frame = {
  -- The font used in the tab bar.
  -- Roboto Bold is the default; this font is bundled
  -- with wezterm.
  -- Whatever font is selected here, it will have the
  -- main font setting appended to it to pick up any
  -- fallback fonts you may have used there.
  font = wezterm.font("JetBrains Mono"),

  -- The size of the font in the tab bar.
  -- Default to 10.0 on Windows but 12.0 on other systems
  -- font_size = 18.0,

  -- The overall background color of the tab bar when
  -- the window is focused
  active_titlebar_bg = colors.background,

  -- The overall background color of the tab bar when
  -- the window is not focused
  inactive_titlebar_bg = colors.background,
}

config.colors = {
  tab_bar = tab_fns.tab_bar_colors(colors),
}

config.leader = keys.get_keybindings(wezterm).leader
config.keys = keys.get_keybindings(wezterm).keys

-- and finally, return the configuration to wezterm
return config
