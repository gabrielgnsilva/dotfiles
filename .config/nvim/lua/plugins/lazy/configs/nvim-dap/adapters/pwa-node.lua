local adapter = {
  name = 'pwa-node',
  config = {
    type = 'server',
    host = 'localhost',
    port = '8123',
    executable = {
      command = vim.fn.stdpath('data') .. '/mason/bin/js-debug-adapter',
    },
  },
}
return adapter
