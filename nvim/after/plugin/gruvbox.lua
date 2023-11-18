-- setup must be called before loading the colorscheme
-- Default options:
local gruvbox = require("gruvbox")
local palette = gruvbox.palette

vim.o.background = "dark"
-- vim.o.background = "light"

local bg = vim.o.background

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
    Function = { fg = palette.blue, bg = "none" },
    Identifier = { fg = palette.fg2, bg = "none" },
    ["@field"] = { fg = palette.fg2, bg = "none" },

    ["@lsp.type.interface"] = { link = "@type.definition" },
    ["@lsp.type.enumMember"] = { fg = palette.orange },
    ["@lsp.type.lifetime"] = { link = "@storageclass.lifetime" },
    ["@storageclass.lifetime"] = { fg = palette.aqua },

    Comment = { fg = palette.orange },
    ["@comment"] = { link = "Comment" },
    ["@comment.documentation"] = { fg = palette.aqua },
    ["@punctuation.bracket"] = { fg = palette.fg1 },
    ["@label"] = { fg = palette.yellow },

    TreesitterContext = { bg = palette.bg1 },

    NormalFloat = { fg = palette.fg4, bg = palette.bg0 },
    SignColumn = { fg = palette.gray, bg = palette.bg1 },
    LineNr = { link = "SignColumn" },

    NeoTreeGitAdded = { fg = palette.green },
    NeoTreeGitDeleted = { fg = palette.red },
    NeoTreeGitModified = { fg = palette.aqua },
  },
  dim_inactive = false,
  transparent_mode = false,
})

-- vim.cmd("colo gruvbox")
