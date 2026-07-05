return {
  'folke/todo-comments.nvim',
  event = { 'BufNewFile', 'BufReadPost' },
  opts = {
    signs = false,
    keywords = {
      DONE = { icon = ' ', color = 'hint', alt = { 'DONE', 'OK' } },
      FIX = {
        icon = ' ',
        color = 'error',
        alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE', 'ERROR', 'DANGER' },
      },
      IMPORTANT = {
        icon = ' ',
        color = 'warning',
        alt = { 'IMPORTANT', '!!!', '!!' },
      },
      TODO = { icon = ' ', color = 'info' },
      HACK = { icon = ' ', color = 'warning', alt = { 'SECURITY' } },
      WARN = { icon = ' ', color = 'warning', alt = { 'WARNING' } },
      PERF = { icon = ' ', alt = { 'PERFORMANCE', 'OPTIMIZE' } },
      NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
      TEST = {
        icon = '⏲ ',
        color = 'test',
        alt = { 'TESTING', 'PASSED', 'FAILED' },
      },
    },
  },
  config = function(_, opts)
    require('todo-comments').setup(opts)
    require('utils.mappings').load_keymap({
      {
        mode = { 'n' },
        bindings = {
          {
            key = ']c',
            cmd = require('todo-comments').jump_next,
            desc = 'Todo Comments Next comment',
          },
          {
            key = '[c',
            cmd = require('todo-comments').jump_prev,
            desc = 'Todo Comments Previous comment',
          },
        },
      },
    })
  end,
}
