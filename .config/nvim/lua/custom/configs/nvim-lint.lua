local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local opts = {
    files = {
        bash = { 'shellcheck' },
        c = { 'cpplint' },
        cpp = { 'cpplint' },
        -- html = { 'tidy' },
        javascript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        json = { 'jsonlint' },
        python = { 'ruff' },
        sh = { 'shellcheck' },
        typescript = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
        markdown = { 'markdownlint' },
        lua = { 'luacheck' },
    },

    linters = {
        markdownlint = {
            args = {
                '--stdin',
                '--config',
                vim.fn.stdpath('config') .. '/formatters/markdownlint.jsonc',
            },
        },
        luacheck = {
            args = {
                '--config',
                vim.fn.stdpath('config') .. '/formatters/luacheckrc',
            },
        },
        shellcheck = {
            args = {
                '-e',
                'SC2312',
                '-e',
                'SC2154',
                '-e',
                'SC1090',
                '-e',
                'SC2016',
                '--source-path',
                'SCRIPTDIR',
                '--enable',
                'all',
                '--format',
                'tty',
                '--external-sources',
                '-',
            },
        },
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
