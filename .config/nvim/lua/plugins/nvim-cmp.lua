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
    },

    opts = {},

    config = function(_, opts)
        local cmp = require('cmp')
        local cmpSelect = { behavior = cmp.SelectBehavior.Select }
        local lspKind = require('lspkind')
        local luaSnip = require('luasnip')

        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-h>'] = cmp.mapping.confirm({ select = true }),
                ['<C-k>'] = cmp.mapping.select_prev_item(cmpSelect),
                ['<C-j>'] = cmp.mapping.select_next_item(cmpSelect),
            }),

            snippet = {
                expand = function(args)
                    luaSnip.lsp_expand(args.body)
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
                        buffer = '[BUFFER]',
                        luasnip = '[SNIPPET]',
                        nvim_lsp = '[LSP]',
                        nvim_lua = '[LUA]',
                        path = '[PATH]',
                    },
                }),
            },

            experimental = {
                native_menu = false,
                ghost_text = true,
            },
        })
    end,
}
