return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    local autocmd = vim.api.nvim_create_autocmd
    local augroup = vim.api.nvim_create_augroup

    local opts = {
      files = {
        bash = { 'shellcheck' },
        c = { 'cpplint' },
        cpp = { 'cpplint' },
        javascript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        json = { 'jsonlint' },
        lua = { 'luacheck' },
        markdown = { 'markdownlint' },
        python = { 'ruff' },
        sh = { 'shellcheck' },
        typescript = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
      },

      linters = {
        markdownlint = require(
          'plugins.lazy.configs.nvim-lint.linters.markdownlint'
        ),
        luacheck = require('plugins.lazy.configs.nvim-lint.linters.luacheck'),
        shellcheck = require(
          'plugins.lazy.configs.nvim-lint.linters.shellcheck'
        ),
      },
    }

    local lint = require('lint')
    lint.linters_by_ft = opts.files
    for opt in pairs(opts.linters) do
      local linter = lint.linters[opt]
      linter.args = opts.linters[opt].args
    end

    autocmd({ 'bufEnter', 'bufWritePost', 'insertLeave' }, {
      group = augroup('lint', { clear = true }),
      callback = function()
        lint.try_lint()
      end,
    })

    require('core.utils').load_keymaps({
      {
        mode = { 'n' },
        bindings = {
          {
            key = '<leader>l',
            cmd = lint.try_lint,
            desc = 'Trigger linting on current buffer',
          },
        },
      },
    })
  end,
}
