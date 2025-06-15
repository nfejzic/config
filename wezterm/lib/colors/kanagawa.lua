local M = {}

local palette = {
	fujiWhite = '#DCD7BA',
	fujiGrey = '#727169',
	oldWhite = '#C8C093',

	katanaGrey = '#717C7C',

	sumiInk0 = '#16161D',
	sumiInk1 = '#1F1F28',
	sumiInk2 = '#2A2A37',
	sumiInk3 = '#363646',
	sumiInk4 = '#54546D',

	waveRed = '#E46876',
	samuraiRed = '#E82424',
	peachRed = '#FF5D62',
	autumnRed = '#C34043',
	winterRed = '#43242B',

	surimiOrange = '#FFA066',

	boatYellow2 = '#C0A36E',
	carpYellow = '#E6C384',
	autumnYellow = '#DCA561',
	winterYellow = '#49443C',
	roninYellow = '#FF9E3B',

	springGreen = '#98BB6C',
	autumnGreen = '#76946A',
	winterGreen = '#2B3328',

	waveAqua1 = '#6A9589',
	waveAqua2 = '#7AA89F',

	waveBlue1 = '#223249',
	waveBlue2 = '#2D4F67',
	lightBlue = '#A3D4D5',
	crystalBlue = '#7E9CD8',
	dragonBlue = '#658594',
	springBlue = '#7FB4CA',
	winterBlue = '#252535',

	springViolet1 = '#938AA9',
	oniViolet = '#957FB8',

	sakuraPink = '#D27E99',

	-- # LOTUS

	-- ink
	lotusInk1 = "#545464",
	lotusInk2 = "#43436c",

	-- white
	lotusWhite0 = "#d5cea3",
	lotusWhite1 = "#dcd5ac",
	lotusWhite2 = "#e5ddb0",
	lotusWhite3 = "#f2ecbc",
	lotusWhite4 = "#e7dba0",

	-- grey
	lotusGray = "#dcd7ba",
	lotusGray2 = "#716e61",
	lotusGray3 = "#8a8980",

	-- red
	lotusRed = "#c84053",
	lotusRed3 = "#e82424",
	lotusRed4 = "#d9a594",

	-- orange
	lotusOrange = "#cc6d00",
	lotusOrange2 = "#e98a00",

	-- yellow
	lotusYellow2 = "#836f4a",
	lotusYellow3 = "#de9800",
	lotusYellow4 = "#f9d791",

	-- green
	lotusGreen = "#6f894e",
	lotusGreen2 = "#6e915f",
	lotusGreen3 = "#b7d0ae",

	-- teal
	lotusTeal2 = "#6693bf",
	lotusTeal3 = "#5a7785",

	-- aqua
	lotusAqua2 = "#5e857a",

	-- cyan
	lotusCyan = "#d7e3d8",

	-- blue
	lotusBlue2 = "#b5cbd2",
	lotusBlue4 = "#4d699b",

	-- violet
	lotusViolet3 = "#c9cbd1",
	lotusViolet4 = "#624c83",

	-- pink
	lotusPink = "#b35b79",

	-- # DRAGON

	-- black
	dragonBlack0 = "#0d0c0c",
	dragonBlack1 = "#12120f",
	dragonBlack2 = "#1D1C19",
	dragonBlack3 = "#181616",
	dragonBlack4 = "#282727",
	dragonBlack5 = "#393836",
	dragonBlack6 = "#625e5a",

	-- gray
	dragonAsh = "#737c73",
	dragonGray = "#a6a69c",
	dragonGray2 = "#9e9b93",
	dragonGray3 = "#7a8382",

	-- white
	dragonWhite = "#c5c9c5",

	-- red
	dragonRed = "#c4746e",

	-- orange
	dragonOrange = "#b6927b",
	dragonOrange2 = "#b98d7b",

	-- yellow
	dragonYellow = "#c4b28a",

	-- green
	dragonGreen = "#87a987",
	dragonGreen2 = "#8a9a7b",

	-- aqua
	dragonAqua = "#8ea4a2",

	-- teal
	dragonTeal = "#949fb5",

	-- blue
	dragonBlue2 = "#8ba4b0",

	-- violet
	dragonViolet = "#8992a7",

	-- pink
	dragonPink = "#a292a3",
}

--- @return Palette
function M.wave()
	--- @type Palette
	return {
		foreground = palette.fujiWhite,
		background = palette.sumiInk1,
		background_secondary = palette.sumiInk2,
		cursor_bg = palette.fujiWhite,
		cursor_fg = palette.sumiInk1,
		selection_fg = palette.oldWhite,
		selection_bg = palette.waveBlue2,
		compose_cursor = palette.boatYellow2,
		active_tab = palette.autumnYellow,
		hover_tab = palette.crystalBlue,
		ansi = {
			palette.sumiInk2,
			palette.autumnRed,
			palette.autumnGreen,
			palette.boatYellow2,
			palette.crystalBlue,
			palette.oniViolet,
			palette.waveAqua1,
			palette.oldWhite,
		},
		brights = {
			palette.oldWhite,
			palette.samuraiRed,
			palette.springGreen,
			palette.carpYellow,
			palette.springBlue,
			palette.sakuraPink,
			palette.waveAqua2,
			palette.fujiWhite,
		},
	}
end

---@return Palette
function M.dragon()
	--- @type AnsiColors
	local ansi = {
		palette.dragonBlack0,
		palette.dragonRed,
		palette.dragonGreen2,
		palette.dragonYellow,
		palette.dragonBlue2,
		palette.dragonPink,
		palette.dragonAqua,
		palette.oldWhite,
	}

	--- @type BrightColors
	local brights = {
		palette.dragonGray,
		palette.waveRed,
		palette.dragonGreen,
		palette.carpYellow,
		palette.springBlue,
		palette.springViolet1,
		palette.waveAqua2,
		palette.dragonWhite,
	}

	--- @type Palette
	return {
		foreground = palette.dragonWhite,
		background = palette.dragonBlack1,
		background_secondary = palette.dragonBlack2,
		cursor_bg = palette.dragonWhite,
		cursor_fg = palette.dragonBlack1,
		compose_cursor = palette.boatYellow2,
		selection_fg = palette.dragonBlack1,
		selection_bg = palette.waveBlue1,
		active_tab = palette.boatYellow2,
		hover_tab = brights[5],
		ansi = ansi,
		brights = brights,
	}
end

---@return Palette
function M.lotus()
	--- @type AnsiColors
	local ansi = {
		palette.lotusWhite2,
		palette.lotusRed,
		palette.lotusGreen2,
		palette.lotusYellow2,
		palette.lotusBlue4,
		palette.lotusViolet4,
		palette.lotusAqua2,
		palette.lotusInk1,
	}

	--- @type BrightColors
	local brights = {
		palette.lotusInk2,
		palette.lotusRed3,
		palette.lotusGreen,
		palette.lotusOrange2,
		palette.lotusBlue4,
		palette.lotusPink,
		palette.lotusAqua2,
		palette.lotusWhite1
	}

	return {
		foreground = palette.lotusInk1,
		background = palette.lotusWhite3,

		-- Background for the tab bar
		background_secondary = palette.lotusWhite4,

		cursor_bg = palette.lotusInk1,
		cursor_fg = palette.lotusWhite1,
		compose_cursor = palette.boatYellow2,
		selection_bg = palette.lotusViolet3,
		selection_fg = palette.lotusInk2,
		active_tab = palette.lotusRed,
		hover_tab = ansi[5],
		ansi = ansi,
		brights = brights,
	}
end

return M
