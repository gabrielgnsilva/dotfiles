return {
    event = "InsertEnter",
    "github/copilot.vim",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {},
    config = function()
        vim.g.copilot_filetypes = {
            ["*"] = false,
            javascript = true,
            html = true,
            css = true,
            markdown = true,
            lua = true,
            sh = true,
            bash = true,
        }
    end
}
