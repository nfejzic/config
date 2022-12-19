require('impatient')

vim.o.smarttab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.relativenumber = true
vim.o.nu = true
vim.o.guicursor = ''

vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1 -- use neotree instead
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

-- load plugins
require("plugins")

vim.cmd [[
  set nofoldenable
  augroup on_open
    autocmd!
    autocmd BufWinEnter *.html5 silent! :set filetype=html " contao specific
    autocmd BufWinEnter *.html5 silent! :set syntax=php " contao specific
    autocmd BufWinEnter *.html5 silent! :IndentBlanklineEnable 
    autocmd BufWinEnter *.php silent! :set syntax=php
    autocmd BufWinEnter *.scss silent! :set syntax=scss
    autocmd BufWinEnter *.vue silent! :set shiftwidth=2
  augroup end
]]

--Make line numbers default
vim.wo.number = true

--Enable mouse mode
vim.o.mouse = 'a'

--Don't wrap line
vim.o.wrap = false

--Set padding when scrolling
vim.o.scrolloff = 4

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Set highlight on search
vim.o.hlsearch = false
vim.o.incsearch = true

--Decrease update time
vim.o.updatetime = 50

-- more info in signcolumn
vim.o.signcolumn = 'yes:2'

vim.o.cmdheight = 1
vim.o.showmode = false

vim.o.termguicolors = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect,noinsert'

-- use system clipboard
vim.o.clipboard = "unnamedplus"

-- global statusline
vim.o.laststatus = 3

--Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--Remap for dealing with word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

--Map blankline
vim.g.indent_blankline_filetype = { 'vim', 'NvimTree', 'html', 'php' }


-- These commands will navigate through buffers in order regardless of which mode you are using
-- e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering

vim.g.bufferline = {
    animation = false,
}

require('nvim-autopairs').setup {}
require('project_nvim').setup {}
require('colorizer').setup()
require('dressing').setup({
    input = {
        start_in_insert = false,
        insert_only = false,
    }
})
