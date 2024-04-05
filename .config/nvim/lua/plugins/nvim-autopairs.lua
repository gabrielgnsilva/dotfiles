--[[
    Automatically add and delete pairs of characters.
]]

return {
    event = 'InsertEnter',

    'windwp/nvim-autopairs',

    opts = {
        check_ts = true, -- Enable treesitter
        ts_config = {
            lua = { 'string' }, -- Don't add pairs in lua string treesiter nodes
            javascript = { 'template_string' },
        },
    },
}
