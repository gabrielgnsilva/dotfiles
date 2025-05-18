return {
  'folke/flash.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    local flash = require('flash')

    require('core.utils').load_keymaps({
      {
        mode = { 'n', 'x', 'o' },
        bindings = {
          { key = '<leader>/', cmd = flash.jump, desc = 'Flash' },
          -- {keys='S',cmd=flash.treesitter,  desc='Flash Treesitter'},
        },
      },
      -- {
      --     mode = { 'o', 'x' },
      --     bindings = {
      --         {
      --             keys = 'R',
      --             cmd = flash.treesitter_search,
      --             desc = 'Treesitter Search',
      --         },
      --     },
      -- },
      -- {
      --     mode = { 'o' },
      --     bindings = {
      --         {
      --             keys = '<c-s>',
      --             cmd = flash.toggle,
      --             desc = 'Toggle Flash Search',
      --         },
      --     },
      -- },
      -- {
      --     mode = { 'c' },
      --     bindings = {
      --         {
      --             keys = '<c-s>',
      --             cmd = flash.toggle,
      --             desc = 'Toggle Flash Search',
      --         },
      --     },
      -- },
    })
  end,
}
