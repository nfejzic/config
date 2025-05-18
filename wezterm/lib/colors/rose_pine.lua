local M = {}

---@class RosePinePalette
---@field base string
---@field overlay string
---@field muted string
---@field text string
---@field love string
---@field gold string
---@field rose string
---@field pine string
---@field foam string
---@field iris string
---@field highlight_high string
---@field highlight_low string

---@alias RosePineChoice 'main'|'moon'|'dawn'

---@type table<RosePineChoice, RosePinePalette>
local palette = {
	main = {
		base = '#191724',
		overlay = '#26233a',
		muted = '#6e6a86',
		text = '#e0def4',
		love = '#eb6f92',
		gold = '#f6c177',
		rose = '#ebbcba',
		pine = '#31748f',
		foam = '#9ccfd8',
		iris = '#c4a7e7',
		highlight_high = '#524f67',
		highlight_low = '#21202e',
	},
	moon = {
		base = '#232136',
		overlay = '#393552',
		muted = '#6e6a86',
		text = '#e0def4',
		love = '#eb6f92',
		gold = '#f6c177',
		rose = '#ea9a97',
		pine = '#3e8fb0',
		foam = '#9ccfd8',
		iris = '#c4a7e7',
		highlight_high = '#56526e',
		highlight_low = '#2a283e',
	},
	dawn = {
		base = '#faf4ed',
		overlay = '#f2e9e1',
		muted = '#9893a5',
		text = '#575279',
		love = '#b4637a',
		gold = '#ea9d34',
		rose = '#d7827e',
		pine = '#286983',
		foam = '#56949f',
		iris = '#907aa9',
		highlight_high = '#cecacd',
		highlight_low = '#f4ede8',
	}
}

--- @param flavor RosePinePalette
--- @return Palette
local function to_palette(flavor)
	--- @type AnsiColors
	local ansi = {
		flavor.overlay,
		flavor.love,
		flavor.pine,
		flavor.gold,
		flavor.foam,
		flavor.iris,
		flavor.rose,
		flavor.text,
	}

	--- @type BrightColors
	local brights = {
		flavor.muted,
		flavor.love,
		flavor.pine,
		flavor.gold,
		flavor.foam,
		flavor.iris,
		flavor.rose,
		flavor.text,
	}

	--- @type Palette
	return {
		foreground = flavor.text,
		background = flavor.base,
		background_secondary = flavor.overlay,
		cursor_bg = flavor.text,
		cursor_fg = flavor.base,
		compose_cursor = flavor.gold,
		selection_bg = flavor.highlight_low,
		selection_fg = flavor.text,
		active_tab = brights[4],
		hover_tab = brights[5],
		ansi = ansi,
		brights = brights,
	}
end

---@return Palette
function M.main()
	--- @type Palette
	return to_palette(palette.main)
end

---@return Palette
function M.moon()
	--- @type Palette
	return to_palette(palette.moon)
end

---@return Palette
function M.dawn()
	--- @type Palette
	return to_palette(palette.dawn)
end

return M
