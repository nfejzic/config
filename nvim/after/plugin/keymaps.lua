local wk = require("wk")

wk.register({
  ['<leader>'] = {
    f = {
      name = "Find/File",
      f = {
        "<cmd>lua require('telescope.builtin').find_files({ find_command = { 'rg', '--files', '--hidden', '--follow', '--ignore-file', '.gitignore' } })<CR>",
        "Find file" },
      t = { "<cmd>Neotree toggle<CR>", "Open File Tree" },
      r = { "<cmd>Neotree reveal<CR>", "Reveal current file in the sidebar" },
      p = { "<cmd>Telescope projects<CR>", "Recent projects" },
      d = { "<cmd>TodoTelescope<CR>", "Todo / Fixme etc." },
      g = { "<cmd>Telescope git_status<CR>", "git - modified files" },
    },
    b = { "<cmd>lua require('telescope.builtin').buffers()<CR>", 'Telescope search buffers' },
    B = {
      name = "Buffer",
      c = { "<cmd>BufferClose<CR>", "Close buffer" },
      C = { "<cmd>BufferClose!<CR>", "Close buffer ignore changes" },
      b = { "<cmd>lua require('telescope.builtin').buffers()<CR>", 'Telescope search buffers' },
    },
    s = {
      name = "Search",
      d = { "<cmd>lua require('telescope.builtin').grep_string()<CR>", 'Grep string' },
      l = { "<cmd>lua require('telescope.builtin').live_grep()<CR>", 'Live grep string' },
      L = {
        "<cmd>lua require('telescope.builtin').live_grep({ additional_args = function () return {'--case-sensitive'} end })<CR>",
        'Live grep string' },
      s = { '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find({ find_command = "rg" })<CR>',
        "Fuzzy search in buffer" },
    },
    k = {
      name = "Collapse / Fold",
      k = { "<cmd>foldclose<CR>", "Fold" },
      K = { "<cmd>foldclose<CR>", "Fold all" },
      o = { "<cmd>foldopen<CR>", "Unfold (open fold)" },
      O = { "zR", "Unfold all (open fold)" },
    },
    ['<space>'] = { "<C-^>", 'Switch to previous buffer' },
    e = "Lsp Diagnostics popup",
    ['?'] = { "<cmd>lua require('telescope.builtin').oldfiles()<CR>", "Telescope - Old Files" },
  },
  -- ['<C-l>'] = { "<cmd>BufferNext<CR>", "Go to next buffer" },
  -- ['<C-h>'] = { "<cmd>BufferPrevious<CR>", "Go to previous buffer" },
  [']'] = {
    q = { '<cmd>cn<CR>', 'Next quickfix entry' },
    b = { "<cmd>bnext<CR>", "Go to next buffer" },
  },
  ['['] = {
    q = { '<cmd>cp<CR>', 'Previous quickfix entry' },
    b = { "<cmd>bprevious<CR>", "Go to previous buffer" },
  }
})

local trouble_exists, trouble = pcall(require, "trouble")

if trouble_exists then
  wk.register({
    [']'] = {
      t = { function() trouble.next({ skip_groups = true, jump = true }) end, 'Next Trouble entry' },
    },
    ['['] = {
      t = { function() trouble.previous({ skip_groups = true, jump = true }) end, 'Previous Trouble entry' },
    }
  })
end
