--[[
    Show git-blame directly inline.
]]

return {
    event = {
        'BufReadPost', -- Starting to edit an existing file
        'BufNewFile', -- Starting to edit a non-existent file
    },

    'f-person/git-blame.nvim',

    opts = {
        enable = false, -- Enable only on keymap
        date_format = '%d/%m/%y %H:%M:%S',
    },

    config = function(_, opts)
        local gitblame = require('gitblame')
        local map = vim.keymap.set

        map('n', '<leader>gb', function()
            gitblame.toggle()
        end, { desc = 'GIT Blame toggle' })
    end,
}
