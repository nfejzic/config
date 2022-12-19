local wk = require('which-key')

wk.register({
  ['<leader>'] = {
    f = {
      name = "Find/File",
      f = { "<cmd>lua require('telescope.builtin').find_files({ find_command = { 'rg', '--files', '--hidden', '--follow', '--ignore-file', '.gitignore' } })<CR>",
        "Find file" },
      b = { '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find({ find_command = "rg" })<CR>',
        "Fuzzy search in buffer" },
      t = { "<cmd>Neotree toggle<CR>", "Open File Tree" },
      p = { "<cmd>Telescope projects<CR>", "Recent projects" },
      d = { "<cmd>TodoTelescope<CR>", "Todo / Fixme etc." },
      g = { "<cmd>Telescope git_status<CR>", "git - modified files" },
    },
    b = {
      name = "Buffer",
      c = { "<cmd>BufferClose<CR>", "Close buffer" },
      C = { "<cmd>BufferClose!<CR>", "Close buffer ignore changes" },
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

vim.api.nvim_set_keymap('n', '<C-l>', '<cmd>BufferNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', '<cmd>BufferPrevious<CR>', { noremap = true, silent = true })
