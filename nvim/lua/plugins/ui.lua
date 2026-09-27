---@param theme_specific table<string,vim.api.keyset.highlight>
local function link_highlights(theme_specific)
	local linked = {
		GitSignsAddInline = { link = "DiffText" },
		GitSignsChangeInline = { link = "DiffText" },
		GitSignsDeleteInline = { link = "DiffText" },
		["@lsp.type.builtinType"] = { link = "@type.builtin" },
		["@lsp.type.comment"] = { link = "@lsp" },

		-- make coloring consistent...
		["@variable"] = { link = "Variable" },
		["@variable.member"] = { link = "Variable" },
		["@variable.parameter"] = { link = "Variable" },
		["@lsp.type.variable"] = { link = "Variable" },
		["@parameter"] = { link = "Variable" },
		-- the '_' in Rust... who linked this to 'Character'
		["@character.special.rust"] = { link = "Variable" },
		["@property"] = { link = "Variable" },

		["@lsp.type.namespace"] = { link = "@module" },
		["@lsp.mod.defaultLibrary"] = { bold = true },
		["@lsp.type.const"] = { link = "Constant" },
		["@lsp.type.comment.lua"] = { link = "none" },

		["@keyword.operator"] = { link = "Keyword" },
		["@constant.macro"] = { link = "PreProc" },
		["@function.macro.rust"] = { link = "PreProc" },
		["@keyword.exception"] = { link = "PreProc" },

		DiagnosticUnnecessary = { link = "DiagnosticUnderlineWarn" },

		BlinkCmpDocBorder = { link = "FloatBorder" },
	}

	local final = vim.tbl_deep_extend("force", linked, theme_specific)
	return final
end

-- GRUVBOX --

local gruvbox = require("gruvbox")
local p = gruvbox.palette

local function choose(light, dark)
	return vim.o.background == "light" and light or dark
end

local function gruvbox_config()
	--- @type GruvboxConfig
	return {
		terminal_colors = true,
		undercurl = true,
		underline = true,
		bold = true,
		italic = {
			strings = false,
			emphasis = true,
			comments = true,
			operators = false,
			folds = true,
		},
		strikethrough = true,
		invert_selection = false,
		invert_signs = false,
		invert_tabline = false,
		inverse = true,
		contrast = vim.o.background == "light" and "" or "hard",
		palette_overrides = {},

		overrides = link_highlights({
			-- NOTE(nfejzic): figure out what we want to do with this
			["@lsp.type.formatSpecifier"] = { link = "Operator" },
			["@lsp.type.interface"] = { link = "Type" },

			-- make coloring consistent...
			["@attribute.builtin"] = { fg = choose(p.faded_aqua, p.bright_aqua), bold = true },

			Variable = { link = "GruvboxFg1" },
			["@variable.parameter.gitcommit"] = { link = "GruvboxFg1" },
			["@markup.heading.gitcommit"] = { link = "GruvboxFg1" },

			["@punctuation"] = { link = "GruvboxFg3" },
			["@punctuation.bracket"] = { link = "@punctuation" },
			["@punctuation.delimiter"] = { link = "@punctuation" },
			["@operator"] = { link = "@punctuation" },
			["@constructor"] = { link = "@punctuation" },

			Function = { link = "GruvboxBlue" },
			["@lsp.type.method"] = { link = "Function" },

			Keyword = { link = "GruvboxPurple" },
			Include = { link = "Keyword" },

			Constant = { link = "GruvboxOrange" },
			Number = { link = "Constant" },
			Boolean = { link = "Constant" },
			Directory = { link = "GruvboxBlueBold" },

			LineNr = { link = "CursorLineFold" },

			FloatTitle = { link = "GruvboxGreenSign" },
			NormalFloat = { bg = choose(p.light1, p.dark1) },
			SnacksNormal = { link = "NormalFloat" },
			SnacksPicker = { link = "NormalFloat" },
			SnacksPickerListCursorLine = { bg = choose(p.light2, p.dark2) },
			SnacksInputNormal = { link = "NormalFloat" },
			SnacksInputBorder = { link = "NormalFloat" },

			SnacksPickerMatch = { fg = choose(p.neutral_red, p.bright_aqua), bold = true },
			SnacksInputTitle = { bg = choose(p.light1, p.dark1) },

			Todo = { fg = choose(p.neutral_yellow, p.bright_yellow), bg = "none" },
			["@comment.error.comment"] = { fg = choose(p.neutral_red, p.bright_red) },
			["@constant.comment"] = { fg = choose(p.neutral_purple, p.bright_purple) },

			-- NOTE: custom treesitter queries for accented keywords
			["@accent"] = { link = "GruvboxYellow" },
		}),

		dim_inactive = false,
		transparent_mode = false,
	}
end

gruvbox.setup(gruvbox_config())

require("catppuccin").setup({
	background = { -- :h background
		light = "latte",
		dark = "macchiato",
	},
})

require("kanagawa").setup({
	compile = true, -- enable compiling the colorscheme
	theme = "wave", -- Load "wave" theme
	transparent = false,
	background = { -- map the value of 'background' option to a theme
		dark = "wave", -- try "dragon" !
		light = "lotus",
	},
	--- @module "kanagawa"
	--- @param colors KanagawaColors
	overrides = function(colors)
		return link_highlights({
			["@lsp.type.formatSpecifier"] = { fg = colors.palette.surimiOrange },

			Variable = { fg = colors.theme.ui.fg },
			["@variable.builtin"] = { fg = colors.palette.surimiOrange, italic = true },

			["@accent"] = { fg = colors.theme.syn.preproc },
		})
	end,
})

