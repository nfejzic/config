-- Setup nvim-cmp.
local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

local merge = function(a, b)
  return vim.tbl_deep_extend("force", {}, a, b)
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  -- view = {
  --   entires = "native"
  -- },

  window = {
    documentation = cmp.config.window.bordered(),
    completion = merge(cmp.config.window.bordered(), {
      col_offset = -3,
      side_padding = 0,
    }),
    -- winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
  },

  formatting = {
    -- format = lspkind.cmp_format({ mode = 'symbol' })
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      local kind = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
      local strings = vim.split(kind.kind, "%s", { trimempty = true })
      kind.kind = " " .. (strings[1] or "") .. " "
      kind.menu = "    (" .. (strings[2] or "") .. ")"

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
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
      { "i", "c" }
    ),
    ["<M-j>"] = cmp.mapping(
      cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      }),
      { "i", "c" }
    ),
    ["<tab>"] = cmp.config.disable,
  },

  sources = {
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },
    { name = "copilot",                group_index = 2 },
    { name = "luasnip" },
    { name = "path" },
    { name = "buffer" },
    { name = "gh_issues" },
  },

  experimental = {
    ghost_text = { hl_group = "Comment" },
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
  luasnip.jump(1)
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-H>", function()
  luasnip.jump(-1)
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-E>", function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end, { silent = true })
