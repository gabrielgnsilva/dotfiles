--[[
    Toggle split/join blocks of code.
]]

return {
    event = {
        'BufReadPost', -- Starting to edit an existing file
        'BufNewFile', -- Starting to edit a non-existent file
    },

    'Wansmer/treesj',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
    },

    keys = { '<leader>m', '<leader>j', '<leader>s' },

    opts = {
        use_default_keymaps = false,
        dot_repeat = true,
    },

    config = function(_, opts)
        local map = vim.keymap.set
        local treesj = require('treesj')
        treesj.setup(opts)

        map('n', '<Tab>', '<cmd>TSJToggle<cr>', { desc = 'TreeSJ toggle block splitting' })
    end,
}
