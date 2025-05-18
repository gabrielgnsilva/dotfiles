return {
  prepend_args = {
    '--config',
    string.format(
      '%s/lua/plugins/lazy/configs/conform/config_files/prettierrc.json',
      vim.fn.stdpath('config')
    ),
  },
}
