--[[
    Move between files.

]]

return {
    event = {
        'BufReadPost', -- Starting to edit an existing file
        'BufNewFile', -- Starting to edit a non-existent file
    },

    'ThePrimeagen/harpoon',
    branch = 'harpoon2',

    dependencies = {
        'nvim-lua/plenary.nvim',
    },

    opts = {},

    config = function(_, opts)
        local harpoon = require('harpoon')

        local function toggle_telescope(harpoon_files)
            local conf = require('telescope.config').values

            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
            end

            require('telescope.pickers')
                .new({}, {
                    prompt_title = 'Harpoon',
                    finder = require('telescope.finders').new_table({
                        results = file_paths,
                    }),
                    previewer = conf.file_previewer({}),
                    sorter = conf.generic_sorter({}),
                })
                :find()
        end

        harpoon:setup()

        vim.keymap.set('n', '<C-e>', function()
            toggle_telescope(harpoon:list())
        end, { desc = 'Harpoon toggle harpoon menu' })

        vim.keymap.set('n', '<leader>ah', function()
            harpoon:list():add()
        end, { desc = 'Harpoon add file to harpoon' })

        vim.keymap.set('n', '<leader>rh', function()
            harpoon:list():remove()
        end, { desc = 'Harpoon remove file to harpoon' })

        vim.keymap.set('n', '<leader>nh', function()
            harpoon:list():next()
        end, { desc = 'Harpoon select next harpoon file' })

        vim.keymap.set('n', '<leader>ph', function()
            harpoon:list():prev()
        end, { desc = 'Harpoon select prev harpoon file' })
    end,
}
