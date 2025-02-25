local ensure_installed = {
    'black', -- Python Formatter
    'debugpy', -- Python Debugger
    'isort', -- Python Formatter
    'clang-format', -- Clang Formatter
    'codelldb', -- Rust, Clang.. Debugger
    'cpplint', --C/C++ Linter
    'delve', -- Go Debugger
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
    -- '', -- HTML Linter
    'markdownlint', -- Markdown Linter
    'jsonlint', -- JSON Linter
    'rustfmt', -- RUST Linter
    'shellcheck', -- Shell script linter
    'shfmt', -- Shell script formatter
    'js-debug-adapter', -- JS Debugger adapter
    'eslint_d', -- Various languages linter
    'prettierd', -- Various languages Formatter
    'prettier', -- Various languages Formatter (Fallback for Conform)
    'yamlfmt', -- YAML Formatter
    'yamllint', -- YAML Linter
}

require('mason').setup({
    ui = {
        icons = {
            package_uninstalled = '',
            package_installed = '',
            package_pending = '',
        },
    },
})

vim.api.nvim_create_user_command('MasonInstallAll', function()
    if #ensure_installed > 0 then
        vim.cmd('MasonInstall ' .. table.concat(ensure_installed, ' '))
    end
end, {})
