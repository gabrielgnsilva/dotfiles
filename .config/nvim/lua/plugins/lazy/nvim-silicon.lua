return {
  'michaelrommel/nvim-silicon',
  lazy = true,
  cmd = 'Silicon',
  config = function()
    local silicon = require('nvim-silicon')
    silicon.setup({
      background = '#94e2d5',
      font = 'FiraCode Nerd Font=34;Hack Nerd Font=16',
      theme = 'OneHalfDark',
      to_clipboard = true,
      window_title = function()
        return vim.fn.fnamemodify(
          vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()),
          ':t'
        )
      end,
    })
  end,
}
