--[[
    Theme.
]]

return {
    lazy = false,
    priority = 1000,

    'joshdick/onedark.vim',

    opts = {},

    config = function(_, opts)
        vim.cmd('colorscheme onedark')

        vim.api.nvim_set_hl(0, 'Normal', { bg = '#000b1e' })
        vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#000b1e' })
    end,
}
