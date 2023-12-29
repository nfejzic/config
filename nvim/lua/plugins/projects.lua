return {
	-- Projects
	{
		"ahmedkhalf/project.nvim",
		lazy = true,
		config = function()
			require("project_nvim").setup({
				manual_mode = true,
			})
		end,
	},
}
