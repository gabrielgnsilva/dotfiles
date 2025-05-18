local U = {}

U.ui = {
  foldexpr = function()
    local buf = vim.api.nvim_get_current_buf()
    if vim.b[buf].ts_folds == nil then
      -- as long as we don't have a filetype, don't bother
      -- checking if treesitter is available (it won't)
      if vim.bo[buf].filetype == '' then
        return '0'
      end
      if vim.bo[buf].filetype:find('dashboard') then
        vim.b[buf].ts_folds = false
      else
        vim.b[buf].ts_folds = pcall(vim.treesitter.get_parser, buf)
      end
    end
    return vim.b[buf].ts_folds and vim.treesitter.foldexpr() or '0'
  end,
}

U.load_keymaps = function(map, opts)
  local M
  if type(map) == 'table' then
    M = map
  elseif type(map) == 'function' then
    M = map()
  else
    M = require('core.mappings')[map]
    if type(M) == 'function' then
      M = M()
    end
  end

  for _, row in ipairs(M) do
    for _, binding in pairs(row.bindings) do
      local keys = type(binding.key) == 'string' and { binding.key }
        or binding.key
      for _, key in ipairs(keys) do
        local options =
          vim.tbl_extend('force', { desc = binding.desc }, binding.opts or {})
        vim.keymap.set(
          row.mode,
          key,
          binding.cmd,
          vim.tbl_extend('force', opts or {}, options)
        )
      end
    end
  end
end

U.lsp = {
  on_attach = function(client, bufnr)
    local builtin = require('telescope.builtin')
    local vlsp = vim.lsp.buf

    require('core.utils').load_keymaps({
      {
        mode = 'n',
        bindings = {
          {
            key = 'gd',
            cmd = vlsp.definition,
            desc = 'LSP Go to definition',
            opts = { buffer = client.buf },
          },
          {
            key = 'gD',
            cmd = vlsp.declaration,
            desc = 'LSP Go to declaration',
            opts = { buffer = client.buf },
          },
          {
            key = 'gi',
            cmd = vlsp.implementation,
            desc = 'LSP Go to implementation',
            opts = { buffer = client.buf },
          },
          {
            key = 'go',
            cmd = vlsp.type_definition,
            desc = 'LSP Go to type definition',
            opts = { buffer = client.buf },
          },
          {
            key = 'gr',
            cmd = vlsp.references,
            desc = 'LSP Show references',
            opts = { buffer = client.buf },
          },
          {
            key = 'H',
            cmd = vlsp.hover,
            desc = 'LSP Show hover information',
            opts = { buffer = client.buf },
          },
          {
            key = 'gs',
            cmd = builtin.lsp_document_symbols,
            desc = 'LSP find symbols on current buffer',
            opts = { buffer = client.buf },
          },
          {
            key = '<leader>ws',
            cmd = builtin.lsp_dynamic_workspace_symbols,
            desc = 'LSP Find symbols on workspace',
            opts = { buffer = client.buf },
          },
          {
            key = '<leader>rn',
            cmd = vlsp.rename,
            desc = 'LSP Rename symbol',
            opts = { buffer = client.buf },
          },
          {
            key = '<leader>ca',
            cmd = vlsp.code_action,
            desc = 'LPS Show code actions',
            opts = { buffer = client.buf },
          },
        },
      },
    })

    if client.server_capabilities.signatureHelpProvider then
      require('core.utils').load_keymaps({
        mode = 'n',
        bindings = {
          {
            key = 'gh',
            cmd = vlsp.signature_help,
            desc = 'LSP Show signature help',
          },
        },
      })
    end

    if client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        callback = function()
          require('conform').format()
        end,
      })
    end
  end,
  capabilities = vim.tbl_deep_extend(
    'force',
    vim.lsp.protocol.make_client_capabilities(),
    require('cmp_nvim_lsp').default_capabilities()
  ),
}

return U
