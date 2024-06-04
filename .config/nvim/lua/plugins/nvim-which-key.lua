--[[
    View keybindings in a popup window.
]]

return {
    event = 'VeryLazy',

    'folke/which-key.nvim',

    keys = {
        "'",
        '"',
        '`',
        'c',
        'g',
        'v',
        '<c-w>',
        '<c-r>',
        '<leader>',
    },

    cmd = 'WhichKey',

    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 500
    end,
    opts = {},

    config = function(_, opts)
        require('which-key').setup(opts)
    end,
}
