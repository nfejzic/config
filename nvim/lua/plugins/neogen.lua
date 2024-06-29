return {
	"danymat/neogen",
	config = function()
		local neogen = require("neogen")

		neogen.setup({
			snippet_engine = "luasnip",
		})

		require("user.keymaps").neogen(neogen)
	end,
	lazy = true,
	event = "VeryLazy",
}
