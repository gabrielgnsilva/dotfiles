return {
  args = {
    '--stdin',
    '--config',
    vim.fn.stdpath('config')
      .. '/lua/plugins/lazy/configs/nvim-lint/config_files/markdownlint.jsonc',
  },
}
