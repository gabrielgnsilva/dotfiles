return {
    event = "InsertEnter",
    "github/copilot.vim",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {},
    config = function()
        vim.g.copilot_filetypes = {
            javascript = true,
            html = true,
            css = true,
            markdown = true,
            lua = true,
        }
    end
}

