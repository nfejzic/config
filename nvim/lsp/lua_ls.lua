local function lazydev()
	local lz = require("lazydev")
	lz.setup({
		integrations = {
			lspconfig = false,
			blink = false,
		},
		library = {
			-- Needs `justinsgithub/wezterm-types` to be installed
			{ path = "wezterm-types",      mods = { "wezterm" } },
			-- Load luvit types when the `vim.uv` word is found
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		}
	})

	return lz
end

return {
	root_dir = function(bufnr, on_dir) on_dir(lazydev().find_workspace(bufnr)) end,
}
