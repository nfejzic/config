local trouble = require('trouble.providers.telescope')

require('telescope').setup {
  defaults = {
    file_ignore_patterns = {
      "node_modules"
    },
    layout_strategy = 'vertical',
    mappings = {
      n = {
        ['dd'] = require('telescope.actions').delete_buffer,
        ["<C-t>"] = trouble.open_with_trouble,
      },
      i = {
        ["<C-t>"] = trouble.open_with_trouble,
      },
    },
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_cursor()
    }
  },
}

-- Use Telescope for LSP Code Actions
require('telescope').load_extension('ui-select')

-- Enable telescope fzf native
require('telescope').load_extension 'fzf'
require('telescope').load_extension 'projects'

-- NOTE: Currently (on neovim nightly) there's a problem with telescope where
-- fin_files opens the file in insert mode. This is a workaround for that
-- problem
vim.api.nvim_create_autocmd(
  "WinLeave", {
    callback = function()
      -- Prevent entering buffers in insert mode.
      if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
      end
    end,
  })
