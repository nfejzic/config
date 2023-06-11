-- ensure Lazy.nvim is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim' },

    -- LSP
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "neovim/nvim-lspconfig" },
    {
        "lvimuser/lsp-inlayhints.nvim",
        branch = "anticonceal",
        config = function()
            require("lsp-inlayhints").setup()
        end
    },

    -- loading status for LSPs
    { 'j-hui/fidget.nvim' },

    -- Lightbulb in statusbar
    { 'kosayoda/nvim-lightbulb' },

    -- JSON settings for individual language servers
    { 'tamago324/nlsp-settings.nvim' },

    -- Icons in auto-complete of LSP (i.e. function, variable etc)
    { 'onsails/lspkind-nvim' },

    -- Lints, Formatters etc
    { 'jose-elias-alvarez/null-ls.nvim' },

    -- Typescript utilities
    { "jose-elias-alvarez/nvim-lsp-ts-utils" },

    -- Nicer 'quickfix' for LSP diagnostics (and others, like TODO lists)
    {
        "folke/trouble.nvim",
        dependencies = "kyazdani42/nvim-web-devicons",
    },

    -- Autocomplete
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp-signature-help' },
    { 'L3MON4D3/LuaSnip' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'mattn/emmet-vim' },        -- emmet for html etc
    { "zbirenbaum/copilot.lua" }, -- lua impl of Github Copilot
    {
        "zbirenbaum/copilot-cmp",
        dependencies = { "copilot.lua" },
    },

    -- Rust
    { 'simrat39/rust-tools.nvim' },

    -- Debugging
    { 'mfussenegger/nvim-dap' },
    { "rcarriga/nvim-dap-ui",      dependencies = { "mfussenegger/nvim-dap" } },

    -- for javascript / typescript debugging
    { "mxsdev/nvim-dap-vscode-js", dependencies = { "mfussenegger/nvim-dap" } },
    {
        "microsoft/vscode-js-debug",
        lazy = true,
        build = "npm install --legacy-peer-deps && npm run compile"
    },
    -- Syntax (TreeSitter)
    { 'nvim-treesitter/nvim-treesitter',            build = ':TSUpdate' },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    -- use 'JoosepAlviste/nvim-ts-context-commentstring'
    { 'nvim-treesitter/playground' },

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Show TODO, FIX, HACK comments in telescope
    {
        "folke/todo-comments.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup {}
        end
    },

    { 'lukas-reineke/indent-blankline.nvim' },

    -- UI
    { 'nvim-lualine/lualine.nvim',          dependencies = { 'kyazdani42/nvim-web-devicons', lazy = false } },
    { 'luukvbaal/stabilize.nvim' }, -- Stabilize nvim windows

    -- Git
    { 'lewis6991/gitsigns.nvim',            dependencies = { 'nvim-lua/plenary.nvim' } }, -- git signs in gutter
    {
        -- GitHub PR UI
        'pwntester/octo.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'kyazdani42/nvim-web-devicons',
        },
        config = function()
            require "octo".setup()
        end
    },

    -- magit clone for neovim
    -- use 'TimUntersberger/neogit'

    -- git stuff from the tpope
    { 'tpope/vim-fugitive' },

    -- git diff view and merge tool
    { 'sindrets/diffview.nvim', dependencies = 'nvim-lua/plenary.nvim' },

    -- show help popup for keymaps (like in emacs)
    {
        "folke/which-key.nvim",
    },

    -- nice file tree
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            {
                -- needed to use the commands with "_with_window_picker" suffix
                's1n7ax/nvim-window-picker',
                version = "v1.*",
            }
        }
    },

    -- gruvbox with slight modification
    -- use 'nfejzic/gruvbox.nvim'

    -- original gruvbox colorscheme
    { 'ellisonleao/gruvbox.nvim' },

    -- some nice themes
    { 'folke/tokyonight.nvim' },
    { 'EdenEast/nightfox.nvim' },
    { 'RRethy/nvim-base16' },
    { 'ishan9299/nvim-solarized-lua' },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        config = function()
            vim.cmd("colorscheme catppuccin")
        end
    },
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        -- config = function()
        --     vim.cmd("colorscheme rose-pine")
        -- end
    },
    { 'shaunsingh/nord.nvim' },

    -- Tabline
    -- use { 'romgrk/barbar.nvim', requires = { 'kyazdani42/nvim-web-devicons' } }

    -- Languages (indentation and more)
    -- use 'sheerun/vim-polyglot' -- is very slow in some files!
    { 'tpope/vim-sleuth' },

    -- automatically add pairs for (), {}, etc
    { 'windwp/nvim-autopairs' },

    -- Projects
    { "ahmedkhalf/project.nvim" },

    -- HTML tags auto-edit pair
    { 'AndrewRadev/tagalong.vim' },

    -- Add BG color for hex color values
    { 'norcalli/nvim-colorizer.lua' },

    -- Enable repeat for more actions
    { 'tpope/vim-repeat' },

    -- Surround
    { 'tpope/vim-surround' },

    -- kdl syntax and indent
    { 'imsnif/kdl.vim' },

    -- nice ui enhancements
    { 'stevearc/dressing.nvim' },

    -- plugin caching for faster loading
    { 'lewis6991/impatient.nvim' },
}, {})
