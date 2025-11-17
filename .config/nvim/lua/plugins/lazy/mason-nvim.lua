return {
  'mason-org/mason.nvim',
  cmd = { 'Mason', 'MasonInstall', 'MasonUpdate' },
  opts = {
    ui = {
      icons = {
        package_installed = '',
        package_pending = '',
        package_uninstalled = '',
      },
    },

    max_concurrent_installers = 10,

    ensure_installed = {
      'black', -- Python Formatter
      'debugpy', -- Python Debugger
      'isort', -- Python Formatter
      'clang-format', -- Clang Formatter
      'codelldb', -- Rust, Clang.. Debugger
      'cpplint', --C/C++ Linter
      'delve', -- Go Debugger
      'gofumpt', -- Go Formatter
      'goimports-reviser', -- Go Formatter
      'golangci-lint', -- Go Formatter
      'golines', -- Go Formatter
      'gomodifytags', -- Go Tool
      'gotests', -- Go Tool
      'iferr', -- Go Tool
      'impl', -- Go Tool
      'sqlfluff', -- SQL Linter
      'sqlfmt', -- SQL Formatter
      'luacheck', -- Lua formatter
      'stylua', -- Lua formatter
      'markdownlint', -- Markdown Linter
      'jsonlint', -- JSON Linter
      'rustfmt', -- RUST Linter
      'shellcheck', -- Shell script linter
      'beautysh', -- Shell script formatter
      'shfmt', -- Shell script formatter
      'js-debug-adapter', -- JS Debugger adapter
      'eslint_d', -- Various languages linter
      'prettier', -- Various languages Formatter
      'yamlfmt', -- YAML Formatter
      'yamllint', -- YAML Linter
      'vale', -- Latex Linter
      'bibtex-tidy', -- Latex (.bib) formatter
      'tectonic', -- Latex Compiler
      'tex-fmt', -- Latex Formatter
      'ltex-ls-plus', -- Latex LSP
    },
  },
  config = function(_, opts)
    require('mason').setup(opts)
    local ensure_installed = opts.ensure_installed or {}
    vim.api.nvim_create_user_command('MasonInstallAll', function()
      if #ensure_installed > 0 then
        vim.cmd('MasonInstall ' .. table.concat(ensure_installed, ' '))
      end
    end, {})
  end,
}
