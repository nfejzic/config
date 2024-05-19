local M = {}

function M.setup(dap)
	-- C, C++, Rust debugger
	dap.adapters.codelldb = {
		type = "server",
		port = "${port}",
		executable = {
			command = "codelldb",
			args = { "--port", "${port}" },
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

	-- Use for C;
	-- NOTE: Rust is debugged by same debugger, but the rustaceanvim plugin handles
	-- that
	dap.configurations.c = dap.configurations.cpp
end

return M
