local wezterm = require("wezterm")
local mux = wezterm.mux

local catppuccin_mocha_hard = wezterm.get_builtin_color_schemes()["Catppuccin Mocha"]
catppuccin_mocha_hard.background = "#11111b"

wezterm.on("gui-startup", function()
    local _, _, window = mux.spawn_window {}
    window:gui_window():maximize()
end)

return {
    font = wezterm.font("JetBrains Mono"),
    font_size = 13,
    freetype_load_target = "Light",
    color_schemes = {
            ["Catppuccin Dark"] = catppuccin_mocha_hard
    },
    color_scheme = "Catppuccin Dark",
    hide_tab_bar_if_only_one_tab = true,
    window_padding = {
        left = "0.0cell",
        right = "0.0cell",
        top = "0.0cell",
        bottom = 0,
    },
    window_decorations = "RESIZE",
    warn_about_missing_glyphs = false,
    hide_mouse_cursor_when_typing = false
}
