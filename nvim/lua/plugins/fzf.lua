return {
	"ibhagwan/fzf-lua",

	enabled = false,
	lazy = true,
	cmd = "FzfLua",

	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },

	opts = {
		"telescope",
		winopts = {
			preview = {
				layout = "vertical", -- horizontal|vertical|flex
			},
		},
		keymap = {
			builtin = {
				-- neovim `:tmap` mappings for the fzf win
				["<C-?>"] = "toggle-help",
			},
		},
	},
}
