return {
	{
		"nvim-lualine/lualine.nvim",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			config = function()
				local theme = "auto"
				---@diagnostic disable-next-line: undefined-field
				require("lualine").setup({
					options = {
						icons_enabled = true,
						theme = theme,
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
			end,
		},
	},

	{ "luukvbaal/stabilize.nvim" }, -- Stabilize nvim windows
}
