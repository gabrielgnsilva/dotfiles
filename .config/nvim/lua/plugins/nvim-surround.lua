--[[
    Surround text with pairs of characters.
]]

return {
    event = {
        'BufReadPost', -- Starting to edit an existing file
        'BufNewFile', -- Starting to edit a non-existent file
    },

    'kylechui/nvim-surround',

    opts = {
        keymaps = {
            insert = '<C-g>s',
            insert_line = '<C-g>S',
            normal = 'ys',
            normal_cur = 'yss',
            normal_line = 'yS',
            normal_cur_line = 'ySS',
            visual = 'S',
            visual_line = 'gS',
            delete = 'ds',
            change = 'cs',
            change_line = 'cS',
        },
    },

    config = function(_, opts)
        require('nvim-surround').setup(opts)
    end,
}
