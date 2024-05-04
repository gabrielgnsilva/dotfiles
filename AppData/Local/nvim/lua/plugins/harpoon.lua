--[[
    Move between files.
]]

return {
    event = 'VeryLazy',

    'ThePrimeagen/harpoon',
    branch = 'harpoon2',

    dependencies = {
        'nvim-lua/plenary.nvim',
    },

    opts = {},

    config = function(_, opts)
        local harpoon = require('harpoon')
        local conf = require('telescope.config').values

        local function toggle_telescope(harpoon_files)
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

        vim.keymap.set('n', '<leader>ah', function()
            harpoon:list():append()
        end, { desc = 'Add file to harpoon' })

        vim.keymap.set('n', '<leader>oh', function()
            toggle_telescope(harpoon:list())
        end, { desc = 'Toggle harpoon menu' })
    end,
}
