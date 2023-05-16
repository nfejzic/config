-- setup must be called before loading the colorscheme
-- Default options:
local gruvbox = require("gruvbox")
local palette = require("gruvbox.palette")

gruvbox.setup({
  undercurl = true,
  underline = true,
  bold = true,
  -- italic = true,
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true,    -- invert background for search, diffs, statuslines and errors
  contrast = "hard", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {
    SignColumn = { fg = palette.colors.light0_hard, bg = palette.colors.dark0_hard },
    GitSignsAdd = { fg = palette.colors.bright_green, bg = palette.colors.dark0_hard },
    GitSignsAddNr = { fg = palette.colors.bright_green, bg = palette.colors.dark0_hard },
    GitSignsChange = { fg = palette.colors.bright_blue, bg = palette.colors.dark0_hard },
    GitSignsChangeNr = { fg = palette.colors.bright_blue, bg = palette.colors.dark0_hard },
    GitSignsDelete = { fg = palette.colors.bright_red, bg = palette.colors.dark0_hard },
    GitSignsDeleteNr = { fg = palette.colors.bright_red, bg = palette.colors.dark0_hard },
  },
  dim_inactive = false,
  transparent_mode = false,
})

-- vim.cmd("colorscheme gruvbox")
