--[[
    Fzf and UI for nvim.
]]

return {
    event = 'VeryLazy',

    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'debugloop/telescope-undo.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },

    opts = {
        defaults = {
            layout_config = {
                vertical = {
                    width = 0.75,
                },
            },
            mappings = {
                i = {},
            },
            file_ignore_patterns = {
                'undodir',
            },
        },
    },
    config = function(_, opts)
        local actions = require('telescope.actions')

        opts.defaults.mappings.i = {
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-h>'] = actions.select_default,
        }

        require('telescope').setup(opts)
        require('telescope').load_extension('fzf')
        require('telescope').load_extension('undo')
    end,
}
