local utils = require("user.utils")

if not utils.is_nix() then
	require("plugins.install")
end

require("plugins.blink")
require("plugins.colors")
require("plugins.conform")
require("plugins.debug")
require("plugins.git")
require("plugins.go")
require("plugins.lazydev")
require("plugins.lsp")
require("plugins.lualine")
require("plugins.markdown")
require("plugins.neotest")
require("plugins.oil")
require("plugins.quicker")
require("plugins.rust")
require("plugins.smart_splits")
require("plugins.snacks")
require("plugins.treesitter")
