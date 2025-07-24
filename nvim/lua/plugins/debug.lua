local trigger_keys = { "<leader>d" }

return {
	{
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
		event = "VeryLazy",

		keys = trigger_keys,

		config = function()
			require("user.debug")
		end,
	},
}
