--[[
    Toggle comments in and out of the current line or visual selection.
]]

return {
    event = {
        'BufReadPost', -- Starting to edit an existing file
        'BufNewFile', -- Starting to edit a non-existent file
    },

    'tpope/vim-commentary',

    opts = {},

    config = function(_, opts)
        local map = vim.keymap.set

        map('n', '<C-c>', ':Commentary<cr>', { desc = 'vim-commentary comment line' })
        map('v', '<C-c>', ':Commentary<cr>', { desc = 'vim-commentary comment selection' })
    end,
}
