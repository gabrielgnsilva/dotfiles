--[[
    Linting.
]]

return {
    event = {
        'BufReadPost', -- Starting to edit an existing file
        'BufNewFile', -- Starting to edit a non-existent file
    },

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
    },

    config = function(_, opts)
        local map = vim.keymap.set
        local lint = require('lint')
        lint.linters_by_ft = opts.files

        for linter in pairs(opts.linters) do
            local options = lint.linters[linter]
            options.args = opts.linters[linter].args
        end

        -- Keymaps
        map('n', '<leader>l', function()
            lint.try_lint()
        end, { desc = 'Trigger linting on current buffer' })
    end,
}
