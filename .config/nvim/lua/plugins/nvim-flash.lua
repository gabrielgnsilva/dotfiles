return {
    event = {
        'BufReadPost', -- Starting to edit an existing file
        'BufNewFile', -- Starting to edit a non-existent file
    },

    'folke/flash.nvim',

    opts = {},

    keys = function()
        local flash = require('flash')

        return {
            { '<leader>/', mode = { 'n', 'x', 'o' }, flash.jump, desc = 'Flash' },
            -- { 'S', mode = { 'n', 'x', 'o' }, flash.treesitter, desc = 'Flash Treesitter' },
            -- { 'r', mode = 'o', flash.remote, desc = 'Remote Flash' },
            -- { 'R', mode = { 'o', 'x' }, flash.treesitter_search, desc = 'Treesitter Search' },
            -- { '<c-s>', mode = { 'c' }, flash.toggle, desc = 'Toggle Flash Search' },
        }
    end,
}
