return {
  'hrsh7th/nvim-cmp',
  event = { 'InsertEnter' },
  dependencies = {
    -- snippet
    -- {
    --   'L3MON4D3/LuaSnip',
    --   event = { 'InsertEnter' },
    --   tag = 'v2.4.1',
    --   opts = {
    --     history = true,
    --     updateevents = 'TextChanged,TextChangedI',
    --     enable_autosnippets = true,
    --   },
    --   config = function(_, opts)
    --     local luasnip = require('luasnip')
    --
    --     luasnip.config.set_config(opts)
    --
    --     require('luasnip.loaders.from_lua').load({
    --       paths = string.format(
    --         '%s/configs/luasnip',
    --         vim.fn.stdpath('config')
    --       ),
    --     })
    --
    --     require('utils').create_autocmd('luasnip', 'InsertLeave', {
    --       callback = function()
    --         if
    --           luasnip.session.current_nodes[vim.api.nvim_get_current_buf()]
    --           and not luasnip.session.jump_active
    --         then
    --           luasnip.unlink_current()
    --         end
    --       end,
    --     })
    --
    --     require('utils.mappings').load_keymap({
    --       {
    --         mode = { 'i', 's' },
    --         bindings = {
    --           {
    --             key = '<C-j>',
    --             cmd = function()
    --               if require('luasnip').expand_or_jumpable() then
    --                 require('luasnip').expand_or_jump()
    --               end
    --             end,
    --             desc = 'LuaSnip next jump',
    --             opts = { silent = true },
    --           },
    --           {
    --             key = '<C-k>',
    --             cmd = function()
    --               if require('luasnip').jumpable(-1) then
    --                 require('luasnip').jump(-1)
    --               end
    --             end,
    --             desc = 'LuaSnip prev jump',
    --             opts = { silent = true },
    --           },
    --         },
    --       },
    --       {
    --         mode = { 'n' },
    --         bindings = {
    --           {
    --             key = '<leader>rs',
    --             cmd = function()
    --               require('luasnip.loaders.from_lua').load({
    --                 paths = string.format(
    --                   '%s/configs/luasnip',
    --                   vim.fn.stdpath('config')
    --                 ),
    --               })
    --             end,
    --             desc = 'LuaSnip source snippets',
    --           },
    --         },
    --       },
    --       {
    --         mode = { 'i' },
    --         bindings = {
    --           {
    --             key = '<C-i>',
    --             cmd = function()
    --               if require('luasnip').choice_active() then
    --                 require('luasnip').change_choice(1)
    --               end
    --             end,
    --             desc = 'LuaSnip next choice',
    --           },
    --           {
    --             key = '<C-l>',
    --             cmd = function()
    --               if require('luasnip').choice_active() then
    --                 require('luasnip').change_choice(-1)
    --               end
    --             end,
    --             desc = 'LuaSnip prev choice',
    --           },
    --         },
    --       },
    --     })
    --   end,
    -- },
    -- cmp sources
    {
      -- 'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
    },
    -- UI
    { 'onsails/lspkind.nvim', 'brenoprata10/nvim-highlight-colors' },
  },
  opts = function()
    local cmp = require('cmp')
    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    local cmp_replace = { behavior = cmp.SelectBehavior.Replace }
    local lspkind = require('lspkind')
    local border = vim.g.border_style or 'rounded'

    -- require('snippets')
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
          -- luasnip.lsp_expand(args.body)
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
        format = function(entry, item)
          local color_item = require('nvim-highlight-colors').format(entry, {
            kind = item.kind,
          })
          item = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = 50,
          })(entry, item)
          local strings = vim.split(item.kind, '%s', { trimempty = true })
          item.kind = ' ' .. (strings[1] or '') .. ' '
          item.menu = '    (' .. (strings[2] or '') .. ')'
          if color_item.abbr_hl_group then
            item.kind_hl_group = color_item.abbr_hl_group
            item.kind = color_item.abbr
          end
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
