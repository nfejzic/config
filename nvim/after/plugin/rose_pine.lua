require("rose-pine").setup({
  variant = "auto",
  disable_float_background = true,

  groups = {
    keywords = "rose",
  },

  -- Change specific vim highlight groups
  -- https://github.com/rose-pine/neovim/wiki/Recipes
  highlight_groups = {
    Comment = { fg = "subtle" },
    ["@comment.documentation"] = { fg = "iris" },
    -- ["@lsp.type.comment.rust"] = {},
    -- ["@mut_specifier"] = { fg = colors.yellow },
    -- ["@ref_specifier"] = { link = "@mut_specifier" },

    SignColumn = { fg = "text", bg = "surface" },
    LineNr = { link = "SignColumn" },

    GitSignsAdd = { bg = "surface" },
    GitSignsModified = { bg = "surface" },
    GitSignsChange = { bg = "surface" },
    GitSignsDelete = { bg = "surface" },

    -- NeoTreeGitAdded = { fg = colors.green },
    -- NeoTreeGitModified = { fg = colors.yellow },
    -- NeoTreeGitDeleted = { fg = colors.red },
    -- NeoTreeGitConflict = { fg = colors.peach, style = { "italic" } },
    -- NeoTreeGitUntracked = { link = "NeoTreeGitConflict" },

    DiagnosticSignInfo = { bg = "surface" },
    DiagnosticSignWarn = { bg = "surface" },
    DiagnosticSignError = { bg = "surface" },
    DiagnosticSignHint = { bg = "surface" },

    -- NormalFloat = {},

    -- LspInlayHint = { link = "Comment" },

    -- TreesitterContext = { link = "SignColumn" }
  },
})

-- vim.cmd("colo rose-pine")
