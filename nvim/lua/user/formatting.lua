local conform = require("conform")
local utils = require("user.utils")

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		python = { "isort", "black", stop_after_first = false },
		-- Use a sub-list to run only the first available formatter
		javascript = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		vue = { "prettierd", "prettier", stop_after_first = true },
		html = { "prettierd", "prettier", stop_after_first = true },
		markdown = { "prettierd", "prettier", stop_after_first = true },
		rust = {},
		c = {},
		go = { "gofumpt" },
		sql = { "sql_formatter", "sqlfmt", stop_after_first = false },
		["*"] = { "injected" },
	},
	format_on_save = function(bufnr)
		local buf_name = vim.api.nvim_buf_get_name(bufnr)

		local formatters = utils.filter_out_formatters(conform, { "injected" }, bufnr)

		local is_selfie = string.match(buf_name, "selfie")
		local is_beator = string.match(buf_name, "selfie")
		local is_monster = string.match(buf_name, "selfie")

		-- disable json formatting in idana projects
		local is_json = string.match(buf_name, ".*idana.*.json")

		if is_selfie or is_beator or is_monster or is_json then
			return { timeout_ms = 500, lsp_fallback = false, formatters = formatters, quiet = true }
		else
			return {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_fallback = true,
				formatters = formatters,
				quiet = true,
			}
		end
	end,
})

vim.api.nvim_create_user_command("Format", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end

	local curr_buf = vim.api.nvim_get_current_buf()
	local formatters = utils.filter_out_formatters(conform, { "injected" }, curr_buf)

	require("conform").format({
		async = true,
		lsp_fallback = true,
		range = range,
		formatters = formatters,
	})
end, { range = true })

vim.api.nvim_create_user_command("FormatInjected", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end

	require("conform").format({
		async = true,
		lsp_fallback = true,
		range = range,
	})
end, { range = true })

require("user.keymaps").conform()
