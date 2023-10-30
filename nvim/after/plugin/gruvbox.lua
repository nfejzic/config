-- setup must be called before loading the colorscheme
-- Default options:
local gruvbox = require("gruvbox")
local palette = require("gruvbox.palette")

vim.o.background = "dark"
-- vim.o.background = "light"

local bg = vim.o.background
local colors = palette.get_base_colors(bg, "hard")

local x = {
  a = true
}

print(x.a)

gruvbox.setup({
  undercurl = true,
  underline = true,
  bold = true,
  -- italic = false,
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_indent_guides = false,
  inverse = true,    -- invert background for search, diffs, statuslines and errors
  contrast = "hard", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {
    Function = { fg = colors.blue, bg = "none" },
    Identifier = { fg = colors.fg2, bg = "none" },
    ["@field"] = { fg = colors.fg2, bg = "none" },

    ["@lsp.type.interface"] = { link = "@type.definition" },
    ["@lsp.type.enumMember"] = { link = "GruvboxOrange" },
    ["@lsp.type.lifetime"] = { link = "@storageclass.lifetime" },
    ["@storageclass.lifetime"] = { link = "GruvboxAqua" },

    Comment = { link = "GruvboxOrange" },
    ["@comment"] = { link = "GruvboxOrange" },
    ["@comment.documentation"] = { link = "GruvboxAqua" },
    ["@punctuation.bracket"] = { link = "GruvboxFg1" },
    ["@label"] = { link = "GruvboxYellow" },

    TreesitterContext = { bg = colors.bg1 },

    NormalFloat = { fg = colors.fg4, bg = colors.bg0 },
    SignColumn = { fg = colors.gray, bg = colors.bg1 },
    LineNr = { link = "SignColumn" },

    NeoTreeGitAdded = { link = "GruvboxGreen" },
    NeoTreeGitDeleted = { link = "GruvboxRed" },
    NeoTreeGitModified = { link = "GruvboxAqua" },
  },
  dim_inactive = false,
  transparent_mode = false,
})

vim.cmd("colo gruvbox")
