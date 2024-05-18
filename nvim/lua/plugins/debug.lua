return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",

			{ "mxsdev/nvim-dap-vscode-js", lazy = false },
			{ "folke/which-key.nvim" },
			{
				"microsoft/vscode-js-debug",
				lazy = false,
				build = "npm ci --legacy-peer-deps && npm run compile",
				keys = function()
					return require("user.keymaps").dap_trigger_keys
				end,
			},
		},

		lazy = true,
		event = "UIEnter",

		keys = function()
			return require("user.keymaps").dap_trigger_keys
		end,

		config = function()
			local dap = require("dap")
			local ui = require("dapui")

			ui.setup()
			require("dap-go").setup()

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

			-- C, C++, Rust debugger
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					-- CHANGE THIS to your path!
					command = "codelldb",
					args = { "--port", "${port}" },

					-- On windows you may have to uncomment this:
					-- detached = false,
				},
			}

			dap.configurations.cpp = {
				{
					name = "Launch",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},

					runInTerminal = false,

					postRunCommands = { "process handle -p true -s false -n false SIGWINCH" },
				},
			}

			-- use this for rust and c:
			dap.configurations.c = dap.configurations.cpp
			-- let rustaceanvim setup rust!
			-- dap.configurations.rust = dap.configurations.cpp

			-- javascript / typescript setup
			require("dap-vscode-js").setup({
				node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
				debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
				debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
				adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
				log_file_path = "(stdpath cache)/dap_vscode_js.log", -- Path for file logging
				log_file_level = vim.log.levels.ERROR, -- Logging level for output to file. Set to false to disable file logging.
				log_console_level = vim.log.levels.ERROR, -- Logging level for output to console. Set to false to disable console output.
			})

			for _, language in ipairs({ "typescript", "javascript" }) do
				dap.configurations[language] = {
					{
						name = "Launch",
						type = "pwa-node",
						request = "launch",
						program = "${file}",
						rootPath = "${workspaceFolder}",
						cwd = "${workspaceFolder}",
						sourceMaps = true,
						skipFiles = { "<node_internals>/**" },
						protocol = "inspector",
						console = "integratedTerminal",
						resolveSourceMapLocations = {
							"${workspaceFolder}/**",
							"!**/node_modules/**",
						},
					},
					{
						name = "Attach to node process",
						type = "pwa-node",
						request = "attach",
						rootPath = "${workspaceFolder}",
						resolveSourceMapLocations = {
							"${workspaceFolder}/**",
							"!**/node_modules/**",
						},
						processId = require("dap.utils").pick_process,
					},
					{
						type = "pwa-node",
						request = "launch",
						name = "Jest debug current file",
						-- trace = true, -- include debugger info
						runtimeExecutable = "npx",
						runtimeArgs = {
							"jest",
							"--no-coverage",
							"${file}",
						},
						rootPath = "${workspaceFolder}",
						cwd = "${workspaceFolder}",
						console = "integratedTerminal",
						internalConsoleOptions = "neverOpen",
						resolveSourceMapLocations = {
							"${workspaceFolder}/**",
							"!**/node_modules/**",
						},
					},
				}
			end

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
		end,
	},
}
