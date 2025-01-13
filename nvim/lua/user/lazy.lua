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

	-- show help popup for keymaps (like in emacs)
	{ "folke/which-key.nvim" },

	-- btor2 syntax highlighting
	{ "phlo/vim-btor2" },
}, {
	dev = { path = vim.uv.os_homedir() .. "/Developer/nvim" },

	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = true,
		notify = false, -- get a notification when changes are found
	},

	ui = {
		border = "rounded",
		backdrop = 100,
	},
})
