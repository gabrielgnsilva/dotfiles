return {
  'tpope/vim-fugitive',
  event = 'VeryLazy',
  config = function()
    require('core.utils').load_keymaps({
      {
        mode = { 'n' },
        bindings = {
          { key = '<leader>gs', cmd = vim.cmd.Git, desc = 'Show git status' },
        },
      },
    })
  end,
}
