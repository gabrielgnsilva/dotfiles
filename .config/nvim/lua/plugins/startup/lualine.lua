return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'folke/noice.nvim',
    'nvim-tree/nvim-web-devicons',
    'linrongbin16/lsp-progress.nvim',
  },
  config = function()
    local opts = {
      options = {
        icons_enabled = true,
        theme = 'onedark',
        component_separators = '',
        section_separators = { left = '', right = '' },
        refresh = { statusline = 1000 },
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      extensions = {
        'mason',
        'man',
        'nvim-dap-ui',
        'quickfix',
        'trouble',
        'fzf',
        'fugitive',
        'nvim-tree',
        'lazy',
      },
    }

    -- stylua: ignore start
    local section_a = function (component) table.insert(opts.sections.lualine_a, component) end
    local section_b = function (component) table.insert(opts.sections.lualine_b, component) end
    local section_c = function (component) table.insert(opts.sections.lualine_c, component) end
    local section_x = function (component) table.insert(opts.sections.lualine_x, component) end
    local section_y = function (component) table.insert(opts.sections.lualine_y, component) end
    local section_z = function (component) table.insert(opts.sections.lualine_z, component) end
    -- stylua: ignore end

    -- +---------------------------------------------------+
    -- | >A< | B | C                             X | Y | Z |
    -- +---------------------------------------------------+
    section_a({
      'mode',
      separator = { left = '' },
      right_padding = 2,
    })

    -- +---------------------------------------------------+
    -- | A | >B< | C                             X | Y | Z |
    -- +---------------------------------------------------+
    section_b({
      'filesize',
      cond = function()
        return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
      end,
    })
    section_b({
      'filename',
      path = 1,
      file_status = true,
      newfile_status = false,
      symbols = {
        modified = '',
        readonly = '[R]',
        unnamed = '[NO NAME]',
        newfile = '[NEW]',
      },
    })

    -- +---------------------------------------------------+
    -- | A | B | >C<                             X | Y | Z |
    -- +---------------------------------------------------+
    section_c({
      'diagnostics',
      symbols = {
        error = '󰅙 ',
        info = '󰋼 ',
        hint = '󰌵 ',
        warn = ' ',
      },
    })

    -- +---------------------------------------------------+
    -- | A | B | C                             >X< | Y | Z |
    -- +---------------------------------------------------+
    section_x({
      require('lazy.status').updates,
      cond = require('lazy.status').has_updates,
      color = { fg = '#ff9e64' },
    })
    section_x({
      require('noice').api.status.mode.get,
      cond = require('noice').api.status.mode.has,
      color = { fg = '#64aaff' },
    })
    section_x({
      require('noice').api.status.search.get,
      cond = require('noice').api.status.search.has,
      color = { fg = '#64aaff' },
    })

    -- +---------------------------------------------------+
    -- | A | B | C                             X | >Y< | Z |
    -- +---------------------------------------------------+
    section_y({
      'diff',
      symbols = { added = '󰐗 ', modified = '󰛿 ', removed = '󰍶 ' },
      source = function()
        local gs = vim.b.gitsigns_status_dict
        if gs then
          return {
            added = gs.added,
            modified = gs.changed,
            removed = gs.removed,
          }
        end
      end,
      separator = '',
      left_padding = 1,
    })
    section_y({ 'branch', separator = '', left_padding = 1 })

    -- +---------------------------------------------------+
    -- | A | B | C                             X | Y | >Z< |
    -- +---------------------------------------------------+
    section_z({ 'location', separator = '', left_padding = 1 })
    section_z({ 'progress', separator = '', right_padding = 1 })

    require('lualine').setup(opts)
  end,
}
