return {
    event = "InsertEnter",
    "github/copilot.vim",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
        suggestion = {
            enabled = false,
        },
        panel = {
            enabled = false,
        },
        filetypes = {
            javascript = true,
            html = true,
            css = true,
            markdown = true,
            lua = true,
        }
    }
}

