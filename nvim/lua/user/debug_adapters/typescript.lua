local M = {}

function M.setup(dap)
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
end

return M
