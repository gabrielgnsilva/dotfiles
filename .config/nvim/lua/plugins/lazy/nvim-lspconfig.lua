return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'b0o/SchemaStore.nvim',
  },
  opts = function()
    return require('configs.nvim-lspconfig')
  end,
  config = function(_, opts)
    require('utils.diagnostics').exclude(opts.ignored_diagnostics)
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        opts.on_attach(client, args.buf)
      end,
    })
    for server, config in pairs(opts.servers or {}) do
      if config == true then
        config = {}
      end

      -- Only call vim.lsp.config if there are custom settings
      if type(config) == 'table' and next(config) ~= nil then
        vim.lsp.config(server, config)
      end
      if server ~= '*' and config ~= false then
        vim.lsp.enable(server)
      end
    end
  end,
}
