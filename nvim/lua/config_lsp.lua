-- LSP settings
local lspconfig = require 'lspconfig'
local nlspsettings = require 'nlspsettings'

require("mason").setup()
local mason_lsp = require("mason-lspconfig")
mason_lsp.setup()

nlspsettings.setup({
  config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
  local_settings_dir = ".nlsp-settings",
  local_settings_root_markers = { '.git' },
  append_default_schemas = true,
  loader = 'json'
})

-- Add some commands and keybindings when server loads
local on_attach = function(client, bufnr)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting_sync()' ]]

  local wk = require('which-key')

  wk.register({
    ['<leader>'] = {
      l = {
        name = 'LSP',
        p = { '<cmd>lua vim.lsp.buf.hover()<CR>', 'Show hover popup' },
        h = { '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Show signature help' },
        n = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'Refactor Rename' },
        j = { 'Go to next LSP diagnostics problem' },
        k = { 'Go to previous LSP diagnostics problem' },
        i = { "<cmd>lua require('telescope.builtin').lsp_implementations()<CR>", 'Show implemnetations' },
        m = { "<cmd>lua require('telescope.builtin').diagnostics({ bufnr=0 })<CR>",
          'Show diagnostics messages in current buffer' },
        M = { "<cmd>lua require('telescope.builtin').diagnostics()<CR>", 'Show diagnostics messages in all buffers' },
        s = { "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>", 'Search document symbols' },
        w = { "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>", 'Search workspace symbols' },
        D = { '<cmd>lua vim.lsp.buf.declaration()<CR>', 'Go to Declaration' },
        d = { "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>", 'Show definitions' },
        r = { '<cmd>lua require("telescope.builtin").lsp_references()<CR>', 'Go to References' },
      },
      w = {
        name = "LSP Workspace",
        a = { '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', 'Add workspace folder' },
        r = { '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', 'Remove workspace folder' },
        l = { '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', 'List workspace folders' },
      },
      ['.'] = { '<cmd>lua vim.lsp.buf.code_action()<CR>', 'Show code actions' }
    }
  })

  wk.register({
    ['<leader>'] = {
      ['.'] = { '<cmd>lua vim.lsp.buf.range_code_action()<CR>', 'Show code actions' }
    },
  },
    {
      mode = "v"
    })


  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
end

-- nvim-cmp supports additional completion capabilities
local globalCapabilities = vim.lsp.protocol.make_client_capabilities()
globalCapabilities = require('cmp_nvim_lsp').update_capabilities(globalCapabilities)
globalCapabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
  capabilities = globalCapabilities,
})

lspconfig.emmet_ls.setup { capabilities = globalCapabilities }

local opts = {
  on_attach = on_attach,
  capabilities = globalCapabilities
}

mason_lsp.setup_handlers {
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name) -- default handler (optional)
    lspconfig[server_name].setup(opts)
  end,
  -- Next, targeted overrides for specific servers.
  ["rust_analyzer"] = function()
    -- Initialize the LSP via rust-tools instead
    require("rust-tools").setup {
      -- The "server" property provided in rust-tools setup function are the
      -- settings rust-tools will provide to lspconfig during init.            --
      -- We merge the necessary settings from nvim-lsp-installer (server:get_default_options())
      -- with the user's own settings (opts).
      -- capabilities = globalCapabilities,
      tools = {
        inlay_hints = {
          highlight = "InlayHint",
        }
      },
      server = {
        on_attach = on_attach,
        capabilities = globalCapabilities
      },
    }
  end,
  ["tsserver"] = function()
    lspconfig["tsserver"].setup {
      on_attach = function(client, bufnr)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false

        local ts_utils = require("nvim-lsp-ts-utils")
        ts_utils.setup({})
        ts_utils.setup_client(client)

        on_attach(client, bufnr)
      end
    }
  end,
  ["jsonls"] = function()
    lspconfig["jsonls"].setup({
      on_attach = function(client, bufnr)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false

        on_attach(client, bufnr)
      end
    })
  end,
  ["emmet_ls"] = function()
    lspconfig["emmet_ls"].setup { capabilities = globalCapabilities }
  end,
  ["eslint"] = function()
    lspconfig["eslint"].setup {
      on_attach = on_attach,
      capabilities = globalCapabilities,
      settings = {
        codeAction = {
          disableRuleComment = {
            enable = true,
            location = "separateLine"
          },
          showDocumentation = {
            enable = true
          }
        },
        codeActionsOnSave = {
          mode = "all"
        },
        format = true,
        run = "onType",
      }
    }
  end,
  ["sumneko_lua"] = function()
    lspconfig.sumneko_lua.setup {
      on_attach = on_attach,
      capabilities = globalCapabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" }
          }
        }
      }
    }
  end,
  ["vuels"] = function()
    lspconfig["vuels"].setup {
      on_attach = on_attach,
      capabilities = globalCapabilities,
      settings = {
        vetur = {
          completion = {
            autoImport = true,
            tagCasing = "kebab",
            useScaffoldSnippets = true,
          },
          useWorkspaceDependencies = true,
          experimental = {
            templateInterpolationService = false,
          },
        },
        format = {
          enable = false,
          options = {
            useTabs = false,
            tabSize = 2,
          },
          scriptInitialIndent = false,
          styleInitialIndent = false,
          defaultFormatter = {
            ts = "prettier",
            js = "prettier",
            html = "prettier",
            scss = "prettier",
          },
        },
        validation = {
          template = false,
          script = false,
          style = false,
          templateProps = false,
          interpolation = false,
        },
      }
    }
  end
}

local null_ls = require('null-ls');
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.stylelint,
    null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.eslint_d,
  },
  on_attach = on_attach,
  capabilities = globalCapabilities,
})

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
local lspkind = require 'lspkind'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  formatting = {
    format = lspkind.cmp_format({})
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'buffer' }
  },
}

-- use pretty gutter signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

require('fidget').setup()
