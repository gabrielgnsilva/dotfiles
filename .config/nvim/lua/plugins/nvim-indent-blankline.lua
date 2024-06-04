--[[
    Indent guides.
]]

return {
    event = {
        'BufReadPost', -- Starting to edit an existing file
        'BufNewFile', -- Starting to edit a non-existent file
    },

    'lukas-reineke/indent-blankline.nvim',

    main = 'ibl',

    opts = {},

    config = function(_, opts)
        local hooks = require('ibl.hooks')
        hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
        require('ibl').setup(opts)
    end,
}
