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
            vimgrep_arguments = {
                'rg',
                '-L',
                '--color=never',
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--column',
                '--smart-case',
            },
            prompt_prefix = '   ',
            selection_caret = '  ',
            entry_prefix = '  ',
            initial_mode = 'insert',
            selection_strategy = 'reset',
            layout_strategy = 'horizontal',
            layout_config = {
                horizontal = {
                    prompt_position = 'bottom',
                },
                vertical = {
                    mirror = false,
                },
            },
            file_ignore_patterns = { 'node_modules', 'undodir' },
            mappings = {
                i = {},
            },
        },
        -- pickers = {
        --     -- find_files = {
        --     --     theme = 'dropdown',
        --     -- },
        -- },
        extensions_list = { 'fzf', 'undo' },
    },

    config = function(_, opts)
        local map = vim.keymap.set
        local actions = require('telescope.actions')
        local builtin = require('telescope.builtin')
        local extensions = require('telescope').extensions
        local telescope = require('telescope')

        opts.defaults.mappings.i = {
            ['qq'] = actions.close,
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-h>'] = actions.select_default,
        }
        telescope.setup(opts)
        for _, extension in ipairs(opts.extensions_list) do
            telescope.load_extension(extension)
        end

        local custom = {
            grep_string = function()
                builtin.grep_string({
                    search = vim.fn.input('Grep > '),
                })
            end,
        }

        map('n', '<leader>fd', builtin.diagnostics, { desc = 'Telescope fuzzy find files on cwd' })
        map('n', '<leader>ff', builtin.find_files, { desc = 'Telescope fuzzy find files on cwd' })
        map('n', '<leader>fg', builtin.git_files, { desc = 'Telescope fuzzy find git files on cwd' })
        map('n', '<leader>fr', builtin.oldfiles, { desc = 'Telescope fuzzy find recend files' })
        map('n', '<leader>fs', builtin.live_grep, { desc = 'Telescope fuzzy find string on worktree' })
        map('n', '<leader>fs', custom.grep_string, { desc = 'Telescope fuzzy find string on worktree' })
        map('n', '<leader>fu', extensions.undo.undo, { desc = 'Telescope fuzzy find undo history on cwd' })
    end,
}
