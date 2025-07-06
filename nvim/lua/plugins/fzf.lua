return {
	"ibhagwan/fzf-lua",

	enabled = false,
	lazy = true,
	cmd = "FzfLua",

	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },

	config = function()
		local fzf = require('fzf-lua')
		local neoconf = require('neoconf')

		local exclude_settings = neoconf.get('vscode.search.exclude')

		if exclude_settings ~= nil then
			for pattern, is_excluded in pairs(exclude_settings) do
				if is_excluded then
					excluded = string.format("%s --exclude %s", pattern)
				end
			end
		end

		fzf.setup({
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
		})
	end
}
