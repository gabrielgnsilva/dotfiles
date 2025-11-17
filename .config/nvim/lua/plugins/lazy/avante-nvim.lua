return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = { file_types = { 'markdown', 'Avante' } },
    ft = { 'markdown', 'Avante' },
  },
  {
    'yetone/avante.nvim',
    build = 'make',
    event = 'VeryLazy',
    version = false, -- WARN: Never set this value to "*"! Never!
    dependencies = {
      'MunifTanjim/nui.nvim',
      'hrsh7th/nvim-cmp',
      'ibhagwan/fzf-lua',
      'folke/snacks.nvim',
      'nvim-tree/nvim-web-devicons',
      'zbirenbaum/copilot.lua',
      'MeanderingProgrammer/render-markdown.nvim',
    },
    opts = {
      instructions_file = 'ai_instructions.md',
      provider = 'copilot',
      input = {
        provider = 'snacks',
        provider_opts = { title = 'Avante Input', icon = ' ' },
      },
      windows = { width = 45, input = { height = 10 } },
      selection = { enabled = false },
      behaviour = { auto_set_keymaps = false },
    },
    config = function(_, opts)
      require('avante').setup(opts)
      vim.api.nvim_set_option_value('laststatus', 3, { scope = 'global' })

      require('utils.mappings').load_keymap({
        {
          mode = { 'n', 'v', 'x' },
          bindings = {
            {
              key = '<leader>aa',
              cmd = require('avante.api').ask,
              desc = 'Toggle Avante UI',
            },
          },
        },
        {
          mode = { 'v', 'x' },
          bindings = {
            {
              key = '<leader>ae',
              cmd = require('avante.api').edit,
              desc = 'Chat with selected code',
            },
          },
        },
      })
    end,
  },
}