require("rose-pine").setup({
	variant = "auto", -- auto, main, moon, or dawn
	dark_variant = "moon", -- main, moon, or dawn

	dim_inactive_windows = true,
	disable_background = false,
	styles = {
		italic = true,
	},

	highlight_groups = link_highlights({
		QuickFixLine = { fg = "none", bg = "highlight_low", bold = true },
		["@lsp.type.formatSpecifier"] = { fg = "love" },

		-- make coloring consistent...
		Variable = { fg = "text" },
		["@variable.builtin"] = { fg = "gold", italic = true },

		-- NOTE: custom treesitter queries for accented keywords
		["@accent"] = { fg = "love" },
	}),
})

-- NAYSAYER --

-- naysayer is a plain colorscheme (no setup() with overrides), so we apply
-- our adjustments via a ColorScheme autocmd. Everything links to — or pulls
-- colors from — the highlight groups the theme itself defines, so this keeps
-- working if the theme's palette changes. Registered before `set_colo()`
-- below, which re-fires ColorScheme and thus applies these right away.
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "naysayer",
	callback = function()
		local function fg_of(group)
			return vim.api.nvim_get_hl(0, { name = group, link = false }).fg
		end
		local function bg_of(group)
			return vim.api.nvim_get_hl(0, { name = group, link = false }).bg
		end

		-- read these upfront: NormalFloat etc. are (re)defined in the loop
		-- below, and pairs() ordering is not deterministic
		local normal_bg = bg_of("Normal")
		local subtle_bg = bg_of("CursorLine")
		local stronger_bg = fg_of("LineNr")
		local accent = bg_of("StatusLine")

		for group, hl in
			pairs(link_highlights({
				["@lsp.type.formatSpecifier"] = { link = "String" },

				-- make coloring consistent...
				Variable = { link = "Identifier" },
				["@variable.builtin"] = { link = "Constant" },

				-- the theme's Cursor has only a bg, making the text under it
				-- unreadable when nvim renders the cursor (e.g. in floats)
				Cursor = { fg = normal_bg, bg = fg_of("CursorLineNr") },

				QuickFixLine = { bg = subtle_bg, bold = true },

				-- naysayer doesn't set these, leaving nvim's off-palette
				-- defaults (grey NonText, light-blue Directory) which clash
				-- with the picker. The dim teal is also what snacks uses for
				-- the "some/dir/" part of file paths
				NonText = { fg = stronger_bg },
				Directory = { link = "String" },
				SnacksPickerDir = { fg = fg_of("Comment") },

				-- floats are seamless with the editor background, naysayer is
				-- a flat theme. This also keeps the picker list cursorline
				-- (CursorLine when unfocused, a subtle bg) visible: if floats
				-- used the CursorLine bg themselves, it would blend away
				NormalFloat = { bg = normal_bg },
				FloatBorder = { fg = stronger_bg, bg = normal_bg },
				FloatTitle = { fg = accent, bg = normal_bg, bold = true },
				SnacksNormal = { link = "NormalFloat" },
				SnacksPicker = { link = "NormalFloat" },
				SnacksPickerListCursorLine = { bg = stronger_bg },
				SnacksPickerMatch = { fg = fg_of("Constant"), bold = true },
				SnacksInputNormal = { link = "NormalFloat" },
				SnacksInputBorder = { link = "FloatBorder" },
				SnacksInputTitle = { link = "FloatTitle" },

				Pmenu = { bg = subtle_bg },
				PmenuSel = { link = "SnacksPickerListCursorLine" },

				Todo = { fg = fg_of("WarningMsg"), bg = "none" },
				["@comment.error.comment"] = { link = "Error" },
				["@constant.comment"] = { link = "Constant" },

				-- NOTE: custom treesitter queries for accented keywords
				["@accent"] = { link = "Type" },
			}))
		do
			vim.api.nvim_set_hl(0, group, hl)
		end
	end,
})

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		globalstatus = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		-- lualine_c = { 'filename', { 'diagnostics', color = "StatusLine", colored = true } },
		lualine_c = { "filename", "diagnostics" },
		lualine_x = { "encoding", "location", { "filetype", icons_enabled = true } },
		lualine_y = {},
		lualine_z = {},

		-- lualine_y = { 'progress' },
		-- lualine_z = { 'location' }
	},
})

local function set_colo()
	local colorscheme = vim.g.nfejzic_colorscheme or "rose-pine"
	vim.cmd.colorscheme(colorscheme or "rose-pine")

	vim.api.nvim_exec_autocmds("ColorScheme", { pattern = vim.g.colors_name })
end

set_colo()

-- HACK: some plugins need the colorscheme ready as soon as possible, and some
--       require it to be set later. This is stupid, and I hope there'll be a
--       better solution to this
-- TODO: figure out a better solution for this...
local grp = vim.api.nvim_create_augroup("gruvbox-background-change", { clear = true })
vim.api.nvim_create_autocmd("OptionSet", {
	group = grp,
	pattern = "background",
	callback = function()
		if vim.g.colors_name == "gruvbox" then
			-- HACK(nfejzic): force gruvbox to choose light and dark colors
			--				  based on background when background changes
			gruvbox.setup(gruvbox_config())
		end

		set_colo()
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		set_colo()
	end,
})
