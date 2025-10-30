---@diagnostic disable: missing-fields
--- @module "lazy"
--- @type LazyPluginSpec
return {
	"nvim-neotest/neotest",

	lazy = true,
	keys = "<space>d",
	cmd = { "GoTestDebug" },

	dependencies = {
		"antoinemadec/FixCursorHold.nvim",
		"leoluz/nvim-dap-go",
		"marilari88/neotest-vitest",
		"mfussenegger/nvim-dap",
		"nvim-lua/plenary.nvim",
		"nvim-neotest/neotest-go",
		"nvim-neotest/neotest-jest",
		"nvim-neotest/nvim-nio",
		"nvim-treesitter/nvim-treesitter",
		"rouge8/neotest-rust",
	},

	config = function()
		local neotest = require("neotest")

		neotest.setup({
			-- diagnostic complains about missing fields, but should be fine
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


		local keymaps = require("user.keymaps")

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

		require("user.keymaps").set_keys({
			{ "n", "]t", function() neotest.jump.next() end, "Go to next test (in buffer)" },
			{ "n", "[t", function() neotest.jump.prev() end, "Go to prev test (in buffer)" },
		})
	end,
}
