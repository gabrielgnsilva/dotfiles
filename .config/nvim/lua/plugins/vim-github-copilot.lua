--[[
    Add copilot support.
]]

return {
    event = 'InsertEnter',

    'github/copilot.vim',

    cmd = 'Copilot',

    build = ':Copilot auth',

    opts = {},

    config = function()
        vim.g.copilot_filetypes = {
            ['*'] = false,
            bash = true,
            css = true,
            html = true,
            javascript = true,
            lua = true,
            markdown = true,
            sh = true,
        }
    end,
}
