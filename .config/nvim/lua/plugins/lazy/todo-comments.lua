return {
  'folke/todo-comments.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local todo_comments = require('todo-comments')

    todo_comments.setup({
      signs = false,
      keywords = {
        OK = { icon = ' ', color = 'hint', alt = { 'DONE' } },
        region = {
          icon = ' ',
          color = '#10B981',
          alt = {
            'REGION',
            '#REGION',
            '#region',
          },
        },
        section = {
          icon = ' ',
          color = '#B94F7E',
          alt = {
            'SECTION',
            '#SECTION',
            '#section',
          },
        },
      },
    })

    require('core.utils').load_keymaps({
      {
        mode = { 'n' },
        bindings = {
          {
            key = ']c',
            cmd = todo_comments.jump_next,
            desc = 'Todo Comments Next comment',
          },
          {
            key = '[c',
            cmd = todo_comments.jump_prev,
            desc = 'Todo Comments Previous comment',
          },
        },
      },
    })
  end,
}
