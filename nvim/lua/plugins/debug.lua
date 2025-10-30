local trigger_keys = { "<leader>d" }

return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"leoluz/nvim-dap-go",
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-neotest/nvim-nio",
		{ "williamboman/mason.nvim",   version = "1.*" },

		{ "mxsdev/nvim-dap-vscode-js", lazy = false },
		{
			"microsoft/vscode-js-debug",
			lazy = false,
			enabled = false,
			build = "npm ci --legacy-peer-deps && npm run compile",
			keys = trigger_keys,
		},
	},

	lazy = true,
	-- event = "VeryLazy",

	keys = trigger_keys,

	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local keymaps = require("user.keymaps")

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

		-- setup keymaps
		keymaps.set_keys({
			{ "n", "<leader>dp", dap.toggle_breakpoint, "Toggle breakpoint" },

			-- Stepping
			{ "n", "<leader>dc", dap.continue,          "Debug Continue" },
			{ "n", "<leader>di", dap.step_into,         "Debug Step Into" },
			{ "n", "<leader>do", dap.step_out,          "Debug Step Out" },
			{ "n", "<leader>dj", dap.step_over,         "Debug Step Over" },
			{ "n", "<leader>dk", dap.step_back,         "Debug Step Back" },
			{ "n", "<leader>dr", dap.restart,           "Debug Restart" },
			{ "n", "<leader>ds", dap.stop,              "Debug Stop" },

			-- REPL toggle
			-- { "n", "<leader>dr", req_dap.repl.toggle,  "Debug Toggle REPL" },

			-- DAP Widgets and UI (Sidebars)
			{ "n", "<space>?", function()
				dapui.eval(nil, { enter = true })
			end, "Evaluate value under the cursor in floating window." },

			{ "n", "<leader>du", function()
				dapui.toggle()
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
				{ "n", "<leader>dS", "<cmd>RustLsp! debuggables<CR>",  "Run same RustLsp debuggable as last time" },
			})
		end

		if vim.bo.filetype == "rust" then
			rust_mapping()
		end

		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "*.rs",
			callback = rust_mapping,
		})

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end
	end,
}
