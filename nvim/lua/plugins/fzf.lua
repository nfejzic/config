return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("fzf-lua").setup({
			"telescope",
			winopts = {
				preview = {
					layout = "vertical", -- horizontal|vertical|flex
				},
				on_create = function()
					-- TODO: could fzf-on-open be used for
					-- something useful?

					-- called once upon creation of the fzf main window
					-- can be used to add custom fzf-lua mappings, e.g:
					-- vim.keymap.set("t", "<C-j>", "<Down>", { silent = true, buffer = true })
				end,
				-- called once *after* the fzf interface is closed
				-- on_close = function() ... end
			},
			keymap = {
				-- These override the default tables completely
				-- no need to set to `false` to disable a bind
				-- delete or modify is sufficient
				builtin = {
					-- neovim `:tmap` mappings for the fzf win
					["<C-?>"] = "toggle-help",
				},
			},
		})
	end,
}
