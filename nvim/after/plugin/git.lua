local wk = require('which-key')
local gs = require("gitsigns")

gs.setup {
  signs = {
    -- add = { text = '+' },
    -- change = { text = '~' },
    -- delete = { text = '_' },
    -- topdelete = { text = '‾' },
    -- changedelete = { text = '~' },
  },
  numhl = false,
  current_line_blame = false,
  preview_config = {
    border = 'rounded'
  }
  -- current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
}

wk.register({
  [']'] = {
    g = { '<cmd>Gitsigns next_hunk<CR>', 'Next git hunk' },
  },
  ['['] = {
    g = { '<cmd>Gitsigns prev_hunk<CR>', 'Previous git hunk' },
  },
  ['<leader>'] = {
    g = {
      name = 'Git',
      b = { '<cmd>Gitsigns blame_line<CR>', 'Blame current line' },
      B = { function() gs.blame_line({ full = true }) end,
        'Blame current line with full commit message and hunk preview' },
      j = { '<cmd>Gitsigns next_hunk<CR>', 'Next hunk' },
      k = { '<cmd>Gitsigns prev_hunk<CR>', 'Previous hunk' },
      p = { '<cmd>Gitsigns preview_hunk<CR>', 'Preview hunk' },
      P = { '<cmd>Gitsigns preview_hunk_inline<CR>', 'Preview hunk inline' },
      s = { '<cmd>Gitsigns stage_hunk<CR>', 'Stage hunk' },
      u = { '<cmd>Gitsigns undo_stage_hunk<CR>', 'Undo stage hunk' },
      r = { '<cmd>Gitsigns reset_hunk<CR>', 'Reset hunk' },
      d = { '<cmd>Gitsigns diffthis<CR>', 'Diff this' },
      q = { '<cmd>Gitsigns setqflist<CR>', 'Show changes in quickfix list' },
    }
  }
})

wk.register({
  ['<leader>'] = {
    g = {
      name = 'Git',
      g = { '<cmd>:DiffviewOpen<CR>', 'Open Diff View' },
      c = { '<cmd>:DiffviewClose<CR>', 'Close Diff View' },
    }

  }
})

local function setDiffviewKeybinds()
  vim.keymap.set('n', '<leader>gt', '<cmd>:DiffviewToggleFiles<CR>', {
    desc = 'Toggle Diff View Files'
  })
end

vim.api.nvim_create_augroup("bufcheck", { clear = true })
vim.api.nvim_create_autocmd("Filetype", {
  group = "bufcheck",
  pattern = { "DiffviewFiles" },
  callback = setDiffviewKeybinds
})

require('diffview').setup({
  view = {
    merge_tool = {
      layout = "diff3_mixed"
    }
  }
})
