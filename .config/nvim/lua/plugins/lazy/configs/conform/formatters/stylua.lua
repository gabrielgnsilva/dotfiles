return {
  prepend_args = {
    '--config-path',
    vim.fn.stdpath('config')
      .. '/lua/plugins/lazy/configs/conform/config_files/stylua.toml',
  },
}
