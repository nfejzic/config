local colors = require("catppuccin.palettes").get_palette "mocha"
require("catppuccin").setup({
  styles = {
    comments = { "italic" },
    conditionals = {},
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  integrations = {
    treesitter = true,
    native_lsp = {
      enabled = true,
    },
    lsp_trouble = true,
    cmp = true,
    gitsigns = true,
    telescope = true,
    dap = {
      enabled = true,
      enable_ui = true,
    },
    which_key = true,
    indent_blankline = {
      enabled = true,
      colored_indent_levels = false,
    },
    dashboard = true,
    neogit = true,
    barbar = true,
    bufferline = true,
    markdown = true,
    ts_rainbow = false,
    notify = true,
    telekasten = true,
    symbols_outline = true,
    octo = true
  },
  custom_highlights = {
    TSNamespace = { style = {} },
    rustTSRefSpecifier = { fg = colors.sky, style = {} },
  },
  -- make it very dark
  color_overrides = {
    mocha = {
      base = colors.crust,
      mantle = colors.base,
      crust = colors.mantle,
      surface0 = colors.base
    }
  }
})

vim.g.catppuccin_flavour = "mocha"
