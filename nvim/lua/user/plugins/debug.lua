local gh = require("user.plugins.lib").github

vim.pack.add({
	gh "mfussenegger/nvim-dap",

	-- dependencies
	gh "leoluz/nvim-dap-go",
	gh "rcarriga/nvim-dap-ui",
	gh "theHamsta/nvim-dap-virtual-text",
	gh "nvim-neotest/nvim-nio",
	gh "mxsdev/nvim-dap-vscode-js",

	-- NOTE: depends on mason, but that's loaded as part of LSP, and is used
	--	     only for installation of debuggers
})

local M = nil

local function instance()
	if M == nil then
		local dap = require("dap")
		local dapui = require("dapui")

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

		dapui.setup()
		require("dap-go").setup()
		require("user.debug_adapters.c_cpp").setup(dap)
		require("user.debug_adapters.typescript").setup(dap)

		dap.listeners.before.attach.dapui_config = dapui.open
		dap.listeners.before.launch.dapui_config = dapui.open
		dap.listeners.before.event_terminated.dapui_config = dapui.close
		dap.listeners.before.event_exited.dapui_config = dapui.close

		M = {
			dap = dap,
			dapui = dapui,
		}

		vim.notify("Loaded DAP")
	end

	return M
end

local keymaps = require("user.core.keymaps")

-- setup keymaps
keymaps.set_keys({
	{ "n", "<leader>dp", function() instance().dap.toggle_breakpoint() end, "Toggle breakpoint" },

	-- Stepping
	{ "n", "<leader>dc", function() instance().dap.continue() end,          "Debug Continue" },
	{ "n", "<leader>di", function() instance().dap.step_into() end,         "Debug Step Into" },
	{ "n", "<leader>do", function() instance().dap.step_out() end,          "Debug Step Out" },
	{ "n", "<leader>dj", function() instance().dap.step_over() end,         "Debug Step Over" },
	{ "n", "<leader>dk", function() instance().dap.step_back() end,         "Debug Step Back" },
	{ "n", "<leader>dr", function() instance().dap.restart() end,           "Debug Restart" },

	-- REPL toggle
	-- { "n", "<leader>dr", req_dap.repl.toggle,  "Debug Toggle REPL" },

	-- DAP Widgets and UI (Sidebars)
	{ "n", "<space>?", function()
		instance().dapui.eval(nil, { enter = true })
	end, "Evaluate value under the cursor in floating window." },

	{ "n", "<leader>du", function()
		instance().dapui.toggle()
	end, "Toggle DAP UI" },
})

-- Rust specific
local function rust_mapping()
	local function with_args(cmd)
		return function()
			vim.ui.input({ prompt = "Args for executable: " }, function(args_for_executable)
				if type(args_for_executable) == "string" and string.len(args_for_executable) > 0 then
					-- vim.cmd("RustLsp debuggables " .. args_for_executable)
					vim.cmd(cmd .. " " .. args_for_executable)
				end
			end)
		end
	end

	keymaps.set_keys({
		{ "n", "<leader>dd", "<cmd>RustLsp debug<CR>",         "Debug RustLsp debuggable under cursor" },
		{ "n", "<leader>dD", with_args("RustLsp debug"),       "Debug RustLsp debuggable under cursor with arguments" },
		{ "n", "<leader>da", "<CMD>RustLsp debuggables<CR>",   "All RustLsp debuggables" },
		{ "n", "<leader>dA", with_args("RustLsp debuggables"), "All RustLsp debuggables with arguments" },
		{ "n", "<leader>ds", "<cmd>RustLsp! debuggables<CR>",  "Run same RustLsp debuggable as last time" },
	})
end

if vim.bo.filetype == "rust" then
	rust_mapping()
end

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.rs",
	callback = rust_mapping,
})
