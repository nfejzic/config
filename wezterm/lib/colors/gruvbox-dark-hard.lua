--- @module "wezterm"

local ansi = {
	"#3c3836",
	"#cc241d",
	"#98971a",
	"#d79921",
	"#458588",
	"#b16286",
	"#689d6a",
	"#504945",
}

local brights = {
	"#665c54",
	"#fb4934",
	"#b8bb26",
	"#fabd2f",
	"#83a598",
	"#d3869b",
	"#8ec07c",
	"#ebdbb2",
}

local bg = "#1d2021"
local fg = "#ebdbb2"

--- @type Palette
local colors = {
	ansi = ansi,
	brights = brights,

	background = bg,
	foreground = fg,

	cursor_bg = fg,
	cursor_border = fg,
	cursor_fg = bg,

	selection_bg = ansi[8],
	selection_fg = brights[8],

	scrollbar_thumb = ansi[1],
	split = ansi[1],
	visual_bell = ansi[1],

	tab_bar = {
		background = bg,
		inactive_tab_edge = bg,
		inactive_tab_edge_hover = bg,

		active_tab = {
			bg_color = ansi[1],
			fg_color = brights[4],
		},

		inactive_tab = {
			bg_color = ansi[1],
			fg_color = ansi[8],
		}
	},
}

--- @type Palette
return colors
