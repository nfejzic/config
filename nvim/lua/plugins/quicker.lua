return {
	"stevearc/quicker.nvim",

	enabled = true,
	lazy = true,
	ft = "qf",

	config = function()
		local quicker = require('quicker')
		quicker.setup({
			-- Keep the cursor to the right of the filename and lnum columns
			constrain_cursor = false,
			highlight = {
				-- Use treesitter highlighting
				treesitter = true,
				-- Use LSP semantic token highlighting
				lsp = true,
				-- Load the referenced buffers to apply more accurate highlights (may be slow)
				load_buffers = false,
			},

			keys = {
				{ ">", quicker.expand,   desc = "Expand quickfix content" },
				{ "<", quicker.collapse, desc = "Expand quickfix content" },
			}
		})
	end
}
