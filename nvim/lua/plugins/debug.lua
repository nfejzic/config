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
			{ "folke/which-key.nvim" },
			{
				"microsoft/vscode-js-debug",
				lazy = false,
				enabled = false,
				build = "npm ci --legacy-peer-deps && npm run compile",
				keys = function()
					return require("user.keymaps").dap_trigger_keys
				end,
			},
		},

		lazy = true,
		event = "VeryLazy",

		keys = function()
			return require("user.keymaps").dap_trigger_keys
		end,

		config = function()
			require("user.debug")
		end,
	},
}
