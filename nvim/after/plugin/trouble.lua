local wk = require('which-key')
local trouble = require("trouble")

if packer_plugins["trouble"] then
  trouble.setup {}
  wk.register({
    t = {
      name = "Trouble",
      q = { '<cmd>TroubleToggle quickfix<CR>', 'Quickfix' },
      l = { '<cmd>TroubleToggle loclist<CR>', 'Loclist' },
      d = { '<cmd>TroubleToggle document_diagnostics<CR>', 'Document Diagnostics' },
      w = { '<cmd>TroubleToggle workspace_diagnostics<CR>', 'Workspace Diagnostics' },
      t = { '<cmd>TodoTrouble<CR>', 'TODO / FIXME etc.' },
    }
  })
end
