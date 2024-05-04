--[[
    Language Server Protocol (LSP) configuration.
]]

return {
    event = 'VeryLazy',

    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        'hrsh7th/cmp-nvim-lsp',
    },

    opts = {
        ensure_installed = {
            'bashls',
            'cssls',
            'emmet_ls',
            'eslint',
            'html',
            'jsonls',
            'lua_ls',
            'rust_analyzer',
            'tsserver',
        },
    },

    config = function(_, opts)
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        local lspConfig = require('lspconfig')
        local mason = require('mason')
        local masonConfig = require('mason-lspconfig')
        local MasonToolInstaller = require('mason-tool-installer')

        local lsp_attach = function(client)
            local opt = function(desc)
                return { buffer = client.buf, remap = false, desc = desc }
            end
            local formatOptions =
                '{ async = false, tabSize = 4, insertSpaces = true, trimTrailingWhitespace = true, trimFinalNewlines = true, insertFinalNewline = true }'

            -- Keymaps
            vim.keymap.set(
                'n',
                'H',
                '<cmd>lua vim.lsp.buf.hover()<cr>',
                opt('Show hover information')
            )
            vim.keymap.set(
                'n',
                'gd',
                '<cmd>lua vim.lsp.buf.definition()<cr>',
                opt('Go to definition')
            )
            vim.keymap.set(
                'n',
                'gD',
                '<cmd>lua vim.lsp.buf.declaration()<cr>',
                opt('Go to declaration')
            )
            vim.keymap.set(
                'n',
                'gi',
                '<cmd>lua vim.lsp.buf.implementation()<cr>',
                opt('Go to implementation')
            )
            vim.keymap.set(
                'n',
                'go',
                '<cmd>lua vim.lsp.buf.type_definition()<cr>',
                opt('Go to type definition')
            )
            vim.keymap.set(
                'n',
                'gr',
                '<cmd>lua vim.lsp.buf.references()<cr>',
                opt('Show references')
            )
            vim.keymap.set(
                'n',
                'gs',
                '<cmd>lua vim.lsp.buf.signature_help()<cr>',
                opt('Show signature help')
            )
            vim.keymap.set(
                'n',
                '<leader>rn',
                '<cmd>lua vim.lsp.buf.rename()<cr>',
                opt('Rename symbol')
            )
            vim.keymap.set(
                'n',
                '<leader>fm',
                '<cmd>lua vim.lsp.buf.format(' .. formatOptions .. ')<cr>',
                opt('Format document')
            )
            vim.keymap.set(
                'n',
                '<leader>ca',
                vim.lsp.buf.code_action,
                opt('Show code actions')
            )
        end

        opts.handlers = {
            function(server_name)
                lspConfig[server_name].setup({
                    on_attach = lsp_attach,
                    capabilities = capabilities,
                })
            end,
            ['lua_ls'] = function()
                lspConfig.lua_ls.setup({
                    on_attach = lsp_attach,
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { 'vim' },
                            },
                        },
                    },
                })
            end,
        }

        mason.setup()
        masonConfig.setup(opts)
        MasonToolInstaller.setup({
            ensure_installed = {
                'black', -- Python Formatter
                'prettier', -- Formatter
                'shfmt', -- Shell script formatter
                'stylua', -- Lua formatter
                'eslint_d', -- eslint linter
                'isort', -- Python Linter
                'pylint', -- Python Linter
                'shellcheck', -- Shell script linter
            },
        })
    end,
}
