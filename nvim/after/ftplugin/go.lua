vim.pack.add({
	require("user.plugins.lib").github "crispgm/nvim-go",
})

require("go").setup({
	auto_format = false, -- done by conform
	auto_lint = false,
	-- linters: revive, errcheck, staticcheck, golangci-lint
	linter = "golangci-lint",
	-- linter_flags: e.g., {revive = {'-config', '/path/to/config.yml'}}
	linter_flags = {},
	-- lint_prompt_style: qf (quickfix), vt (virtual text)
	lint_prompt_style = "qf",
	test_flags = { "-v", "-tags=unit,integration" },
})

vim.o.textwidth = 100
-- vim.o.colorcolumn = "100"
