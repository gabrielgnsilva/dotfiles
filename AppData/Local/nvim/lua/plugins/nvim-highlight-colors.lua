--[[
    Show colors directly on editor.
]]

return {
    event = 'VeryLazy',

    'brenoprata10/nvim-highlight-colors',

    opts = {},

    config = function(_, opts)
        require('nvim-highlight-colors').setup(opts)
        vim.cmd('HighlightColors On')
    end,
}
