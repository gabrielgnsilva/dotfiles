--[[
    Linting.
]]

return {
    event = 'VeryLazy',

    'mfussenegger/nvim-lint',

    opts = {
        files = {
            javascript = { 'eslint_d' },
            python = { 'pylint' },
            bash = { 'shellcheck' },
            sh = { 'shellcheck' },
        },

        linters = {
            shellcheck = {
                args = {
                    '-e', 'SC2312',
                    '-e', 'SC2154',
                    '-e', 'SC1090',
                    '-e', 'SC2016',
                    '--source-path', 'SCRIPTDIR',
                    '--enable', 'all',
                    '--format', 'tty',
                    '--external-sources',
                    '-',
                }
            }
        },
    },

    config = function(_, opts)
        local lint = require('lint')
        lint.linters_by_ft = opts.files

        for linter in pairs(opts.linters) do
            local options = lint.linters[linter]
            options.args = opts.linters[linter].args
        end

        local auGroup = vim.api.nvim_create_augroup('lint', { clear = true })
        vim.api.nvim_create_autocmd(
            { 'bufEnter', 'bufWritePost', 'insertLeave' },
            {
                group = auGroup,
                callback = function()
                    lint.try_lint()
                    -- print(vim.inspect(lint.get_running()))
                end,
            }
        )
    end,
}
