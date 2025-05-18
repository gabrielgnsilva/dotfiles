return {
  'christoomey/vim-tmux-navigator',
  config = function()
    require('core.utils').load_keymaps({
      {
        mode = { 'n' },
        bindings = {
          {
            key = '<C-h>',
            cmd = '<cmd>TmuxNavigateLeft<cr>',
            desc = 'TMUX navigate to left window',
          },
          {
            key = '<C-l>',
            cmd = '<cmd>TmuxNavigateRight<cr>',
            desc = 'TMUX navigate to right window',
          },
          {
            key = '<C-j>',
            cmd = '<cmd>TmuxNavigateDown<cr>',
            desc = 'TMUX navigate to bottom window',
          },
          {
            key = '<C-k>',
            cmd = '<cmd>TmuxNavigateUp<cr>',
            desc = 'TMUX navigate to top window',
          },
        },
      },
    })
  end,
}
