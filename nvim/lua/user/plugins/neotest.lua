local gh = require("user.plugins.lib").github

vim.pack.add({
	gh "nvim-neotest/neotest",

	-- dependencies
	gh "nvim-neotest/neotest-go",
	gh "nvim-neotest/neotest-jest",
	gh "rouge8/neotest-rust",
	gh "leoluz/nvim-dap-go",
	gh "mfussenegger/nvim-dap",
	gh "nvim-neotest/nvim-nio",
	gh "marilari88/neotest-vitest",
})

local neotest = nil

local function instance()
	if neotest == nil then
		neotest = require("neotest")

		-- NOTE: diagnostic complains about missing fields, but should be fine
		---@diagnostic disable-next-line: missing-fields
		neotest.setup({
			adapters = {
				require("neotest-go")({
					experimental = {
						test_table = true,
					},
					args = { "-tags=unit,integration" },
				}),
				require("neotest-rust")({
					dap_adapter = "codelldb",
				}),
				-- require("neotest-vitest"),
			},
		})

		require("dap-go").setup({
			delve = {
				build_flags = "-tags=unit,integration",
			},
		})

		vim.notify("Loaded neotest")
	end

	return neotest
end

local keymaps = require("user.core.keymaps")

local function go_cmds()
	vim.api.nvim_create_user_command("GoTestDebug", function()
		require("dap-go").debug_test()
	end, {})

	keymaps.set_keys({
		{ "n", "<leader>dt", "GoTestDebug", "Debug test under cursor" }
	})
end

if vim.bo.filetype == "go" then
	vim.api.nvim_create_user_command("GoTestDebug", function()
		require("dap-go").debug_test()
	end, {})

	keymaps.set_keys({
		{ "n", "<leader>dt", "GoTestDebug", "Debug test under cursor" },
	})
end

vim.api.nvim_create_autocmd("BufRead", {
	pattern = "*.go",
	callback = go_cmds,
})

require("user.core.keymaps").set_keys({
	{ "n", "]t", function() instance().jump.next() end, "Go to next test (in buffer)" },
	{ "n", "[t", function() instance().jump.prev() end, "Go to prev test (in buffer)" },
})
