local cmp = require("cmp")
local lspkind = require("lspkind")

local merge = function(a, b)
	return vim.tbl_deep_extend("force", {}, a, b)
end

local cmp_fmt = lspkind.cmp_format({
	mode = "symbol_text",
	symbol_map = { Codeium = "" },
})

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},

	window = {
		documentation = cmp.config.window.bordered(),
		completion = merge(cmp.config.window.bordered(), {
			col_offset = -3,
			side_padding = 0,
		}),
	},
	formatting = {
		-- format = lspkind.cmp_format({ mode = 'symbol' })
		fields = { "kind", "abbr", "menu" },
		expandable_indicator = true,
		format = function(entry, vim_item)
			local kind = cmp_fmt(entry, vim_item)
			local strings = vim.split(kind.kind, "%s", { trimempty = true })
			kind.kind = " " .. (strings[1] or "") .. " "
			kind.menu = " (" .. (strings[2] or "") .. ")"

			return kind
		end,
	},

	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-e>"] = cmp.mapping.abort(),
		["<C-k>"] = cmp.mapping.complete(),
		["<C-j>"] = cmp.mapping(
			cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Insert,
				select = true,
			}),
			{ "i", "c" }
		),
		["<M-j>"] = cmp.mapping(
			cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Insert,
				select = false,
			}),
			{ "i", "c" }
		),
		---@diagnostic disable-next-line: assign-type-mismatch
		["<tab>"] = cmp.config.disable,
	},

	sources = {
		{ name = "nvim_lsp" },
		{ name = "nvim_lsp_signature_help" },
		{ name = "luasnip" },
		{ name = "path" },
		{ name = "buffer" },
		{ name = "codeium", group_index = 2 },
		{ name = "gh_issues" },
	},

	experimental = {
		ghost_text = { hl_group = "LspInlayHint" },
		native_menu = false,
	},
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (does not work if `native_menu` is set to true).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{
			name = "cmdline",
			option = {
				ignore_cmds = { "Man", "!" },
			},
		},
	}),
})

vim.keymap.set({ "i", "s" }, "<C-L>", function()
	require("luasnip").jump(1)
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-H>", function()
	require("luasnip").jump(-1)
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-E>", function()
	if require("luasnip").choice_active() then
		require("luasnip").change_choice(1)
	end
end, { silent = true })

-- setup Github PRs and Issues completion completions
local plenary_job = require("plenary.job")
require("user.github_completion").setup_github_cmp(cmp, plenary_job)
