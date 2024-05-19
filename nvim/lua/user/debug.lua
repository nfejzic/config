local dap = require("dap")
local ui = require("dapui")

require("nvim-dap-virtual-text").setup({
	-- Don't show virtual text for sensitive variables. Probably
	-- won't catch all of them.
	display_callback = function(variable)
		local name = string.lower(variable.name)
		local value = string.lower(variable.value)
		if name:match("secret") or name:match("api") or value:match("secret") or value:match("api") then
			return "*****"
		end

		if #variable.value > 15 then
			return " = " .. string.sub(variable.value, 1, 15) .. "... "
		end

		return " = " .. variable.value
	end,
})

ui.setup()
require("dap-go").setup()
require("user.debug_adapters.c_cpp").setup(dap)
require("user.debug_adapters.typescript").setup(dap)

-- setup keymaps
require("user.keymaps").dap(dap, ui)

dap.listeners.before.attach.dapui_config = function()
	ui.open()
end
dap.listeners.before.launch.dapui_config = function()
	ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	ui.close()
end
