-- LSP settings
local lspconfig = require 'lspconfig'
local nlspsettings = require 'nlspsettings'

require("mason").setup()

local mason_lsp = require("mason-lspconfig")
mason_lsp.setup()

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = 'rounded' }
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = 'rounded' }
)

vim.diagnostic.config({
    float = {
        -- focusable = false,
        -- style = 'minimal',
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    }
})

nlspsettings.setup({
    config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
    local_settings_dir = ".nlsp-settings",
    local_settings_root_markers = { '.git' },
    append_default_schemas = true,
    loader = 'json'
})

local lsp_formatting = function(bufnr)
    vim.lsp.buf.format(
        {
            filter = function(client) return client.name ~= "tsserver" or client.name ~= "jsonls" end,
            bufnr = bufnr,
        })
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- Add some commands and keybindings when server loads
local on_attach = function(client, bufnr)
    local wk = require("wk")
    local telescope_builtin = require('telescope.builtin')

    local show_diagnostics = function()
        telescope_builtin.diagnostics({ bufnr = 0 })
    end

    -- Diagnostic keymaps
    wk.register({
            ['<leader>'] = {
            l = {
                name = 'LSP',
                D = { vim.lsp.buf.declaration, "Go to Declaration" },
                e = { vim.diagnostic.open_float, 'Show diagnostics message' },
                h = { vim.lsp.buf.signature_help, 'Show signature help' },
                j = { vim.diagnostic.goto_next, "Go to next LSP diagnostics problem" },
                k = { vim.diagnostic.goto_prev, 'Go to previous LSP diagnostics problem' },
                n = { vim.lsp.buf.rename, "Refactor Rename" },
                p = { vim.lsp.buf.hover, "Show hover popup" },
                q = { vim.diagnostic.setloclist, "Populate loclist with diagnostics" },
                r = { telescope_builtin.lsp_references, "Go to References" },
                s = { telescope_builtin.lsp_document_symbols, "Search document symbols" },
                w = { telescope_builtin.lsp_workspace_symbols, "Search workspace symbols" },
                M = { telescope_builtin.diagnostics, "Show diagnostics messages in all buffers" },
                d = { telescope_builtin.lsp_definitions, 'Show definitions' },
                i = { telescope_builtin.lsp_implementations, 'Show implemnetations' },
                m = { show_diagnostics, 'Show diagnostics messages in current buffer' },
            },
            w = {
                name = "LSP Workspace",
                a = { vim.lsp.buf.add_workspace_folder, 'Add workspace folder' },
                r = { vim.lsp.buf.remove_workspace_folder, 'Remove workspace folder' },
                l = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, 'List workspace folders' },
            },
                ['.'] = { vim.lsp.buf.code_action, 'Show code actions' }
        },
        g = {
            -- alternative keymaps
            d = { telescope_builtin.lsp_definitions, 'Show definitions' },
            r = { telescope_builtin.lsp_references, "Go to References" },
            I = { telescope_builtin.lsp_implementations, 'Show implemnetations' },
            D = { vim.lsp.buf.declaration, "Go to Declaration" },
            t = { vim.lsp.buf.type_definition, "Go to Type Definition" },
            h = { vim.diagnostic.open_float, 'Show diagnostics message/help' },
            H = { '<cmd>TroubleToggle document_diagnostics<CR>', 'Show diagnostics messages in current buffer' },
        },
        K = { vim.lsp.buf.hover, "LSP Hover" },
            [']'] = { d = { vim.diagnostic.goto_next, "Go to next LSP diagnostics problem" } },
            ['['] = { d = { vim.diagnostic.goto_prev, 'Go to previous LSP diagnostics problem' } },
    })

    wk.register({
            ['<leader>'] = {
                ['.'] = { vim.lsp.buf.code_action, 'Show code actions' }
        }
    }, { mode = 'v' })

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                lsp_formatting(bufnr)
            end,
        })

        vim.api.nvim_buf_create_user_command(
            bufnr,
            'Format',
            function()
                lsp_formatting(bufnr)
            end,
            { nargs = 0 }
        )
    end
end

-- nvim-cmp supports additional completion capabilities
local globalCapabilities = vim.lsp.protocol.make_client_capabilities()
globalCapabilities = require('cmp_nvim_lsp').default_capabilities(globalCapabilities)
globalCapabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
    capabilities = globalCapabilities,
})

local opts = {
    on_attach = on_attach,
    capabilities = globalCapabilities
}

-- configure language servers
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
                capabilities = globalCapabilities,
                hover = {
                    links = {
                        enable = false
                    }
                }
            },
        }
    end,
        ["tsserver"] = function()
        lspconfig["tsserver"].setup {
            on_attach = function(client, bufnr)
                client.server_capabilities.document_formatting = false
                client.server_capabilities.document_range_formatting = false

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
                client.server_capabilities.document_formatting = false
                client.server_capabilities.document_range_formatting = false

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
        ["lua_ls"] = function()
        lspconfig.lua_ls.setup {
            on_attach = on_attach,
            capabilities = globalCapabilities,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim", "packer_plugins" }
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
                        templateInterpolationService = true,
                    },
                },
                format = {
                    enable = true,
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

-- prettier etc for vue, ts, js, html etc
local null_ls = require('null-ls');
null_ls.setup({
    sources = {
        null_ls.builtins.code_actions.eslint_d,
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.eslint_d,
    },
    on_attach = on_attach,
    capabilities = globalCapabilities,
})

-- use pretty gutter signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- indicate loading of LSP
require('fidget').setup()
