return {
	-- NOTE: this is now built-in to Neovim (from v0.10.0)
	--		 however, it does not support block comments, and it's not clear if
	--		 works that well for all use cases. If some commenting does not work
	--		 as wished, maybe re-enable the plugin...
	--
	-- NOTE: Even though this exists as a built-in in Neovim, it lacks support
	--		 important files I work on, as well as block comments and other
	--		 features. So this plugin will remain enabled still.

	-- "gc" to comment visual regions/lines
	{
		"numToStr/Comment.nvim",

		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },

		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,

		event = { "UIEnter" },
	},
}
