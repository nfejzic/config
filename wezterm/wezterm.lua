local wezterm = require("wezterm")
local mux = wezterm.mux

local gruvbox_dark_hard = wezterm.get_builtin_color_schemes()["Gruvbox Dark"]
gruvbox_dark_hard.background = "#1d2021"

wezterm.on("gui-startup", function()
    local _, _, window = mux.spawn_window {}
    window:gui_window():maximize()
end)

return {
    -- font = wezterm.font("JetBrains Mono"),
    font = wezterm.font("Cascadia Code"),
    font_size = 12,
    freetype_load_target = "Light",

    -- enable cursive italic form for Cascadia Code font
    -- harfbuzz_features = { "calt", "ss01" },

    color_schemes = {
        ["Gruvbox Dark Hard"] = gruvbox_dark_hard
    },
    -- color_scheme = "Gruvbox Dark Hard",
    color_scheme = "Catppuccin",
    -- color_scheme = "Gruvbox Light",
    -- color_scheme = "Builtin Solarized Light",

    hide_tab_bar_if_only_one_tab = true,

    window_padding = {
        left = "0.0cell",
        right = "0.0cell",
        top = "0.0cell",
        bottom = 0,
    },

    window_decorations = "RESIZE",

    warn_about_missing_glyphs = false
}
