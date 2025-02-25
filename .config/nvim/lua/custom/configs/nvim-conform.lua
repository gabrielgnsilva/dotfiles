require('conform').setup({
    default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = 'fallback',
    },
    formatters_by_ft = {
        c = { 'clang-format' },
        c_sharp = { 'clang-format' },
        cpp = { 'clang-format' },
        css = { 'prettierd' },
        html = function(bufnr)
            if vim.api.nvim_buf_get_name(bufnr):match('%.ftl$') then
                return { 'prettierftl' }
            else
                return { 'prettierd' }
            end
        end,
        javascript = { 'prettierd' },
        javascriptreact = { 'prettierd' },
        json = { 'prettierd' },
        markdown = { 'prettierd' },
        scss = { 'prettierd' },
        typescript = { 'prettierd' },
        typescriptreact = { 'prettierd' },
        yaml = { 'yamlfmt' },
        go = { 'goimports-reviser', 'golines' },
        lua = { 'stylua' },
        python = { 'black', 'isort' },
        rust = { 'rustfmt' },
        bash = { 'shfmt' },
        sh = { 'shfmt' },
        mysql = { 'sqlfmt' },
        sql = { 'sqlfmt' },
    },
    formatters = {
        injected = { options = { ignore_errors = true } },
        prettier = {
            command = 'prettier',
            prepend_args = { '--config', vim.fn.stdpath('config') .. '/formatters/prettierrc.json' },
            args = { vim.api.nvim_buf_get_name(0) },
        },
        prettierd = {
            command = 'prettierd',
            env = {
                PRETTIERD_DEFAULT_CONFIG = vim.fn.stdpath('config') .. '/formatters/prettierrc.json',
            },
        },
        stylua = {
            prepend_args = {
                '--config-path',
                vim.fn.stdpath('config') .. '/formatters/stylua.toml',
            },
        },
        shfmt = {
            prepend_args = {
                '--indent',
                '4',
                '--binary-next-line',
                '--case-indent',
                '--space-redirects',
            },
        },
    },
})
