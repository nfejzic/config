local config = function()
	-- require("go").setup({
	-- 	auto_format = false, -- done by conform
	-- 	auto_lint = false,
	-- 	-- linters: revive, errcheck, staticcheck, golangci-lint
	-- 	linter = "golangci-lint",
	-- 	-- linter_flags: e.g., {revive = {'-config', '/path/to/config.yml'}}
	-- 	linter_flags = {},
	-- 	-- lint_prompt_style: qf (quickfix), vt (virtual text)
	-- 	lint_prompt_style = "qf",
	-- 	test_flags = { "-v", "-tags=unit,integration" },
	-- })

	-- NOTE(nfejzic): this is a different than what I used before.
	-- Previously I used the plugin that was installed with return statement below
	-- However, this is config for https://github.com/ray-x/go.nvim/
	require("go").setup(opts)
	local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = "*.go",
		callback = function()
			require("go.format").goimports()
		end,
		group = format_sync_grp,
	})
end

config()

-- return {
-- 	{
-- 		"crispgm/nvim-go",
-- lazy = true,
-- filetype = { "go", "gomod" },
-- config = config,
-- 	},
--
-- }
