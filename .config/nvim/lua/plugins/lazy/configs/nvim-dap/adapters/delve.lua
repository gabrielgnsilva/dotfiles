local adapter = {
  name = 'delve',
  config = {
    executable = {
      args = { 'dap', '-l', '127.0.0.1:${port}' },
      command = vim.fn.stdpath('data') .. '/mason/bin/dlv',
    },
    port = '${port}',
    type = 'server',
  },
}

return adapter
