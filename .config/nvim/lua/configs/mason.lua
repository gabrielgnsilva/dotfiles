return {
  max_concurrent_installers = 10,
  ui = {
    icons = {
      package_installed = '[x]',
      package_pending = '[...]',
      package_uninstalled = '[ ]',
    },
  },
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
    'sql-formatter', -- SQL Formatter
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
  },
}
