return {
    event = {
        'BufReadPost', -- Starting to edit an existing file
        'BufNewFile', -- Starting to edit a non-existent file
    },

    'lewis6991/gitsigns.nvim',

    opts = {
        signs = {
            add = { text = '│' },
            change = { text = '│' },
            delete = { text = '󰍵' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
            untracked = { text = '│' },
        },

        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            local map = vim.keymap.set

            local function opts(desc)
                return { buffer = bufnr, desc = desc }
            end

            map('n', '<leader>rh', gs.reset_hunk, opts('Reset Hunk'))
            map('n', '<leader>ph', gs.preview_hunk, opts('Preview Hunk'))
            map('n', '<leader>gb', gs.blame_line, opts('Blame Line'))
        end,
    },

    config = function(_, opts)
        require('gitsigns').setup(opts)
    end,
}
