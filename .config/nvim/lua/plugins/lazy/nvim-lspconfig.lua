return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'b0o/SchemaStore.nvim',
    {
      'mason-org/mason.nvim',
      dependencies = { 'mason-org/mason-lspconfig.nvim' },
    },
  },
  config = function()
    require('mason').setup(require('configs.mason'))
    require('utils.mason').create_install_all_cmd()
    require('mason-lspconfig').setup(require('configs.mason-lspconfig'))

    local lspconfig_opts = require('configs.nvim-lspconfig')
    require('utils.diagnostics').exclude(lspconfig_opts.ignored_diagnostics)
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        lspconfig_opts.on_attach(client, args.buf)
      end,
    })

    local utils = require('utils.lsp')
    for server, config in pairs(lspconfig_opts.servers or {}) do
      utils.enable(server, config)
    end
  end,
}
