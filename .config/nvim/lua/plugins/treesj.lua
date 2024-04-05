--[[
    Toggle split/join blocks of code.
]]

return {
    event = 'VeryLazy',

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
        require('treesj').setup(opts)
    end,
}
