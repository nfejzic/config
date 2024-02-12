--Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.smarttab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.relativenumber = true
vim.o.nu = true

vim.g.loaded = 1

-- add marker at 80 chars length and wrap text
vim.o.colorcolumn = "+1"
vim.o.textwidth = 80

-- set colorcolumn for git commit editing to 50 and 72 characters
vim.api.nvim_create_autocmd("FileType", {
	pattern = "gitcommit",
	callback = function()
		vim.o.colorcolumn = "50,72"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "typescript", "javascript", "vue" },
	callback = function(ev)
		if string.match(ev.file, "idana") then
			vim.o.colorcolumn = "100,+1"
			vim.o.textwidth = 120
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown" },
	callback = function()
		local buf_name = vim.api.nvim_buf_get_name(0)

		if string.match(buf_name, "idana") then
			-- text width 120 in work projects
			vim.o.colorcolumn = "+1"
			vim.o.textwidth = 120
		end
	end,
})

-- set colorcolumn for rust files to 100 (as that's the default in rustfmt)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "rust",
	callback = function()
		vim.o.colorcolumn = "100"
	end,
})

vim.cmd([[
  augroup on_open
    autocmd!
    autocmd BufWinEnter *.html5 silent! :set filetype=html " contao specific
    autocmd BufWinEnter *.html5 silent! :set syntax=php " contao specific
    " autocmd BufWinEnter *.html5 silent! :IndentBlanklineEnable
    autocmd BufWinEnter *.php silent! :set syntax=php
    autocmd BufWinEnter *.scss silent! :set syntax=scss
    autocmd BufWinEnter *.vue silent! :set shiftwidth=2
  augroup end
]])

--Make line numbers default
vim.wo.number = true

--Enable mouse mode
vim.o.mouse = "a"

--Don't wrap line
vim.o.wrap = false

--Set padding when scrolling
vim.o.scrolloff = 4

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true

-- disable swap files
vim.opt.swapfile = false

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Set highlight on search
vim.o.hlsearch = false
vim.o.incsearch = true

--Decrease update time
vim.o.updatetime = 50

-- more info in signcolumn
vim.o.signcolumn = "yes:2"

vim.o.cmdheight = 1
vim.o.showmode = false

vim.o.termguicolors = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menu,menuone,noselect,noinsert"

-- use system clipboard
vim.o.clipboard = "unnamedplus"

if vim.fn.executable("gpaste-client") == 1 then
	vim.g.clipboard = {
		name = "gpaste",
		copy = {
			["+"] = { "gpaste-client", "add" },
			["*"] = { "gpaste-client", "add" },
		},
		paste = {
			["+"] = { "gpaste-client", "--use-index", "get", "0" },
			["*"] = { "gpaste-client", "--use-index", "get", "0" },
		},
		cache_enabled = true,
	}
end

-- global statusline
vim.o.laststatus = 3

-- fold using treesitter
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevelstart = 99

-- Highlight on yank
vim.cmd([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]])
