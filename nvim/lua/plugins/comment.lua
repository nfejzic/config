return {
	-- NOTE: this is now built-in to Neovim (from v0.10.0)
	--		 however, it does not support block comments, and it's not clear if
	--		 works that well for all use cases. If some commenting does not work
	--		 as wished, maybe re-enable the plugin...
	-- 	-- "gc" to comment visual regions/lines
	-- 	{
	-- 		"numToStr/Comment.nvim",
	--
	-- 		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
	--
	-- 		config = function()
	-- 			require("Comment").setup({
	-- 				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
	-- 			})
	-- 		end,
	--
	-- 		event = { "BufEnter" },
	-- 	},
}
