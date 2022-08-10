vim.o.smarttab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.relativenumber = true

-- load plugins

require('plugins')
require('config_lsp')
require('dap_config')

vim.cmd [[
  set nofoldenable
  augroup on_open
    autocmd!
    autocmd BufWinEnter *.html5 silent! :set filetype=html
    autocmd BufWinEnter *.html5 silent! :set syntax=php
    autocmd BufWinEnter *.php silent! :set syntax=php
    autocmd BufWinEnter *.html5 silent! :IndentBlanklineEnable
    autocmd BufWinEnter *.scss silent! :set syntax=scss
    autocmd BufWinEnter *.vue silent! :set shiftwidth=2
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

vim.o.signcolumn = 'yes:2'

vim.o.cmdheight = 2
vim.o.showmode = false

--Colorscheme gruvbox dark hard (original, not material)
vim.o.termguicolors = true
-- vim.o.background = 'light'
-- vim.cmd('colorscheme gruvbox-material')
vim.g.gruvbox_contrast_dark = 'hard'

local colors = require("catppuccin.palettes").get_palette()
require("catppuccin").setup({
    styles = {
        comments = { "italic" },
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
    },
    integrations = {
        treesitter = true,
        native_lsp = {
            enabled = true,
        },
        lsp_trouble = true,
        cmp = true,
        gitsigns = true,
        telescope = true,
        dap = {
            enabled = true,
            enable_ui = true,
        },
        which_key = true,
        indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
        },
        dashboard = true,
        neogit = true,
        barbar = true,
        bufferline = true,
        markdown = true,
        ts_rainbow = false,
        notify = true,
        telekasten = true,
        symbols_outline = true,
    },
    custom_highlights = {
        TSNamespace = { style = {} },
        rustTSRefSpecifier = { fg = colors.yellow, style = {} },
        rustTSMutableSpecifier = { fg = colors.yellow, style = {} }
    }
})

vim.g.tokyonight_style = "night"
vim.g.catppuccin_flavour = "mocha"
vim.cmd([[colorscheme catppuccin]])
-- vim.cmd([[colorscheme solarized]])
-- vim.cmd([[colorscheme gruvbox]])
-- vim.cmd([[colorscheme tokyonight]])
-- vim.cmd([[colorscheme nightfox]])

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect,noinsert'

-- use system clipboard
vim.o.clipboard = "unnamedplus"

--Set statusbar
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        -- component_separators = { left = '', right = ''},
        -- section_separators = { left = '', right = ''},
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'diff', 'branch' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
}

-- global statusline
vim.o.laststatus = 3

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
vim.g.indent_blankline_filetype = { 'vim', 'NvimTree', 'html', 'php' }

-- Telescope
require('telescope').setup {
    defaults = {
        file_ignore_patterns = {
            "node_modules"
        },
        mappings = {
            i = {
                -- ['<C-u>'] = false,
                -- ['<C-d>'] = false,
            },
        },
        layout_strategy = 'vertical',
        -- vimgrep_arguments = {
        --   'rg',
        --   '--color=never',
        --   '--no-heading',
        --   '--with-filename',
        --   '--line-number',
        --   '--column',
        --   '--smart-case',
        --   '--hidden',
        -- }
    },
    extensions = {
        ['ui-select'] = {
            require('telescope.themes').get_cursor()
        }
    }
}

-- Use Telescope for LSP Code Actions
require('telescope').load_extension('ui-select')

-- Enable telescope fzf native
require('telescope').load_extension 'fzf'
require('telescope').load_extension 'projects'

-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true, -- false will disable the whole extension
        disable = {
            "html", "html5"
        },
        custom_captures = {
            -- with custom nfejzic/gruvbox theme
            ["ref_specifier"] = "rustTSRefSpecifier",
            ["mutable_specifier"] = "rustTSMutableSpecifier",

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
        disable = { "c", "vue" },
        keymaps = {
            init_selection = 'gnn',
            node_incremental = 'grn',
            scope_incremental = 'grc',
            node_decremental = 'grm',
        },
    },
    indent = {
        enable = true,
        disable = { "c", "html5", "html", "vue" }
    },
    context_commentstring = {
        enable = true
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
    autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()
  augroup end
]]

-- These commands will navigate through buffers in order regardless of which mode you are using
-- e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
vim.api.nvim_set_keymap('n', '<leader>bc', '<cmd>BufferClose<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>bC', '<cmd>BufferClose!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<cmd>BufferNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', '<cmd>BufferPrevious<CR>', { noremap = true, silent = true })

