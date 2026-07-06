return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    {
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
    },
    -- UI
    { 'brenoprata10/nvim-highlight-colors' },
  },
  opts = function()
    local cmp = require('cmp')
    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    local cmp_replace = { behavior = cmp.SelectBehavior.Replace }
    local border = vim.g.border_style or 'rounded'

    local snippet = require('utils.snippets')
    snippet.setup()

    return {
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

        ['<Tab>'] = cmp.mapping.confirm({
          select = true,
          behavior = cmp_replace,
        }),
      }),

      snippet = {
        expand = function(arg)
          vim.snippet.expand(arg.body)
        end,
      },

      sources = {
        -- { name = 'luasnip', priority = 100 },
        { name = 'vim.snippet', priority = 100 },
        { name = 'path', priority = 90 },
        { name = 'nvim_lua', priority = 80 },
        { name = 'nvim_lsp', priority = 70 },
        { name = 'buffer', keyword_length = 3, priority = 50 },
      },

      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(_, item)
          item.kind = string.format(' (%s)', item.kind:lower())
          return item
        end,
      },

      experimental = {
        ghost_text = { hl_group = 'Comment' },
      },

      completion = {
        completeopt = 'menu,menuone',
      },

      window = {
        completion = {
          side_padding = 0,
          winhighlight = 'Normal:None,CursorLine:PmenuSel,Search:None',
          scrollbar = false,
          border = border,
        },
        documentation = {
          border = border,
          winhighlight = 'Normal:None',
        },
      },
    }
  end,
}
