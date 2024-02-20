return {
	-- Projects
	{
		"ahmedkhalf/project.nvim",
		lazy = false,
		config = function()
			require("project_nvim").setup({
				manual_mode = true,
			})
		end,
	},
}
