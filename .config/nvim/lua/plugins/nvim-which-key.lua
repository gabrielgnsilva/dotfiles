--[[
    View keybindings in a popup window.
]]

return {
    event = 'VeryLazy',

    'folke/which-key.nvim',

    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 500
    end,
    opts = {},
}
