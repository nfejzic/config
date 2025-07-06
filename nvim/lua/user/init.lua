require("user.opts")
require("user.lazy")
require("user.keymaps").general()

require("user.lsp").setup()

vim.cmd("colo colorize")
