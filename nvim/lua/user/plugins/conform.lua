--- @module "conform"
local conform = nil

local M = {}

--- @param tbl table the table we want to check, has `string` values
--- @param val string the value we're looking for
--- @return boolean `true` if table contains the value, otherwise `false`
local function table_contains_val(tbl, val)
	for _, v in ipairs(tbl) do
		if v == val then
			return true
		end
	end
	return false
end

--- @module "conform"

--- @param fmts table|string Single formatter, or list of formatters to filter out
--- @return table list of formatters that should be applied for the given buffer
local function filter_out_formatters(fmts, bufnr)
	local formatters = {}
	local buf_fmts = M.instance().list_formatters(bufnr)

	for _, fmt in ipairs(buf_fmts) do
		local should_insert = false
		---@diagnostic disable-next-line: undefined-field

		if type(fmts) == "string" then
			if fmt.name ~= fmts then
				should_insert = true
			end
		else
			if not table_contains_val(fmts, fmt.name) then
				---@diagnostic disable-next-line: undefined-field
				should_insert = true
			end
		end

		if should_insert then
			table.insert(formatters, fmt.name)
		end
	end

	return formatters
end

local function init(conf)
	conf.setup({
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black", stop_after_first = false },
			javascript = { "prettierd", stop_after_first = true },
			typescript = { "prettierd", stop_after_first = true },
			typescriptreact = { "prettierd", stop_after_first = true },
			tsx = { "prettierd", stop_after_first = true },
			vue = { "prettierd", stop_after_first = true },
			html = { "prettierd", stop_after_first = true },
			markdown = { "prettierd", stop_after_first = true },
			yaml = { "yamlfmt" },
			nix = { "nixfmt" },
			rust = {},
			c = {},
			go = { "gofumpt" },
			sql = { "postgresql_formatter", sql_formatter = "fallback", sqlfmt = "fallback", stop_after_first = true },
			fish = { "fish_indent" },
			sh = { "shfmt" },
			["*"] = { "injected" },
		},
		formatters = {
			fish_indent = {
				command = "fish_indent",
				args = { "-w", "$FILENAME" },
				stdin = false,
			},
			nixfmt = {
				command = "nixfmt",
				args = { "$FILENAME" },
				stdin = false,
			},
			postgresql_formatter = {
				command = "sql-formatter",
				args = { "-l", "postgresql" },
				stdin = true,
			},
		},
		format_on_save = function(bufnr)
			local buf_name = vim.api.nvim_buf_get_name(bufnr)

			local formatters = filter_out_formatters({ "injected" }, bufnr)

			local is_selfie = string.match(buf_name, "selfie")
			local is_beator = string.match(buf_name, "selfie")
			local is_monster = string.match(buf_name, "selfie")
			local is_nix_file = string.match(buf_name, ".nix")

			-- disable json formatting in idana projects
			local is_json = string.match(buf_name, ".*idana.*.json")

			local timeout_ms = 3000
			if is_nix_file then
				-- nix fmt takes a long time to format file, but it's ok...
				timeout_ms = 10000
			end

			if is_selfie or is_beator or is_monster or is_json then
				return { timeout_ms = timeout_ms, lsp_fallback = false, formatters = formatters, quiet = false }
			else
				return {
					-- These options will be passed to conform.format()
					timeout_ms = timeout_ms,
					lsp_fallback = true,
					formatters = formatters,
					quiet = false,
				}
			end
		end,
	})
end

function M.instance()
	if conform == nil then
		conform = require("conform")
		init(conform)
		vim.print("Conform is ready!")
	end

	return conform
end

local function format(args, injected)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end

	local filter_out = {}

	if not injected then
		filter_out = { "injected" }
	end

	local curr_buf = vim.api.nvim_get_current_buf()
	local formatters = filter_out_formatters(filter_out, curr_buf)

	M.instance().format({
		async = true,
		lsp_fallback = true,
		range = range,
		formatters = formatters,
	})
end

local function format_all(args)
	format(args, true)
end

local function format_no_injected(args)
	format(args, false)
end

-- this is eagerly evaluated, basically prepare some commands that load conform
vim.api.nvim_create_user_command("Format", format_no_injected, { range = true })
vim.api.nvim_create_user_command("FormatInjected", format_all, { range = true })

local fmt_grp = vim.api.nvim_create_augroup("nfejzic_fmt", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = fmt_grp,
	callback = function(_)
		if conform == nil then
			vim.cmd("Format")
			-- Format will load conform, and we can then disable this as conform handles it internally
			vim.api.nvim_clear_autocmds({
				group = fmt_grp,
			})
		end
	end
})

require("user.core.keymaps").set_keys({
	{ "n", "<leader>lf", "<cmd>Format<cr>",      "Format buffer" },
	{ "v", "<leader>lf", "<cmd>'<,'>Format<cr>", "Format buffer" },
})

return M
