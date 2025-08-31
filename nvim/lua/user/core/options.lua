-- vim.opt.guicursor = "a:block"
vim.opt.guicursor = "n-v-c-sm-i-ci-ve:block,r-cr-o:hor20"

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
vim.o.splitkeep = "screen"

-- add ruler line where text limit should be
vim.o.colorcolumn = "+1"

-- more useful diffs (nvim -d)
-- by ignoring whitespace
-- vim.opt.diffopt:append("iwhite")
-- and using a smarter algorithm
-- https://vimways.org/2018/the-power-of-diff/
-- https://stackoverflow.com/questions/32365271/whats-the-difference-between-git-diff-patience-and-git-diff-histogram
-- https://luppeng.wordpress.com/2020/10/10/when-to-use-each-of-the-git-diff-algorithms/
vim.opt.diffopt:append("algorithm:histogram")
vim.opt.diffopt:append("indent-heuristic")

-- keep current content top + left when splitting
vim.opt.splitright = true
vim.opt.splitbelow = true

--Enable mouse mode
vim.o.mouse = "a"

--Don't wrap line
vim.o.wrap = false

--Set padding when scrolling
vim.o.scrolloff = 4
vim.o.sidescrolloff = 4

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

vim.opt.winborder = "rounded"
