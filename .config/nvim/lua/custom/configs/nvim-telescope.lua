local telescope = require('telescope')
local actions = require('telescope.actions')
local theme = require('telescope.themes').get_ivy()

local open_with_trouble = require('trouble.sources.telescope').open

local opts = {
    defaults = vim.tbl_extend('force', theme, {
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
        path_display = { 'smart' },
        prompt_prefix = '   ',
        selection_caret = '  ',
        entry_prefix = '  ',
        initial_mode = 'insert',
        selection_strategy = 'reset',
        file_ignore_patterns = {
            '.git',
            '.github',
            'node_modules',
            'undodir',
        },
        mappings = {
            i = {
                ['qq'] = actions.close,
                ['<C-j>'] = actions.move_selection_next,
                ['<C-k>'] = actions.move_selection_previous,
                ['<C-h>'] = actions.select_default,
                ['<c-t>'] = open_with_trouble,
            },
            n = { ['<c-t>'] = open_with_trouble },
        },
    }),
    extensions = { 'fzf', 'undo', 'noice' },
}

telescope.setup(opts)
for _, extension in ipairs(opts.extensions) do
    telescope.load_extension(extension)
end
