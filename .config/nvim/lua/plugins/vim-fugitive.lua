--[[
    Add git support.
]]

return {
    event = 'VeryLazy',

    'tpope/vim-fugitive',

    config = function()
        vim.keymap.set('n', '<leader>gs', vim.cmd.Git, {})
    end,
}
