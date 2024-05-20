---@diagnostic disable: missing-fields
return {
	{
		"nvim-neotest/neotest",

		lazy = true,
		event = "VeryLazy",

		dependencies = {
			{ "nvim-neotest/neotest-go" },
			{ "nvim-neotest/neotest-jest" },
			{ "rouge8/neotest-rust" },
			{ "leoluz/nvim-dap-go" },
			{ "mfussenegger/nvim-dap" },
			{ "nvim-neotest/nvim-nio" },
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
				},
			})

			require("dap-go").setup({
				delve = {
					build_flags = "-tags=unit,integration",
				},
			})
			require("user.keymaps").neotest(neotest)
		end,
	},
}
