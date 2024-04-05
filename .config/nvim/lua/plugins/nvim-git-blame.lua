--[[
    Show git-blame directly inline.
]]

return {
    event = 'VeryLazy',

    'f-person/git-blame.nvim',

    opts = {
        enable = false, -- Enable only on keymap
        date_format = '%d/%m/%y %H:%M:%S',
    },
}
