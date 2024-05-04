--[[
    Surround text with pairs of characters.
]]

return {
    event = 'VeryLazy',

    'kylechui/nvim-surround',

    opts = {},

    config = function(_, opts)
        require('nvim-surround').setup(opts)
    end,
}