require('nvim-autopairs').setup {}
require('project_nvim').setup {}

require('nvim-tree').setup {
    sync_root_with_cwd = true,
    update_focused_file = {
        enable = true,
        update_root = true,
    },
    view = {
        side = 'left',
    },
}

vim.api.nvim_set_keymap('n', '<leader>ft', '<cmd>NvimTreeToggle<CR>', { noremap = true, silent = true })

--Add leader shortcuts

local wk = require('which-key')

wk.register({
    ['<leader>'] = {
        f = {
            name = "Find/File",
            f = { "<cmd>lua require('telescope.builtin').find_files({ find_command = { 'rg', '--files', '--hidden', '--follow', '--ignore-file', '.gitignore' } })<CR>",
                "Find file" },
            b = { '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find({ find_command = "rg" })<CR>',
                "Fuzzy search in buffer" },
            t = { "<cmd>NvimTreeToggle<CR>", "Open File Tree" },
            p = { "<cmd>Telescope projects<CR>", "Recent projects" },
            d = { "<cmd>TodoTelescope<CR>", "Todo / Fixme etc." }
        },
        b = {
            name = "Buffer",
            c = "Close buffer",
            b = { "<cmd>lua require('telescope.builtin').buffers()<CR>", 'Telescope search buffers' },
        },
        s = {
            name = "Search",
            d = { "<cmd>lua require('telescope.builtin').grep_string()<CR>", 'Grep string' },
            l = { "<cmd>lua require('telescope.builtin').live_grep()<CR>", 'Live grep string' },
            L = { "<cmd>lua require('telescope.builtin').live_grep({ additional_args = function () return {'--case-sensitive'} end })<CR>",
                'Live grep string' },
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
        ['?'] = { "<cmd>lua require('telescope.builtin').oldfiles()<CR>", "Telescope - Old Files" },
    }
})

-- Gitsigns
local has_gitsigns, _ = pcall(require, 'gitsigns.nvim')

if has_gitsigns then
    require("gitsigns").setup {
        signs = {
            -- add = { text = '+' },
            -- change = { text = '~' },
            -- delete = { text = '_' },
            -- topdelete = { text = '‾' },
            -- changedelete = { text = '~' },
        },
        current_line_blame = true,
        -- current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    }

    wk.register({
        ['<leader>'] = {
            g = {
                name = 'Git',
                j = { '<cmd>Gitsigns next_hunk<CR>', 'Next hunk' },
                k = { '<cmd>Gitsigns prev_hunk<CR>', 'Previous hunk' },
                p = { '<cmd>Gitsigns preview_hunk<CR>', 'Preview hunk' },
                s = { '<cmd>Gitsigns stage_hunk<CR>', 'Stage hunk' },
                u = { '<cmd>Gitsigns stage_hunk<CR>', 'Unstage hunk' },
                r = { '<cmd>Gitsigns reset_hunk<CR>', 'Reset hunk' },
                d = { '<cmd>Gitsigns diffthis<CR>', 'Diff this' },
                q = { '<cmd>Gitsigns setqflist<CR>', 'Show changes in quickfix list' },
            }
        }
    })
end

-- fugitive specific, also requires 'tpope/vim-fugitive'
wk.register({
    ['<leader>'] = {
        g = {
            name = 'Git',
            g = { '<cmd>G<CR>', 'Git status' }
        },
        -- Git merge:
        m = {
            name = 'Merge',
            h = { '<cmd>diffget //2<CR>', 'Use ours' },
            l = { '<cmd>diffget //2<CR>', 'Use theirs' },
        }
    }
})

local has_trouble, trouble = pcall(require, "trouble")

if has_trouble then
    trouble.setup {}

    wk.register({
        t = {
            name = "Trouble",
            q = { '<cmd>TroubleToggle quickfix<CR>', 'Quickfix' },
            l = { '<cmd>TroubleToggle loclist<CR>', 'Loclist' },
            d = { '<cmd>TroubleToggle document_diagnostics<CR>', 'Document Diagnostics' },
            w = { '<cmd>TroubleToggle workspace_diagnostics<CR>', 'Workspace Diagnostics' },
            t = { '<cmd>TodoTrouble<CR>', 'TODO / FIXME etc.' },
        }
    })
end

vim.g.bufferline = {
    animation = false,
}

require('colorizer').setup()
