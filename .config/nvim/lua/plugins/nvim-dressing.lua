--[[
    New window for inputs.
]]

return {
    event = 'VeryLazy',

    'stevearc/dressing.nvim',

    opts = {},

    config = function(_, opts)
        require('dressing').setup(opts)
    end,
}
