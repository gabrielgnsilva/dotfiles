return {
  'stevearc/quicker.nvim',
  -- Loading on FileType=qf schedules a setqflist() while Neovim's LSP
  -- change tracking may still be processing a buffer update.
  event = 'VeryLazy',
  opts = { on_qf = require('utils.lsp').detach_clients },
}
