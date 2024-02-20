return {
	-- lua impl of Github Copilot
	{
		"zbirenbaum/copilot.lua",
		lazy = false,
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
				filetypes = {
					markdown = true, -- overrides default
					terraform = false, -- disallow specific filetype
					sh = function()
						---@diagnostic disable-next-line: param-type-mismatch
						if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
							-- disable for .env files
							return false
						end
						return true
					end,
				},
			})
		end,
	},

	-- add cmp completions
	{
		"zbirenbaum/copilot-cmp",
		dependencies = { "zbirenbaum/copilot.lua" },
		lazy = false,
		config = function()
			require("copilot_cmp").setup({
				formatters = {
					insert_text = require("copilot_cmp.format").remove_existing,
				},
			})
		end,
	},
}
