return {
    event = "VeryLazy",
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    opts = {
        highlight = {
            enable = true,
            disable = {}, -- List of languages that will be disabled
        },
        indent = {
            enable = true,
        },
        autotag = {
            enable = true,
        },
        ensure_installed = {
            "javascript",
            "properties",
            "c",
            "lua",
            "vim",
            "vimdoc",
            "query",
        },
        auto_install = true,
    },
    config = function (_, opts)
        local configs = require("nvim-treesitter.configs")
        configs.setup(opts)
    end
}
