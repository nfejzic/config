require("user.opts")
require("user.lazy")
require("user.keymaps")
require("user.autocommands")

require("user.lsp").setup()

vim.cmd("colo colorize")
