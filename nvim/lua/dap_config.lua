local wk = require('which-key')

function toggle_dap_sidebar(opt)
  opt = opt or 'scopes'

  local widgets = require('dap.ui.widgets')
  local sidebar

  if opt == "frames" then
    sidebar = widgets.sidebar(widgets.frames)
  else
    sidebar = widgets.sidebar(widgets.scopes)
  end

  sidebar.toggle()
end

-- Prepare keybindings
wk.register({
  ['<leader>'] = {
    -- Debug: 
    d = {
      name = 'Debug / DAP',

      -- Breakpoints
      a = { "<cmd>lua require'dap'.clear_breakpoints()<CR>", "Remove all breakpoints" },
      p = { "<cmd>lua require'dap'.toggle_breakpoint()<CR>", "Toggle breakpoint" },

      -- Stepping through debug
      c = { "<cmd>lua require'dap'.continue()<CR>", "Debug Continue" },
      i = { "<cmd>lua require'dap'.step_into()<CR>", "Debug Step Into" },
      o = { "<cmd>lua require'dap'.step_out()<CR>", "Debug Step Out" },
      j = { "<cmd>lua require'dap'.step_over()<CR>", "Debug Step Over" },
      k = { "<cmd>lua require'dap'.step_back()<CR>", "Debug Step Back" },

      -- REPL toggle
      r = { "<cmd>lua require'dap'.repl.toggle()<CR>", "Debug Toggle REPL" },

      -- DAP Widgets (Sidebars)
      h = { "<cmd>lua require('dap.ui.widgets').hover()<CR>", "Value under cursor in floating window" },
      s = { "<cmd>lua toggle_dap_sidebar('scopes')<CR>", "Scopes" },
      f = { "<cmd>lua toggle_dap_sidebar('frames')<CR>", "Scopes" },
      u = { "<cmd>lua require('dapui').toggle()<CR>", "Toggle DAP UI" },
    }
  }
})

local dap = require('dap')
require("dapui").setup()

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    -- 💀
    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html

    runInTerminal = false,

    -- 💀
    -- If you use `runInTerminal = true` and resize the terminal window,
    -- lldb-vscode will receive a `SIGWINCH` signal which can cause problems
    -- To avoid that uncomment the following option
    -- See https://github.com/mfussenegger/nvim-dap/issues/236#issuecomment-1066306073
    postRunCommands = {'process handle -p true -s false -n false SIGWINCH'}
  },
}


-- use this for rust and c:
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
