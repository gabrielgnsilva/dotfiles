local lspconfig_util = require('lspconfig.util')

return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_dir = lspconfig_util.root_pattern('go.work', 'go.mod', '.git'),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = { unusedparams = true },
    },
  },
}
