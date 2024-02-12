if not require("mason-registry").is_installed("sql-formatter") then
	print("sql-formatter not installed. Will be install now using Mason")
	local pkg = require("mason-registry").get_package("sql-formatter")
	pkg:install()
end

local config_path = vim.fn.stdpath("config")
local f = assert(io.open(config_path .. "/after/queries/typescript/injections.scm", "r"))
local queries = f:read("*all")
f:close()

local embedded_sql = vim.treesitter.query.parse("typescript", queries)

local run_sql_formatter = function(input)
	local res

	local id = vim.fn.jobstart({ "sql-formatter" }, {
		stdout_buffered = true,
		on_stdout = function(_, output)
			res = output
		end,
	})

	vim.fn.chansend(id, input)
	vim.fn.chanclose(id, "stdin")
	vim.fn.jobwait({ id })

	return res
end

local get_root = function(bufnr)
	local parser = vim.treesitter.get_parser(bufnr, "typescript", {})
	local tree = parser:parse()[1]
	return tree:root()
end

local function formatSql(opts)
	local bufnr = vim.api.nvim_get_current_buf()
	local start_line = opts.line1 or 1
	local end_line = opts.line2 or -1

	if vim.bo[bufnr].filetype ~= "typescript" then
		vim.notify("can only be used in typescript")
		return
	end

	local root = get_root(bufnr)

	local changes = {}
	local indentation = ""
	for id, node in embedded_sql:iter_captures(root, bufnr, start_line, end_line) do
		local name = embedded_sql.captures[id]
		if name == "_key" or name == "mysql_fn" then
			local range = { node:range() }
			indentation = string.rep(" ", range[2])
		end

		if name == "sql" then
			-- { start_row, start_col, end_row, end_col }
			local range = { node:range() }
			-- local indentation = string.rep(" ", range[2])

			local text = vim.treesitter.get_node_text(node, bufnr)
			text = string.sub(text, 2, -2)

			local formatted = run_sql_formatter(text)

			local sql_indentation = indentation .. "  "
			for idx, line in ipairs(formatted) do
				if line ~= "" then
					formatted[idx] = sql_indentation .. line
				end
			end

			-- insert blank line, so that SQL starts in newline
			table.insert(formatted, 1, "")

			if formatted[#formatted] == "" then
				formatted[#formatted] = indentation
			end

			table.insert(changes, 1, {
				start_row = range[1],
				start_col = range[2] + 1,
				end_row = range[3],
				end_col = range[4] - 1,
				formatted = formatted,
			})
		end
	end

	for _, change in ipairs(changes) do
		vim.api.nvim_buf_set_text(
			bufnr,
			change.start_row,
			change.start_col,
			change.end_row,
			change.end_col,
			change.formatted
		)
	end
end

local augroup = vim.api.nvim_create_augroup("SqlFormatting", {})
vim.api.nvim_clear_autocmds({ group = augroup })
vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup,
	pattern = "*.ts",
	callback = function()
		vim.api.nvim_buf_create_user_command(0, "FormatSql", formatSql, { nargs = 0, range = true })
	end,
})
