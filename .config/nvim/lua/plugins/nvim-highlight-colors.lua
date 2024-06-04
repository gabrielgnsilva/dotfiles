--[[
    Show colors directly on editor.
]]

return {
    event = {
        'BufReadPost', -- Starting to edit an existing file
        'BufNewFile', -- Starting to edit a non-existent file
    },

    'brenoprata10/nvim-highlight-colors',

    opts = {},

    config = function(_, opts)
        require('nvim-highlight-colors').setup(opts)
        vim.cmd('HighlightColors On')
    end,
}
