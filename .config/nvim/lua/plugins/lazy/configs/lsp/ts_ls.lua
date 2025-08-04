local on_attach = function(client, buf)
  require('core.utils').lsp.on_attach(client, buf)
  vim.api.nvim_buf_create_user_command(
    0,
    'LspTypescriptSourceAction',
    function()
      local source_actions = vim.tbl_filter(function(action)
        return vim.startswith(action, 'source.')
      end, client.server_capabilities.codeActionProvider.codeActionKinds)

      vim.lsp.buf.code_action({
        context = {
          only = source_actions,
        },
      })
    end,
    {}
  )
end

return {
  on_attach = on_attach,
  capabilities = require('core.utils').lsp.capabilities,
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = {
    'javascript',
    'javascript.jsx',
    'javascriptreact',
    'typescript',
    'typescript.tsx',
    'typescriptreact',
  },
  init_options = {
    hostInfo = 'neovim',
    preferences = { disableSuggestions = true },
  },
  root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
  handlers = {
    ['_typescript.OrganizeImports'] = function()
      local params = {
        command = '_typescript.OrganizeImports',
        arguments = { vim.api.nvim_buf_get_name(0) },
      }
      vim.lsp.buf.execute_command(params)
    end,
    ['_typescript.rename'] = function(_, result, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      vim.lsp.util.show_document({
        uri = result.textDocument.uri,
        range = {
          start = result.position,
          ['end'] = result.position,
        },
      }, client.offset_encoding)
      vim.lsp.buf.rename()
      return vim.NIL
    end,
  },
}
