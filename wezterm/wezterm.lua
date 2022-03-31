local wezterm = require("wezterm")

local gruvbox_dark_hard = wezterm.get_builtin_color_schemes()["Gruvbox Dark"]
gruvbox_dark_hard.background = "#1d2021"

-- this is a simple comment to check how does this font look like
return {
    -- font = wezterm.font("FiraCode Nerd Font"),
    -- font = wezterm.font("Fira Code"),
    -- font = wezterm.font("Noto Sans Mono"),
    -- font = wezterm.font("Source Code Pro"),
    -- font = wezterm.font("Hack"),
    font = wezterm.font("JetBrains Mono"),
    font_size = 12,
    freetype_load_target = "Light",
    
    -- l1gq@a
    -- @some_thing
    color_schemes = {
        ["Gruvbox Dark Hard"] = gruvbox_dark_hard
    },
    color_scheme = "Gruvbox Dark Hard",

    hide_tab_bar_if_only_one_tab = true,

    window_padding = {
        left = "0.5cell",
        right = "0.5cell",
        top = "0.0cell",
        bottom = 0,
    },
    window_decorations = "NONE",

    initial_rows = 200,
    initial_cols = 400,
}
