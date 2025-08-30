return {
	-- formatters and formatting
	{
		"stevearc/conform.nvim",
		lazy = true,
		event = { "BufWritePre" },
		cmd = { "Format", "FormatInjected" },
		config = function()
			local conform = require("conform")
			local utils = require("user.utils")

			conform.setup({
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

					local formatters = utils.filter_out_formatters(conform, { "injected" }, bufnr)

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

			require("user.keymaps").set_keys({
				{ "n", "<leader>lf", "<cmd>Format<cr>",      "Format buffer" },
				{ "v", "<leader>lf", "<cmd>'<,'>Format<cr>", "Format buffer" },
			})
		end,
	},
}
