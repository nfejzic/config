require('rose-pine').setup({
  variant = 'auto',
  disable_float_background = true,

  -- Change specific vim highlight groups
  -- https://github.com/rose-pine/neovim/wiki/Recipes
  highlight_groups = {
    Keyword = { fg = 'iris', bg = 'none' },
    ["@interface"] = { fg = 'gold', bg = 'none' },
    -- ColorColumn = { bg = 'rose' },

    -- Blend colours against the "base" background
    -- CursorLine = { bg = 'foam', blend = 10 },
    -- StatusLine = { fg = 'love', bg = 'love', blend = 10 },
  }
})

-- vim.cmd("colo rose-pine")
