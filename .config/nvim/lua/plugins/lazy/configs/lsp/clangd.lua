local lspconfig = require('lspconfig')
local capabilities = require('core.utils').lsp.capabilities
capabilities.offsetEncoding = { 'utf-16' }

return {
  capabilities = capabilities,
  cmd = { 'clangd' },
  root_markers = { '.clangd', 'compile_commands.json' },
  filetypes = { 'c', 'cpp' },
}
