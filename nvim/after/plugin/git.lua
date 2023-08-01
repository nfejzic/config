local wk = require('which-key')

require("gitsigns").setup {
  signs = {
    -- add = { text = '+' },
    -- change = { text = '~' },
    -- delete = { text = '_' },
    -- topdelete = { text = '‾' },
    -- changedelete = { text = '~' },
  },
  numhl = true,
  current_line_blame = true,
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
      j = { '<cmd>Gitsigns next_hunk<CR>', 'Next hunk' },
      k = { '<cmd>Gitsigns prev_hunk<CR>', 'Previous hunk' },
      p = { '<cmd>Gitsigns preview_hunk<CR>', 'Preview hunk' },
      s = { '<cmd>Gitsigns stage_hunk<CR>', 'Stage hunk' },
      u = { '<cmd>Gitsigns undo_stage_hunk<CR>', 'Undo stage hunk' },
      r = { '<cmd>Gitsigns reset_hunk<CR>', 'Reset hunk' },
      d = { '<cmd>Gitsigns diffthis<CR>', 'Diff this' },
      q = { '<cmd>Gitsigns setqflist<CR>', 'Show changes in quickfix list' },
    }
  }
})

-- fugitive specific, also requires 'tpope/vim-fugitive'
wk.register({
  ['<leader>'] = {
    g = {
      name = 'Git',
      G = { '<cmd>G<CR>', 'Git status' }
    },
    -- Git merge:
    m = {
      name = 'Merge',
      h = { '<cmd>diffget //2<CR>', 'Use ours' },
      l = { '<cmd>diffget //2<CR>', 'Use theirs' },
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

function setDiffviewKeybinds()
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
