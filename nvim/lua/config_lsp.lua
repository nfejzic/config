-- LSP settings
local lspconfig = require 'lspconfig'
local configs = require'lspconfig/configs'
local nlspsettings = require 'nlspsettings'

nlspsettings.setup({
  config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
  local_settings_dir = ".nlsp-settings",
  local_settings_root_markers = { '.git' },
  append_default_schemas = true,
  loader = 'json'
})

local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = false }
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]

  local wk = require('which-key')

  wk.register({
    ['<leader>'] = {
      l = {
        name = 'LSP',
        p = { '<cmd>lua vim.lsp.buf.hover()<CR>', 'Show hover popup' },
        h = { '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Show signature help' },
        r = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'Refactor Rename' },
        j = { 'Go to next LSP diagnostics problem' },
        k = { 'Go to next LSP diagnostics problem' },
        D = { '<cmd>lua require("telescope.builtin").lsp_type_definition()<CR>', 'Go to next LSP diagnostics problem' },
        d = { "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>", 'Show definitions' },
        i = { "<cmd>lua require('telescope.builtin').lsp_implementations()<CR>", 'Show implemnetations' },
        m = { "<cmd>lua require('telescope.builtin').diagnostics({ bufnr=0 })<CR>", 'Show diagnostics messages in current buffer' },
        M = { "<cmd>lua require('telescope.builtin').diagnostics()<CR>", 'Show diagnostics messages in all buffers' },
        s = { "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>", 'Search document symbols' },
        w = { "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>", 'Search workspace symbols' },
      },
      g = {
        name = "GoTo",
        D = { '<cmd>lua vim.lsp.buf.declaration()<CR>', 'Declaration' },
        d = { '<cmd>lua vim.lsp.buf.definition()<CR>', 'Definition' },
        i = { '<cmd>lua vim.lsp.buf.implementation()<CR>', 'Implementation' },
        r = { '<cmd>lua require("telescope.builtin").lsp_references()<CR>', 'References' },
      },
      w = {
        name = "LSP Workspace",
        a = { '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', 'Add workspace folder' },
        r = { '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', 'Remove workspace folder' },
        l = { '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', 'List workspace folders' },
      },
      ['.'] = { '<cmd>lua require("telescope.builtin").lsp_code_actions(require("telescope.themes").get_cursor())<CR>', 'Show code actions' }
    }
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

local lsp_installer = require("nvim-lsp-installer")

if not lspconfig.emmet_ls then
  configs.emmet_ls = {
    default_config = {
      filetypes = {'php', 'html', 'html5', 'scss', 'css', 'blade'};
    };
  }
end

lspconfig.emmet_ls.setup{capabilities = globalCapabilities}

lsp_installer.on_server_ready(function(server)
    local opts = {
      on_attach = on_attach,
      capabilities = globalCapabilities
    }

    if server.name == "rust_analyzer" then
        -- Initialize the LSP via rust-tools instead
        require("rust-tools").setup {
            -- The "server" property provided in rust-tools setup function are the
            -- settings rust-tools will provide to lspconfig during init.            --
            -- We merge the necessary settings from nvim-lsp-installer (server:get_default_options())
            -- with the user's own settings (opts).
            server = vim.tbl_deep_extend("force", server:get_default_options(), opts),
        }
        server:attach_buffers()
--    elseif server.name == "jsonls" then 
--        server:setup {
--            on_attach = on_attach,
--            client.resolved_capabilities.document_formatting = false
--            client.resolved_capabilities.document_range_formatting = false
--        }
    elseif server.name == "tsserver" then
      server:setup {
        on_attach = function(client, bufnr)
          client.resolved_capabilities.document_formatting = false
          client.resolved_capabilities.document_range_formatting = false

          local ts_utils = require("nvim-lsp-ts-utils")
          ts_utils.setup({})
          ts_utils.setup_client(client)
          -- buf_map(bufnr, "n", "gs", ":TSLspOrganize<CR>")

          on_attach(client, bufnr)
        end
      }
    else
      server:setup(opts)
    end
end)

-- local prettier = require('prettier')
--
-- prettier.setup({
--   bin = 'prettierd',
--   filetypes = {
--     "css",
--     "graphql",
--     "html",
--     "html5",
--     "less",
--     "markdown",
--     "scss",
--     "yaml",
--     "json",
--     "vue",
--   }
-- })

local null_ls = require('null-ls');
null_ls.setup({
  sources = {
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.code_actions.eslint,
        null_ls.builtins.formatting.prettier.with({
            disabled_filetypes = { "json", "vue" },
        }),
    },
    on_attach = on_attach,
    disabled_filetypes = { "json", "vue" }
})

-- Example custom server
-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

-- luasnip setup
local luasnip = require 'luasnip'
-- require('luasnip.loaders.from_vscode').load()

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
    format = lspkind.cmp_format({
      -- with_text = false, -- do not show text alongside icons
      -- maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      -- before = function (entry, vim_item)
      --   ...
      --   return vim_item
      -- end
    })
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

-- use prettier gutter signs

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
--
-- vim.diagnostic.config({
--   virtual_text = true,
--   signs = true,
--   underline = true,
--   update_in_insert = false,
--   severity_sort = false,
-- })

require('fidget').setup()

