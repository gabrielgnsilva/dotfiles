return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'nvim-telescope/telescope.nvim',
  },
  cmd = { 'LspInstallAll' },
  config = function()
    vim.diagnostic.config({
      -- virtual_text = { prefix = '', source = 'if_many' },
      virtual_text = false,
      underline = true,
      float = { border = 'rounded', source = 'if_many' },
      update_in_insert = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅙',
          [vim.diagnostic.severity.INFO] = '󰋼',
          [vim.diagnostic.severity.HINT] = '󰌵',
          [vim.diagnostic.severity.WARN] = '',
        },
        linehl = {
          [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
          [vim.diagnostic.severity.INFO] = 'InfoMsg',
          [vim.diagnostic.severity.HINT] = 'HintMsg',
          [vim.diagnostic.severity.WARN] = 'WarnMsg',
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
          [vim.diagnostic.severity.INFO] = 'InfoMsg',
          [vim.diagnostic.severity.HINT] = 'HintMsg',
          [vim.diagnostic.severity.WARN] = 'WarningMsg',
        },
      },
    })

    local opts = {
      automatic_enable = {
        exclude = { 'rust_analyzer' },
      }, -- automatically enable (vim.lsp.enable()) installed servers by default.
      ensure_installed = {
        'angularls',
        'bashls',
        'clangd',
        'cssls',
        'emmet_ls',
        'gopls',
        'graphql',
        'html',
        'jsonls',
        'lemminx',
        'lua_ls',
        'pyright',
        'ruff',
        'rust_analyzer',
        'sqls',
        'tailwindcss',
        'ts_ls',
        'yamlls',
      },
    }

    vim.lsp.config('*', {
      on_attach = require('core.utils').lsp.on_attach,
      capabilities = require('core.utils').lsp.capabilities,
      root_markers = { '.git' },
    })

    local files = vim.fn.globpath(
      vim.fn.stdpath('config') .. '/lua/plugins/lazy/configs/lsp/',
      '*.lua',
      false,
      true
    )
    for _, file in ipairs(files) do
      local name = vim.fn.fnamemodify(file, ':t:r')
      local config = require('plugins.lazy.configs.lsp.' .. name)
      vim.lsp.config(name, config)
    end

    require('mason-lspconfig').setup(opts)

    require('core.utils').load_keymaps({
      {
        mode = { 'n' },
        bindings = {
          {
            key = '<leader>rl',
            cmd = '<cmd>:LspRestart<cr>',
            desc = 'Restart LSP',
          },
        },
      },
    })

    vim.api.nvim_create_user_command('LspInstallAll', function()
      if #opts.ensure_installed > 0 then
        vim.cmd('LspInstall ' .. table.concat(opts.ensure_installed, ' '))
      end
    end, {})
  end,
}
