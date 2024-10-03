return {
	"stevearc/quicker.nvim",
	config = function()
		local quicker = require('quicker')
		quicker.setup({
			keys = {
				{ ">", require('quicker').expand,   desc = "Expand quickfix content" },
				{ "<", require('quicker').collapse, desc = "Expand quickfix content" },
			}
		})
	end
}
