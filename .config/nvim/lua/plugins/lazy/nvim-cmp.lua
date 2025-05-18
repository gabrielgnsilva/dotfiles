return {
  'hrsh7th/nvim-cmp',
  event = { 'InsertEnter' },
  dependencies = {
    -- 'windwp/nvim-autopairs',
    'echasnovski/mini.pairs',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'onsails/lspkind.nvim',
  },
  config = function()
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
          local kind = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = 50,
          })(entry, vim_item)
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

    local function next_in_list()
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      end
    end

    local function prev_in_list()
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      end
    end

    local function reload_snippets()
      require('luasnip.loaders.from_lua').load({
        paths = vim.fn.stdpath('config')
          .. '/lua/plugins/lazy/configs/luaSnip/snippets/',
      })
    end

    local function next_choice_in_list()
      if luasnip.choice_active() then
        luasnip.change_choice(1)
      end
    end

    local function prev_choice_in_list()
      if luasnip.choice_active() then
        luasnip.change_choice(-1)
      end
    end

    require('core.utils').load_keymaps({
      {
        mode = { 'i', 's' },
        bindings = {
          {
            key = '<C-j>',
            cmd = next_in_list,
            desc = 'LuaSnip next jump',
            opts = { silent = true },
          },
          {
            key = '<C-k>',
            cmd = prev_in_list,
            desc = 'LuaSnip prev jump',
            opts = { silent = true },
          },
        },
      },
      {
        mode = { 'n' },
        bindings = {
          {
            key = '<leader>rs',
            cmd = reload_snippets,
            desc = 'LuaSnip source snippets',
          },
        },
      },
      {
        mode = { 'i' },
        bindings = {
          {
            key = '<C-i>',
            cmd = next_choice_in_list,
            desc = 'LuaSnip next choice',
          },
          {
            key = '<C-l>',
            cmd = prev_choice_in_list,
            desc = 'LuaSnip prev choice',
          },
        },
      },
    })
  end,
}
