return {
  'olexsmir/gopher.nvim',
  ft = 'go',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  build = function()
    vim.cmd([[silent! GoInstallDeps]])
  end,
}
