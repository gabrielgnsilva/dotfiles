local rcfiles_path =
  string.format('%s/configs/nvim-lint', vim.fn.stdpath('config'))

return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    linters_by_ft = {
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
      custom = {},
      builtin = {
        markdownlint = {
          args = {
            '--stdin',
            '--config',
            string.format('%s/markdownlint.jsonc', rcfiles_path),
          },
        },
        luacheck = {
          args = {
            '--config',
            string.format('%s/luacheckrc', rcfiles_path),
          },
        },
        shellcheck = {
        -- stylua: ignore start
        args = {
          '-e',            'SC2312',
          '-e',            'SC2154',
          '-e',            'SC1090',
          '-e',            'SC2016',
          '--source-path', 'SCRIPTDIR',
          '--enable',      'all',
          '--format',      'tty',
          '--external-sources',
          '-',
        },
          -- stylua: ignore end
        },
      },
    },
  },
  config = function(_, opts)
    local lint = require('lint')
    lint.linters_by_ft = opts.linters_by_ft
    for name, config in pairs(opts.linters.custom) do
      lint.linters[name] = config
    end
    for linter, _ in pairs(opts.linters.builtin) do
      for opt, config in pairs(opts.linters.builtin[linter]) do
        lint.linters[linter][opt] = config
      end
    end

    require('utils.mappings').load_keymap({
      {
        mode = { 'n' },
        bindings = {
          {
            key = '<leader>l',
            cmd = require('lint').try_lint,
            desc = 'Trigger linting on current buffer',
          },
        },
      },
    })
  end,
}
