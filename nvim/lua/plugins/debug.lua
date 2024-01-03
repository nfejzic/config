return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{ "mxsdev/nvim-dap-vscode-js", lazy = true },
			{ "folke/which-key.nvim" },
			{
				"microsoft/vscode-js-debug",
				lazy = true,
				build = "npm ci --legacy-peer-deps && npm run compile",
			},
		},
		lazy = true,
		keys = function()
			return require("user.keymaps").dap_trigger_keys
		end,
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			local widgets = require("dap.ui.widgets")

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
			require("user.keymaps").dap(dap, dapui, widgets)
		end,
	},

	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap" },
		lazy = true,
		keys = function()
			return require("user.keymaps").dap_trigger_keys
		end,
		config = function()
			require("dapui").setup()
		end,
	},

	-- for javascript / typescript debugging
	{
		"microsoft/vscode-js-debug",
		lazy = true,
		keys = function()
			return require("user.keymaps").dap_trigger_keys
		end,
		build = "npm ci --legacy-peer-deps && npm run compile",
	},
}
