return {
    event = 'VeryLazy',

    'folke/todo-comments.nvim',

    dependencies = { 'nvim-lua/plenary.nvim' },

    opts = {
        signs = false,
    },

    config = function(_, opts)
        local map = vim.keymap.set
        local todo_comments = require('todo-comments')
        todo_comments.setup(opts)

        -- Keymaps
        map('n', ']c', function()
            todo_comments.jump_next()
        end, { desc = 'Todo Commetns Next comment' })

        map('n', '[c', function()
            todo_comments.jump_prev()
        end, { desc = 'Todo Comments Previous comment' })
    end,
}
