local wk = require('which-key')

local function toggle_dap_sidebar(opt)
  opt = opt or 'scopes'

  local widgets = require('dap.ui.widgets')
  local sidebar

  if opt == "frames" then
    sidebar = widgets.sidebar(widgets.frames)
  else
    sidebar = widgets.sidebar(widgets.scopes)
  end

  return sidebar.toggle
end

-- Prepare keybindings
wk.register({
  ['<leader>'] = {
    -- Debug:
    d = {
      name = 'Debug / DAP',

      -- Breakpoints
      a = { require 'dap'.clear_breakpoints, "Remove all breakpoints" },
      p = { require 'dap'.toggle_breakpoint, "Toggle breakpoint" },

      -- Stepping through debug
      c = { require 'dap'.continue, "Debug Continue" },
      i = { require 'dap'.step_into, "Debug Step Into" },
      o = { require 'dap'.step_out, "Debug Step Out" },
      j = { require 'dap'.step_over, "Debug Step Over" },
      k = { require 'dap'.step_back, "Debug Step Back" },

      -- REPL toggle
      r = { require 'dap'.repl.toggle, "Debug Toggle REPL" },

      -- DAP Widgets (Sidebars)
      h = { require('dap.ui.widgets').hover, "Value under cursor in floating window" },
      s = { toggle_dap_sidebar('scopes'), "Scopes" },
      f = { toggle_dap_sidebar('frames'), "Frames" },
      u = { require('dapui').toggle, "Toggle DAP UI" },
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
    postRunCommands = { 'process handle -p true -s false -n false SIGWINCH' }
  },
}

-- use this for rust and c:
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

-- javascript / typescript setup
require("dap-vscode-js").setup({
  -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
  debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
  -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
  adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
  -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
  -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
  -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
})

for _, language in ipairs({ 'typescript', 'javascript' }) do
  dap.configurations[language] = {
    {
      name = 'Launch',
      type = 'pwa-node',
      request = 'launch',
      program = '${file}',
      rootPath = '${workspaceFolder}',
      cwd = '${workspaceFolder}',
      sourceMaps = true,
      skipFiles = { '<node_internals>/**' },
      protocol = 'inspector',
      console = 'integratedTerminal',
      resolveSourceMapLocations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**"
      },
    },
    {
      name = 'Attach to node process',
      type = 'pwa-node',
      request = 'attach',
      rootPath = '${workspaceFolder}',
      resolveSourceMapLocations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**"
      },
      processId = require('dap.utils').pick_process,
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Jest debug current file",
      -- trace = true, -- include debugger info
      runtimeExecutable = "npx",
      runtimeArgs = {
        "jest",
        "--no-coverage",
        "${file}"
      },
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
      resolveSourceMapLocations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**"
      },
    }
  }
end
