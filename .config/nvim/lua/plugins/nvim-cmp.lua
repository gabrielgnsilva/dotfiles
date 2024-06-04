--[[
    Command completion.
]]

return {
    event = 'InsertEnter',

    'hrsh7th/nvim-cmp',
    dependencies = {
        {
            'windwp/nvim-autopairs',
            opts = {
                check_ts = true,
                ts_config = { lua = { 'string' }, javascript = { 'template_string' } },
                fast_wrap = {},
                disable_filetype = { 'TelescopePrompt', 'vim' },
            },
            config = function(_, opts)
                require('nvim-autopairs').setup(opts)
                local cmp_autopairs = require('nvim-autopairs.completion.cmp')
                require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
            end,
        },
        {
            'L3MON4D3/LuaSnip',
            opts = { history = true, updateevents = 'TextChanged,TextChangedI', enbable_autosnippets = true },
            config = function(_, opts)
                local luasnip = require('luasnip')
                luasnip.config.set_config(opts)
                require('luasnip.loaders.from_lua').load()
                require('luasnip.loaders.from_lua').lazy_load({ paths = vim.fn.stdpath('config') .. '/lua/snippets' })
                vim.api.nvim_create_autocmd('InsertLeave', {
                    callback = function()
                        if
                            luasnip.session.current_nodes[vim.api.nvim_get_current_buf()]
                            and not luasnip.session.jump_active
                        then
                            luasnip.unlink_current()
                        end
                    end,
                })
            end,
        },
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'onsails/lspkind.nvim',
    },

    opts = {
        border = {
            { '╭', 'None' },
            { '─', 'None' },
            { '╮', 'None' },
            { '│', 'None' },
            { '╯', 'None' },
            { '─', 'None' },
            { '╰', 'None' },
            { '│', 'None' },
        },
    },

    config = function(_, opts)
        local map = vim.keymap.set
        local cmp = require('cmp')
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        local cmp_replace = { behavior = cmp.SelectBehavior.Replace }
        local lspkind = require('lspkind')
        local luasnip = require('luasnip')

        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ['<C-Space>'] = cmp.mapping(function()
                    if cmp.visible() then
                        cmp.close()
                    else
                        cmp.complete()
                    end
                end, { 'i', 'c' }),

                ['<C-j>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item(cmp_select)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),

                ['<C-k>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item(cmp_select)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),

                ['<C-h>'] = cmp.mapping.confirm({
                    select = true,
                    behavior = cmp_replace,
                }),
            }),

            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },

            sources = {
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'buffer', keyword_length = 3 },
                { name = 'nvim_lua' },
                { name = 'path' },
            },

            formatting = {
                fields = { 'kind', 'abbr', 'menu' },
                format = function(entry, vim_item)
                    local kind = lspkind.cmp_format({ mode = 'symbol_text', maxwidth = 50 })(entry, vim_item)
                    local strings = vim.split(kind.kind, '%s', { trimempty = true })
                    kind.kind = ' ' .. (strings[1] or '') .. ' '
                    kind.menu = '    (' .. (strings[2] or '') .. ')'

                    return kind
                end,
            },

            experimental = {
                native_menu = false,
                ghost_text = true,
            },

            completion = {
                completeopt = 'menu,menuone',
            },

            window = {
                completion = {
                    side_padding = 0,
                    winhighlight = 'Normal:None,CursorLine:PmenuSel,Search:None',
                    scrollbar = false,
                    border = opts.border,
                },
                documentation = {
                    border = opts.border,
                    winhighlight = 'Normal:None',
                },
            },
        })

        -- Keymaps
        map('n', '<C-i>', function()
            if luasnip.choice_active() then
                luasnip.change_choice(1)
            end
        end, { desc = 'LuaSnip next choice' })

        map('n', '<C-l>', function()
            if luasnip.choice_active() then
                luasnip.change_choice(-1)
            end
        end, { desc = 'LuaSnip prev choice' })

        map('n', '<leader><leader>s', function()
            require('luasnip.loaders.from_lua').load({ paths = vim.fn.stdpath('config') .. '/lua/snippets' })
        end, { desc = 'LuaSnip source snippets' })

        map({ 'i', 's' }, '<C-j>', function()
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            end
        end, { desc = 'LuaSnip next jump', silent = true })

        map({ 'i', 's' }, '<C-k>', function()
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            end
        end, { desc = 'LuaSnip prev jump', silent = true })
    end,
}
