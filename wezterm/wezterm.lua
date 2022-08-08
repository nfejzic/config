local wezterm = require("wezterm")

local gruvbox_dark_hard = wezterm.get_builtin_color_schemes()["Gruvbox Dark"]
gruvbox_dark_hard.background = "#1d2021"

-- this is a simple comment to check how does this font look like
return {
    -- font = wezterm.font("FiraCode Nerd Font"),
    -- font = wezterm.font("Noto Sans Mono"),
    -- font = wezterm.font("Source Code Pro"),
    -- font = wezterm.font("Hack"),
    font = wezterm.font("JetBrains Mono"), -- ->
    -- font = wezterm.font("Cascadia Code"),
    font_size = 11,
    freetype_load_target = "Light",

    -- enable cursive italic form
    -- harfbuzz_features = { "calt", "ss01" },

    color_schemes = {
        ["Gruvbox Dark Hard"] = gruvbox_dark_hard
    },
    -- color_scheme = "Gruvbox Dark Hard",
    color_scheme = "Catppuccin",
    -- color_scheme = "Gruvbox Light",
    -- color_scheme = "Builtin Solarized Light",
    -- color_scheme = "tokyonight",
    -- color_scheme = "nightfox",

    hide_tab_bar_if_only_one_tab = true,

    window_padding = {
        left = "0.0cell",
        right = "0.0cell",
        top = "0.0cell",
        bottom = 0,
    },
    window_decorations = "NONE",

    initial_rows = 200,
    initial_cols = 400,

    warn_about_missing_glyphs = false
}
