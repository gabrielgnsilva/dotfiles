--[[
    Formatter.
]]

return {
    event = {
        'BufReadPost', -- Starting to edit an existing file
        'BufNewFile', -- Starting to edit a non-existent file
    },

    'stevearc/conform.nvim',

    opts = {
        formatters_by_ft = {
            bash = { 'shfmt' },
            css = { 'prettier' },
            html = { 'prettier' },
            javascript = { 'prettier' },
            lua = { 'stylua' },
            markdown = { 'prettier' },
            python = { 'isort', 'black' },
            sh = { 'shfmt' },
            ftl = { 'prettier' },
            typescript = { 'prettier' },
        },

        formatters = {
            prettier = {
                -- stylua: ignore
                prepend_args = {
                    '--bracket-same-line', 'true',
                    '--insert-pragma', 'true',
                    '--print-width', '9999',
                    '--single-quote', 'true',
                    '--tab-width', '4',
                },
                options = {
                    lang_to_ext = {
                        ftl = 'ftl',
                    },
                    ext_parsers = {
                        ftl = 'html',
                    },
                },
            },
            shfmt = {
                -- stylua: ignore
                prepend_args = {
                    '-i', '4',
                    '-bn',
                    '-ci',
                    '-sr',
                },
            },
        },
    },

    config = function(_, opts)
        local conform = require('conform')
        local map = vim.keymap.set
        conform.setup(opts)

        map({ 'n', 'v', 'x' }, '<leader>mp', function()
            conform.format()
        end, { desc = 'Conform format current buffer' })
    end,
}
