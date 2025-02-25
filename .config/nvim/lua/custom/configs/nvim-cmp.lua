local opts = {
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
}
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_replace = { behavior = cmp.SelectBehavior.Replace }
local lspkind = require('lspkind')
local luasnip = require(
    'luasnip'
)

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
        { name = 'crates', priority = 100 },
        { name = 'luasnip', priority = 100 },
        { name = 'nvim_lua', priority = 90 },
        { name = 'nvim_lsp', priority = 80 },
        { name = 'buffer', keyword_length = 3, priority = 70 },
        { name = 'path', priority = 60 },
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
