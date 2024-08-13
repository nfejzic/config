vim.opt.guicursor = ""

--Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.listchars = {
	eol = "↲",
	tab = "» ",
	space = "·",
	trail = "·",
	extends = "…",
	precedes = "…",
	conceal = "┊",
	nbsp = "☠",
}

vim.opt.list = false

vim.o.smarttab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.relativenumber = true
vim.o.nu = true

vim.g.loaded = 1

-- add ruler line where text limit should be (and at 80 chars if textwidth is not defined)
vim.o.colorcolumn = "+1,80"

-- more useful diffs (nvim -d)
-- by ignoring whitespace
vim.opt.diffopt:append("iwhite")
-- and using a smarter algorithm
-- https://vimways.org/2018/the-power-of-diff/
-- https://stackoverflow.com/questions/32365271/whats-the-difference-between-git-diff-patience-and-git-diff-histogram
-- https://luppeng.wordpress.com/2020/10/10/when-to-use-each-of-the-git-diff-algorithms/
vim.opt.diffopt:append("algorithm:histogram")
vim.opt.diffopt:append("indent-heuristic")

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
		vim.o.textwidth = 80

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

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = "*.component.html",
	callback = function(e)
		vim.o.filetype = "htmlangular"
	end,
})

-- keep current content top + left when splitting
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.cmd([[
  augroup on_open
    autocmd!
    autocmd BufWinEnter *.html5 silent! :set filetype=html " contao specific
    autocmd BufWinEnter *.html5 silent! :set syntax=php " contao specific
    autocmd BufWinEnter *.php silent! :set syntax=php
    autocmd BufWinEnter *.scss silent! :set syntax=scss
    autocmd BufWinEnter *.vue silent! :set shiftwidth=2
    autocmd BufWinEnter *.Justfile silent! :set filetype=just
  augroup end
]])

--Enable mouse mode
vim.o.mouse = "a"

--Don't wrap line
vim.o.wrap = false

--Set padding when scrolling
vim.o.scrolloff = 4
vim.o.sidescrolloff = 10

--Enable break indent
vim.o.breakindent = true

-- Save undo history
-- NOTE: ends up in ~/.local/state/nvim/undo/
vim.opt.undofile = true

-- save shared data
vim.opt.shada = { "'10", "<0", "s10", "h" }

-- disable swap files
vim.opt.swapfile = false

--Case insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Do not add comment on "o" for new line
vim.opt.formatoptions:remove("o")

--Set highlight on search
vim.o.hlsearch = false
vim.o.incsearch = true

--Decrease update time
vim.o.updatetime = 50

-- more info in signcolumn
vim.o.signcolumn = "yes"

vim.o.cmdheight = 1
vim.o.showmode = false

vim.o.termguicolors = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menu,menuone,noselect,noinsert"

--" Decent wildmenu
-- in completion, when there is more than one match,
-- list all matches, and only complete to longest common match
vim.opt.wildmode = "list:longest"
-- when opening a file with a command (like :e),
-- don't suggest files like there:
vim.opt.wildignore = ".hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site"

-- use system clipboard
vim.o.clipboard = "unnamedplus"

if vim.fn.executable("gpaste-client") == 1 and not os.getenv("DESKTOP_SESSION") == "hyprland" then
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

-- I actually never use fold, so disable it...
-- NOTE: previous settings were:
-- vim.o.foldmethod = "expr"
-- vim.o.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.o.foldlevelstart = 99
--
-- NOTE: vim.o.foldexpr = "nvim_treesitter#foldexpr()" made startup in big c
-- files VERY slow, multiple seconds slow
vim.opt.foldenable = false
vim.opt.foldmethod = "manual"
vim.opt.foldlevelstart = 99

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- jump to last edit position on opening file
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
			-- except for in git commit messages
			-- https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
			if not vim.fn.expand("%:p"):find(".git", 1, true) then
				vim.cmd('exe "normal! g\'\\""')
			end
		end
	end,
})
