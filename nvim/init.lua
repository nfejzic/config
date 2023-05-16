--Remap space as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.smarttab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.relativenumber = true
vim.o.nu = true

vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1 -- use neotree instead
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

-- add marker at 80 chars length and wrap text
vim.o.colorcolumn = "80"
vim.o.formatoptions = 'jcrqlt'
vim.o.textwidth = 80

-- load plugins
require("plugins")

vim.cmd [[
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

if vim.fn.executable('gpaste-client') == 1 then
    vim.g.clipboard = {
        name = 'gpaste',
        copy = {
            ["+"] = { 'gpaste-client', "add" },
            ["*"] = { 'gpaste-client', "add" },
        },
        paste = {
            ["+"] = { 'gpaste-client', '--use-index', 'get', '0' },
            ["*"] = { 'gpaste-client', '--use-index', 'get', '0' },
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

--Remap for dealing with word wrap
-- vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
-- vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

--Map blankline
vim.g.indent_blankline_filetype = { 'vim', 'NvimTree', 'html', 'php' }


-- These commands will navigate through buffers in order regardless of which
-- mode you are using e.g. if you change the order of buffers :bnext and
-- :bprevious will not respect the custom ordering

vim.g.bufferline = {
    animation = false,
}

-- require('nvim-autopairs').setup {}
require('project_nvim').setup {
    manual_mode = true
}
require('colorizer').setup()
require('dressing').setup({
    input = {
        start_in_insert = false,
        insert_only = false,
    }
})

-- don't continue comments on 'o' and 'O' commands
local augroup = vim.api.nvim_create_augroup("Formatoptions", {})
vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    pattern = "*",
    callback = function()
        -- vim.cmd("%foldopen!")
        vim.o.formatoptions = 'jcrql'
    end
})

for _, adapter in ipairs(require("dap").adapters) do
    print(adapter)
end

vim.o.background = "dark"

-- colorscheme set in colorscheme config file
