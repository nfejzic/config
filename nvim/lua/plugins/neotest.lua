return {
	{
		"nvim-neotest/neotest",

		lazy = false,

		dependencies = {
			{ "nvim-neotest/neotest-go" },
			{ "nvim-neotest/neotest-jest" },
			{ "rouge8/neotest-rust" },
			{ "leoluz/nvim-dap-go" },
			{ "mfussenegger/nvim-dap" },
		},

		config = function()
			local neotest = require("neotest")

			neotest.setup({
				-- ...,
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

			vim.api.nvim_create_user_command("GoTestDebug", function()
				require("dap-go").debug_test()
			end, {})

			require("user.keymaps").neotest(neotest)
		end,
	},
}
