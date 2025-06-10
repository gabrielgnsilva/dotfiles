return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  version = false, -- WARN: Never set this value to "*"! Never!
  build = 'make',

  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    -- #region: Optional
    'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
    'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    'zbirenbaum/copilot.lua', -- for providers='copilot'
    {
      -- BUG: Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = { file_types = { 'Avante' } },
      ft = { 'Avante' },
    },
    -- #regionend
  },

  opts = {
    provider = 'copilot',
    behaviour = { auto_set_keymaps = false },
    windows = {
      position = 'right',
      wrap = true,
      width = 45, -- INFO: Screen percentage
      sidebar_header = { enabled = false },
      input = { prefix = '> ', height = 10 },
      edit = { border = 'rounded', start_insert = true },
      ask = {
        floating = false,
        start_insert = true,
        border = 'rounded',
        focus_on_apply = 'ours',
      },
    },
  },

  config = function(_, opts)
    require('avante').setup(opts)
    require('core.utils').load_keymaps({
      {
        mode = { 'n', 'v', 'x' },
        bindings = {
          {
            key = '<leader>aa',
            cmd = '<cmd>AvanteAsk<cr>',
            desc = 'Avante ask',
          },
          {
            key = '<leader>ae',
            cmd = '<cmd>AvanteEdit<cr>',
            desc = 'Avante edit',
          },
          {
            key = '<leader>ar',
            cmd = '<cmd>AvanteRefresh<cr>',
            desc = 'Avante refresh',
          },
        },
      },
    })
  end,
}
