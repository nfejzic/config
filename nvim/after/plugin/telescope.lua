require('telescope').setup {
  defaults = {
    file_ignore_patterns = {
      "node_modules"
    },
    layout_strategy = 'vertical',
    mappings = {
      n = {
        ['dd'] = require('telescope.actions').delete_buffer
      }
    }
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
