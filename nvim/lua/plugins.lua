-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- "gc" to comment visual regions/lines
    use 'numToStr/Comment.nvim'

    -- LSP
    use 'williamboman/nvim-lsp-installer'
    use 'neovim/nvim-lspconfig'
    use 'j-hui/fidget.nvim'
    use 'kosayoda/nvim-lightbulb'
    use 'tamago324/nlsp-settings.nvim'
    use 'onsails/lspkind-nvim'
    use 'jose-elias-alvarez/null-ls.nvim'
    use "jose-elias-alvarez/nvim-lsp-ts-utils"

    -- using prettier as formatter (scss, css etc.)
    use 'MunifTanjim/prettier.nvim'

    -- Autocomplete
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    use 'mattn/emmet-vim' -- emmet for html etc
    -- use "rafamadriz/friendly-snippets"

    -- Rust
    use 'simrat39/rust-tools.nvim'

    -- Debugging
    use 'nvim-lua/plenary.nvim'
    use 'mfussenegger/nvim-dap'

    -- Syntax (TreeSitter)
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    -- use 'nvim-treesitter/nvim-treesitter-textobjects'
    -- use 'JoosepAlviste/nvim-ts-context-commentstring'
    use 'nvim-treesitter/playground'

    -- Telescope
    use {
	'nvim-telescope/telescope.nvim',
	requires = {'nvim-lua/plenary.nvim'}
    }
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    -- Show TODO, FIX, HACK comments in telescope
    use {
      "folke/todo-comments.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("todo-comments").setup {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      end
    }

    use 'lukas-reineke/indent-blankline.nvim'

    -- UI
    use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
    use 'luukvbaal/stabilize.nvim' -- Stabilize nvim windows
    -- use 'crivotz/nvim-colorizer.lua'

    -- Git
    use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } } -- git signs in gutter
    use { -- GitHub PR UI
      'pwntester/octo.nvim',
      requires = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
        'kyazdani42/nvim-web-devicons',
      },
      config = function ()
        require"octo".setup()
      end
    }
    use 'TimUntersberger/neogit'

    use {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup {}
        end
    }

    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
          'kyazdani42/nvim-web-devicons', -- optional, for file icon
        },
    }

    -- Themes
    use 'nfejzic/gruvbox.nvim'
    -- use 'RRethy/nvim-base16'

    -- Tabline
    use { 'romgrk/barbar.nvim', requires = {'kyazdani42/nvim-web-devicons'} }

    -- Easier lua dev (working with init.lua)
    -- use 'folke/lua-dev.nvim'

    -- Languages (indentation and more)
    -- use 'sheerun/vim-polyglot'
    use 'windwp/nvim-autopairs'

    -- Projects
    use "ahmedkhalf/project.nvim"

    -- HTML tags auto-edit pair
    use 'AndrewRadev/tagalong.vim'

    -- Enable repeat for more actions
    use 'tpope/vim-repeat'

    -- Surround
    use 'tpope/vim-surround'
end)
