--[[
    Formatter.
]]

return {
    event = 'VeryLazy',

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
            ftl = { 'prettier' }
        },

        formatters = {
            prettier = {
                prepend_args = {
                    '--bracket-same-line', 'true',
                    '--insert-pragma', 'true',
                    '--print-width', '9999',
                    '--single-quote', 'true',
                    '--tab-width', '4',
                },
                options = {
                    lang_to_ext = {
                        ftl = "ftl",
                    },
                    ext_parsers = {
                        ftl = "html"
                    },
                }
            },
            shfmt = {
                prepend_args = {
                    '-i', '4',
                    '-bn',
                    '-ci',
                    '-sr',
                },
            },
        },

        -- format_on_save = {
        --     lsp_fallback = true,
        --     async = false,
        --     timeout_ms = 500,
        -- },
    },

    config = function(_, opts)
        require('conform').setup(opts)
    end,
}
