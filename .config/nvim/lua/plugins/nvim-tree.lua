--[[
    File navigation
]]

return {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },

    opts = {
        git = {
            enable = true,
        },
        renderer = {
            highlight_git = true,
            icons = {
                show = {
                    git = true,
                },
            },
        },
        view = {
            side = 'right',
            width = 40,
        },
        actions = {
            open_file = {
                window_picker = {
                    enable = false,
                },
            },
        },
    },
    config = function(_, opts)
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        require('nvim-tree').setup(opts)
    end,
}
