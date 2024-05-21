--[[
    Command completion.
]]

return {
    event = 'VeryLazy',

    'hrsh7th/nvim-cmp',
    dependencies = {
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-nvim-lsp',
        'onsails/lspkind.nvim',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
    },

    opts = {},

    config = function(_, opts)
        local cmp = require('cmp')
        local cmpSelect = { behavior = cmp.SelectBehavior.Select }
        local lspKind = require('lspkind')
        local ls = require('luasnip')

        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ['<C-Space>'] = cmp.mapping({
                    i = function()
                        if cmp.visible() then
                            cmp.abort()
                        else
                            cmp.complete()
                        end
                    end,
                    c = function()
                        if cmp.visible() then
                            cmp.close()
                        else
                            cmp.complete()
                        end
                    end,
                }),
                ['<C-h>'] = cmp.mapping.confirm({ select = true }),
                ['<C-k>'] = cmp.mapping.select_prev_item(cmpSelect),
                ['<C-j>'] = cmp.mapping.select_next_item(cmpSelect),
            }),

            snippet = {
                expand = function(args)
                    ls.lsp_expand(args.body)
                end,
            },
            sources = {
                { name = 'nvim_lua' },
                { name = 'nvim_lsp' },
                { name = 'path' },
                { name = 'luasnip' },
                { name = 'buffer', keyword_length = 5 },
            },

            formatting = {
                format = lspKind.cmp_format({
                    with_text = true,
                    menu = {
                        buffer = '[BFR]',
                        luasnip = '[SNP]',
                        nvim_lsp = '[LSP]',
                        nvim_lua = '[LUA]',
                        path = '[PTH]',
                    },
                }),
            },

            experimental = {
                native_menu = false,
                ghost_text = true,
            },
        })

        ls.config.set_config({
            history = true,
            updateevents = 'TextChanged,TextChangedI',
            enbable_autosnippets = true,
        })

        require('luasnip.loaders.from_lua').load({ paths = vim.fn.stdpath('config') .. '/lua/snippets' })
    end,
}
