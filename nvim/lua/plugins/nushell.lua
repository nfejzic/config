return {
	-- nushell support
	{
		"LhKipp/nvim-nu",
		config = function()
			require("nu").setup()
		end,
	},
}
