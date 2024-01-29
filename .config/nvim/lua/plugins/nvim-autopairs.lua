return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
        check_ts = true, -- Enable treesitter
        ts_config = {
            lua = { "string" }, -- Don't add pairs in lua string treesiter nodes
            javascript = { "template_string" },
        }
    }
}
