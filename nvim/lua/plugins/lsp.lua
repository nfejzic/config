local utils = require("user.utils")

if utils.is_llm_prompt() then
	return
end

-- shows LSP loading
require("fidget").setup()
