-- ensure Lazy.nvim is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ import = "plugins" },

	-- Autocomplete
	{ "mattn/emmet-vim" }, -- emmet for html etc

	-- show help popup for keymaps (like in emacs)
	{ "folke/which-key.nvim" },

	{ "nfejzic/mariana.nvim", dev = true },

	-- btor2 syntax highlighting
	{ "phlo/vim-btor2" },
}, {
	dev = { path = "/Users/nadirfejzic/Developer/nvim" },

	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = true,
		notify = false, -- get a notification when changes are found
	},
})
