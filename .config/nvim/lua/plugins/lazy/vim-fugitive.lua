return {
  'tpope/vim-fugitive',
  config = function()
    require('utils.mappings').load_keymap({
      {
        mode = { 'n' },
        bindings = {
          {
            key = '<leader>gs',
            cmd = vim.cmd.Git,
            desc = 'Show git status',
          },
        },
      },
    })
  end,
}
