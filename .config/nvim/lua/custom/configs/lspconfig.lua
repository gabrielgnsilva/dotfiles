local opts = {}
local lspconfig = require('lspconfig')
local lspconfig_util = require('lspconfig.util')
local lspconfig_configs = require('lspconfig.configs')
local mason_lspconfig = require('mason-lspconfig')

local on_attach = require('core.utils').lsp.on_attach
local capabilities = require('core.utils').lsp.capabilities

opts.ensure_installed = {
    'angularls',
    'bashls',
    'clangd',
    'cssls',
    'emmet_ls',
    -- 'eslint',
    'gopls',
    'graphql',
    'html',
    'jsonls',
    'lemminx',
    'lua_ls',
    'pyright',
    'ruff',
    'rust_analyzer',
    'sqls',
    'tailwindcss',
    'ts_ls',
    'yamlls',
}

local signs = {
    Error = '󰅙',
    Info = '󰋼',
    Hint = '󰌵',
    Warn = '',
}

for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
    virtual_text = { prefix = '', source = 'if_many' },
    signs = true,
    underline = true,
    float = { border = 'rounded', source = 'if_many' },
    update_in_insert = true,
})

opts.handlers = {
    function(server_name)
        lspconfig[server_name].setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })
    end,

    ['lua_ls'] = function()
        lspconfig.lua_ls.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                Lua = {
                    completion = { callSnippet = 'Replace' },
                    diagnostics = { globals = { 'vim' } },
                    workspace = {
                        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                        [vim.fn.stdpath('data') .. '/lazy/lazy.nvim/lua/lazy'] = true,
                    },
                    maxPreload = 100000,
                    preloadFileSize = 1000,
                },
            },
        })
    end,

    ['ts_ls'] = function()
        lspconfig.ts_ls.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            init_options = {
                preferences = { disableSuggestions = true },
            },
            commands = {
                OrganizeImports = {
                    function()
                        require('core.utils').ts_ls.organize_imports()
                    end,
                    description = 'Organize Imports',
                },
                Minify = {
                    function()
                        require('core.utils').ts_ls.minify()
                    end,
                    description = 'esbuild - Minifies js and css files',
                },
            },
        })
    end,

    ['gopls'] = function()
        lspconfig.gopls.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            cmd = { 'gopls' },
            filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
            root_dir = lspconfig_util.root_pattern('go.work', 'go.mod', '.git'),
            settings = {
                gopls = {
                    completeUnimported = true,
                    usePlaceholders = true,
                    analyses = { unusedparams = true },
                },
            },
        })
    end,

    ['rust_analyzer'] = function() end,
}

mason_lspconfig.setup(opts)

vim.api.nvim_create_user_command('LspInstallAll', function()
    if #opts.ensure_installed > 0 then
        vim.cmd('LspInstall ' .. table.concat(opts.ensure_installed, ' '))
    end
end, {})
