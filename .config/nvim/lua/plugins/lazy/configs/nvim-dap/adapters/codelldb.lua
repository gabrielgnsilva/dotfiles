local adapter = {
  name = 'codelldb',
  config = {
    executable = {
      args = { '--port', '${port}' },
      command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
    },
    port = '${port}',
    type = 'server',
  },
}

return adapter
