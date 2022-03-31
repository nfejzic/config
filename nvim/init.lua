vim.o.smarttab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.relativenumber = true

-- load plugins

require('plugins')
require('config_lsp')

-- lsp-lightbulb
-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

vim.cmd [[
  set nofoldenable
  augroup on_open
    autocmd!
    autocmd BufWinEnter *.html5 silent! :set filetype=html
    autocmd BufWinEnter *.html5 silent! :set syntax=php
    autocmd BufWinEnter *.php silent! :set syntax=php
    autocmd BufWinEnter *.html5 silent! :IndentBlanklineEnable
    autocmd BufWinEnter *.scss silent! :set syntax=scss
  augroup end
]]

--Set highlight on search
vim.o.hlsearch = false

--Make line numbers default
vim.wo.number = true

--Enable mouse mode
vim.o.mouse = 'a'

--Don't wrap line
vim.o.wrap = false

--Set padding when scrolling
vim.o.scrolloff = 2

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.o.signcolumn = 'yes:3'
vim.o.cmdheight = 2
vim.o.showmode = false

--Colorscheme gruvbox dark hard (original, not material)
vim.o.termguicolors = true
vim.o.background = 'dark'
-- vim.cmd('colorscheme gruvbox-material')
vim.g.gruvbox_contrast_dark = 'hard'
vim.cmd([[colorscheme gruvbox]])

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect,noinsert'

-- use prettierd for faster formatting
-- vim.b.prettier_exec_cmd = "prettierd"

-- use system clipboard
vim.o.clipboard = "unnamedplus"

--Set statusbar
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    -- component_separators = { left = '', right = ''},
    -- section_separators = { left = '', right = ''},
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'diff', 'branch'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
}

--Enable Comment.nvim
require('Comment').setup()

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
-- vim.g.indent_blankline_char = '┊'
-- vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
-- vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
-- vim.g.indent_blankline_show_trailing_blankline_indent = false
vim.g.indent_blankline_filetype = {'vim', 'NvimTree', 'html', 'php'}

-- Gitsigns
require('gitsigns').setup {
  signs = {
    -- add = { text = '+' },
    -- change = { text = '~' },
    -- delete = { text = '_' },
    -- topdelete = { text = '‾' },
    -- changedelete = { text = '~' },
  },
}

-- Telescope
require('telescope').setup {
  defaults = {
    file_ignore_patterns = {
      "node_modules"
    },
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native
require('telescope').load_extension 'fzf'
require('telescope').load_extension 'projects'

-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = {
        "html", "html5",
    },
    custom_captures = {
      -- with custom nfejzic/gruvbox theme
      -- ["ref_specifier"] = "TSConstant",
    },
  },
  playground = {
    enable = true,
    disable = { "c" },
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {},
  },
  incremental_selection = {
    enable = false,
    disable = { "c" },
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
  indent = {
    enable = false,
    disable = { "c", "html5", "html" }
  },
  context_commentstring = {
    enable = false
  },
  textobjects = {
    select = {
      enable = false,
      disable = { "c" },
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      disable = { "c" },
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
  },
}

-- Diagnostic keymaps
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>lk', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>lj', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true })


-- Format on save
vim.cmd [[
  augroup Format_on_save
    autocmd!
    autocmd BufWritePre * lua vim.lsp.buf.formatting_seq_sync()
    " autocmd BufWritePre *.*css,*.less,*.html,*.ts,*.vue :Prettier<CR>
  augroup end
]]

-- These commands will navigate through buffers in order regardless of which mode you are using
-- e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
vim.api.nvim_set_keymap('n', '<leader>bc', '<cmd>BufferClose<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>bC', '<cmd>BufferClose!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<cmd>BufferNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', '<cmd>BufferPrevious<CR>', { noremap = true, silent = true })

require('nvim-autopairs').setup{}
require('project_nvim').setup{}

vim.g.nvim_tree_respect_buf_cwd = 0
require('nvim-tree').setup{
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  view = {
    side = 'left',
    auto_resize = true,
    hide_root_folder = false,
    width = 30,
  },
  quit_on_open = 0
}

vim.api.nvim_set_keymap('n', '<leader>ft', '<cmd>NvimTreeToggle<CR>', { noremap = true, silent = true })

--Add leader shortcuts

local wk = require('which-key')

wk.register({
  ['<leader>'] = {
    f = {
      name = "Find/File",
      f = { "<cmd>lua require('telescope.builtin').find_files({ find_command = { 'rg', '--files', '--hidden', '--follow', '--ignore-file', '.gitignore' } })<CR>",  "Find file" },
      b = { '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find({ find_command = "rg" })<CR>',  "Fuzzy search in buffer" },
      t = { "<cmd>NvimTreeToggle<CR>",  "Open File Tree" },
      p = { "<cmd>Telescope projects<CR>", "Recent projects" }
    },
    b = {
      name = "Buffer",
      c = "Close buffer",
      b = { "<cmd>lua require('telescope.builtin').buffers()<CR>", 'Telescope search buffers' },
    },
    s = {
      name = "Search",
      d = { "<cmd>lua require('telescope.builtin').grep_string({ find_command = 'rg' })<CR>",  'Grep string' },
      p = { "<cmd>lua require('telescope.builtin').live_grep({ find_command = 'rg' })<CR>", 'Live grep string' },
      s = { "<cmd>lua require('telescope.builtin').treesitter()<CR>", 'Treesitter Document Symbols' },
    },
    k = {
      name = "Collapse / Fold",
      k = { "<cmd>foldclose<CR>", "Fold" },
      o = { "<cmd>foldopen<CR>", "Unfold (open fold)" },
      O = { "zR", "Unfold all (open fold)" },
    },
    ['<space>'] = { "<C-^>", 'Switch to previous buffer' },
    e = "Lsp Diagnostics popup",
    ['?'] = { "<cmd>lua require('telescope.builtin').oldfiles()<CR>",  "Telescope - Old Files" }
  }
})

vim.g.bufferline = {
  animation = false,
}
