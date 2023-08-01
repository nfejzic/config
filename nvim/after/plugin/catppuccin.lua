local colors = require("catppuccin.palettes").get_palette("mocha")

require("catppuccin").setup({
  transparent_background = false,
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
    barbar = true,
    bufferline = true,
    cmp = true,
    dap = {
      enabled = true,
      enable_ui = true,
    },
    dashboard = true,
    gitsigns = true,
    indent_blankline = {
      enabled = true,
      colored_indent_levels = false,
    },
    markdown = true,
    native_lsp = {
      enabled = true,
    },
    neogit = true,
    notify = true,
    octo = true,
    symbols_outline = true,

    telekasten = true,
    telescope = true,
    treesitter = true,
    ts_rainbow = false,
    which_key = true,
  },
  custom_highlights = {
    -- TSNamespace = { style = {} },
    rustTSRefSpecifier = { fg = colors.sky, style = {} },
    NormalFloat = { fg = colors.text, bg = "none" },
  },
  -- make it very dark
  color_overrides = {
    -- mocha = {
    --   base = colors.crust,
    --   mantle = colors.base,
    --   crust = colors.mantle,
    --   surface0 = colors.base
    -- }
  }
})

vim.g.catppuccin_flavour = "mocha"
