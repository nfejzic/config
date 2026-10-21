local M = {}

-- ==============================================================================
-- Rust pretty-printers
-- ==============================================================================

-- Without these, lldb shows Rust types as raw structs: a `String` appears as a
-- `Vec<u8>` of bytes and an enum as its discriminant plus a union. rustc ships
-- formatters in its sysroot (`lib/rustlib/etc/lldb_lookup.py`), and importing
-- the script registers all of them. This is the step codelldb used to do for
-- us.
--
-- rustaceanvim already adds this import to the sessions it starts (its
-- `load_rust_types` option), but neotest-rust doesn't, so we add it here for
-- every Rust session that doesn't set its own `initCommands`.
local rust_init_commands = nil

local function get_rust_init_commands()
	if rust_init_commands == nil then
		rust_init_commands = {}
		local result = vim.system({ "rustc", "--print", "sysroot" }, { text = true }):wait()
		if result.code == 0 then
			local script = vim.fs.joinpath(vim.trim(result.stdout), "lib", "rustlib", "etc", "lldb_lookup.py")
			if vim.uv.fs_stat(script) then
				rust_init_commands = { 'command script import "' .. script .. '"' }
			end
		end
	end
	return rust_init_commands
end

function M.setup(dap)
	-- ==========================================================================
	-- Adapter
	-- ==========================================================================

	-- C, C++ and Rust debugger: LLVM's lldb-dap (nvim/init.nix puts it on PATH).
	--
	-- The adapter is named `lldb` on purpose: rustaceanvim registers its own
	-- adapter under that name only if one doesn't already exist, so it picks
	-- this one up and every language goes through the same adapter.
	dap.adapters.lldb = {
		type = "executable",
		command = "lldb-dap",
		name = "lldb",
		-- nvim-dap runs this on every launch configuration before handing it
		-- to the adapter.
		enrich_config = function(config, on_config)
			config = vim.deepcopy(config)

			-- Run the program in lldb-dap's own process and send its output to
			-- the DAP console (the dap-ui "console" pane), instead of a Neovim
			-- terminal. rustaceanvim asks for `integratedTerminal`, but with
			-- Apple's lldb-dap the in-terminal launcher times out
			-- ("Timed out trying to get messages from the runInTerminal
			-- launcher") and the session never starts.
			--
			-- The trade-off is that the program has no stdin. That's fine for
			-- tests and most binaries.
			-- TODO: find out why runInTerminal times out and switch back, so
			-- that interactive programs can be debugged too.
			if config.request == "launch" then
				config.console = "internalConsole"
			end

			-- Add the Rust formatters (see above).
			--
			-- We can't tell for certain whether the target is a Rust binary, so
			-- we use the filetype of the buffer the session starts from. The
			-- formatters match every type (`-x ".*"`), so we don't want them in
			-- C/C++ sessions.
			if config.initCommands == nil and vim.bo.filetype == "rust" then
				config.initCommands = get_rust_init_commands()
			end

			on_config(config)
		end,
	}

	dap.configurations.cpp = {
		{
			name = "Launch",
			type = "lldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			args = {},
			runInTerminal = false,
			-- Let SIGWINCH through silently, so resizing the terminal doesn't
			-- pause the debuggee.
			postRunCommands = { "process handle -p true -s false -n false SIGWINCH" },
		},
		{
			name = "Attach to process",
			type = "lldb",
			request = "attach",
			pid = require("dap.utils").pick_process,
		},
	}

	-- Use for C;
	-- NOTE: Rust uses the same adapter, but rustaceanvim creates the launch
	-- configurations for it
	dap.configurations.c = dap.configurations.cpp
end

return M
