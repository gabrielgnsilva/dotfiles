--[[
    Language Server Protocol (LSP) configuration.
]]

return {
    event = {
        'BufReadPost', -- Starting to edit an existing file
        'BufNewFile', -- Starting to edit a non-existent file
    },

    'neovim/nvim-lspconfig',
    dependencies = {
        { 'williamboman/mason.nvim', cmd = { 'Mason', 'MasonInstall', 'MasonInstallAll', 'MasonUpdate' } },
        'williamboman/mason-lspconfig.nvim',
        'hrsh7th/cmp-nvim-lsp',
    },

    opts = {
        -- LSP
        ensure_installed = {
            'bashls',
            'cssls',
            'emmet_ls',
            'eslint',
            'clangd',
            'angularls',
            'html',
            'jsonls',
            'lua_ls',
            'rust_analyzer',
            'tsserver',
        },

        -- Mason
        mason_ensure_installed = {
            'black', -- Python Formatter
            'prettier', -- Formatter
            'shfmt', -- Shell script formatter
            'stylua', -- Lua formatter
            'eslint_d', -- eslint linter
            'isort', -- Python Linter
            'pylint', -- Python Linter
            'shellcheck', -- Shell script linter
        },
    },

    config = function(_, opts)
        local lspconfig = require('lspconfig')
        local mason = require('mason')
        local mason_lspconfig = require('mason-lspconfig')
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        local on_attach = function(client)
            local map = vim.keymap.set

            local desc = function(desc)
                return { buffer = client.buf, desc = 'LSP ' .. desc }
            end

            -- Keymaps
            map('n', 'gd', vim.lsp.buf.definition, desc('Go to definition'))
            map('n', 'gD', vim.lsp.buf.declaration, desc('Go to declaration'))
            map('n', 'gi', vim.lsp.buf.implementation, desc('Go to implementation'))
            map('n', 'go', vim.lsp.buf.type_definition, desc('Go to type definition'))
            map('n', 'gr', vim.lsp.buf.references, desc('Show references'))
            map('n', 'H', vim.lsp.buf.hover, desc('Show hover information'))
            map('n', '<leader>ra', vim.lsp.buf.rename, desc('Rename symbol'))
            map('n', '<leader>ca', vim.lsp.buf.code_action, desc('Show code actions'))
            map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, desc('Add workspace folder'))
            map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, desc('Remove workspace folder'))

            if client.server_capabilities.signatureHelpProvider then
                map('n', 'gh', vim.lsp.buf.signature_help, desc('Show signature help'))
            end
        end

        vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
        vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            border = 'rounded',
        })

        local signs = { Error = '󰅙', Info = '󰋼', Hint = '󰌵', Warn = '' }
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
            -- Detault
            function(server_name)
                lspconfig[server_name].setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
            end,

            -- Server specific
            ['lua_ls'] = function()
                lspconfig.lua_ls.setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { 'vim' },
                            },
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
        }

        mason.setup({
            ui = {
                icons = {
                    package_uninstalled = '',
                    package_installed = '',
                    package_pending = '',
                },
            },
        })
        mason_lspconfig.setup(opts)

        vim.api.nvim_create_user_command('MasonInstallAll', function()
            if opts.ensure_installed and #opts.ensure_installed > 0 then
                vim.cmd('MasonInstall ' .. table.concat(opts.mason_ensure_installed, ' '))
            end
        end, {})
    end,
}
