-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require('packer').startup(function(use)
    -- Packer
    use 'wbthomason/packer.nvim'

    -- "gc" to comment visual regions/lines
    use 'numToStr/Comment.nvim'

    -- LSP
    use {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    }

    -- loading status for LSPs
    use 'j-hui/fidget.nvim'

    -- Lightbulb in statusbar
    use 'kosayoda/nvim-lightbulb'

    -- JSON settings for individual language servers
    use 'tamago324/nlsp-settings.nvim'

    -- Icons in auto-complete of LSP (i.e. function, variable etc)
    use 'onsails/lspkind-nvim'

    -- Lints, Formatters etc
    use 'jose-elias-alvarez/null-ls.nvim'

    -- Typescript utilities
    use "jose-elias-alvarez/nvim-lsp-ts-utils"

    -- Nicer 'quickfix' for LSP diagnostics (and others, like TODO lists)
    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
    }

    -- Autocomplete
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    use 'mattn/emmet-vim' -- emmet for html etc

    -- Rust
    use 'simrat39/rust-tools.nvim'

    -- Debugging
    use 'mfussenegger/nvim-dap'
    use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }

    -- for javascript / typescript debugging
    use { "mxsdev/nvim-dap-vscode-js", requires = { "mfussenegger/nvim-dap" } }
    use {
        "microsoft/vscode-js-debug",
        opt = true,
        run = "npm install --legacy-peer-deps && npm run compile"
    }
    -- Syntax (TreeSitter)
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    -- use 'JoosepAlviste/nvim-ts-context-commentstring'
    use 'nvim-treesitter/playground'

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/plenary.nvim' }
    }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use { 'nvim-telescope/telescope-ui-select.nvim' }

    -- Show TODO, FIX, HACK comments in telescope
    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup {}
        end
    }

    use 'lukas-reineke/indent-blankline.nvim'

    -- UI
    use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
    use 'luukvbaal/stabilize.nvim' -- Stabilize nvim windows

    -- Git
    use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } } -- git signs in gutter
    use {                                                                     -- GitHub PR UI
        'pwntester/octo.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'kyazdani42/nvim-web-devicons',
        },
        config = function()
            require "octo".setup()
        end
    }

    -- magit clone for neovim
    -- use 'TimUntersberger/neogit'

    -- git stuff from the tpope
    use 'tpope/vim-fugitive'

    -- git diff view and merge tool
    use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }

    -- show help popup for keymaps (like in emacs)
    use {
        "folke/which-key.nvim",
    }

    -- nice file tree
    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            {
                -- needed to use the commands with "_with_window_picker" suffix
                's1n7ax/nvim-window-picker',
                tag = "v1.*",
            }
        }
    }

    -- gruvbox with slight modification
    use 'nfejzic/gruvbox.nvim'

    -- some nice themes
    use 'folke/tokyonight.nvim'
    use 'EdenEast/nightfox.nvim'
    use 'RRethy/nvim-base16'
    use 'ishan9299/nvim-solarized-lua'
    use { "catppuccin/nvim", as = "catppuccin" }
    use 'shaunsingh/nord.nvim'

    -- Tabline
    -- use { 'romgrk/barbar.nvim', requires = { 'kyazdani42/nvim-web-devicons' } }

    -- Languages (indentation and more)
    -- use 'sheerun/vim-polyglot' -- is very slow in some files!
    use 'tpope/vim-sleuth'
    -- use 'windwp/nvim-autopairs'

    -- Projects
    use "ahmedkhalf/project.nvim"

    -- HTML tags auto-edit pair
    use 'AndrewRadev/tagalong.vim'

    -- Add BG color for hex color values
    use 'norcalli/nvim-colorizer.lua'

    -- Enable repeat for more actions
    use 'tpope/vim-repeat'

    -- Surround
    use 'tpope/vim-surround'

    -- kdl syntax and indent
    use 'imsnif/kdl.vim'

    -- nice ui enhancements
    use 'stevearc/dressing.nvim'

    -- plugin caching for faster loading
    use 'lewis6991/impatient.nvim'
end)
