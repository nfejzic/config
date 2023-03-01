local wk = require("which-key")

wk.setup {
  disable = {
    filetypes = {
      "TelescopePrompt",
      "neo-tree",
      "NeoTree",
    },
    buftypes = {
      "nofile",
    }
  }
}

return wk
