return {
  'brenoprata10/nvim-highlight-colors',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    enable_tailwind = false,
    virtual_symbol = '|',
    virtual_symbol_suffix = '',
  },
  config = function(_, opts)
    require('nvim-highlight-colors').setup(opts)
    vim.cmd('HighlightColors On')
  end,
}
