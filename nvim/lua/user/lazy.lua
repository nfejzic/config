-- ensure Lazy.nvim is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

---@return table<number, table<number, string>>
local function plugins_spec()
	local plugins = {
		-- show help popup for keymaps (like in emacs)
		{ "folke/which-key.nvim" },

		-- btor2 syntax highlighting
		{ "phlo/vim-btor2" },
	}

	table.insert(plugins, { import = "plugins" })

	local work_plugins_path = vim.fn.stdpath('config') .. '/lua/work_plugins'

	if vim.uv.fs_stat(work_plugins_path) ~= nil then
		table.insert(plugins, { import = 'work_plugins' })
	end

	return plugins
end


require("lazy").setup(plugins_spec(), {
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
