return {
  'gabrielgnsilva/floaterm.nvim',
  cmd = 'FloatingTerminal',
  keys = { '<leader>t', '<leader>T' },
  opts = {},
  config = function(_, opts)
    local floaterm = require('floaterm')

    floaterm.setup(opts)

    require('utils.mappings').load_keymap({
      {
        mode = { 'n' },
        bindings = {
          {
            key = '<leader>T',
            cmd = function()
              floaterm.toggle({ use_oil_cwd = true })
            end,
            desc = 'Open terminal in oil.nvim directory',
          },
        },
      },
    })
  end,
}
