return {
    lazy = false,
    priority = 1000,
    "joshdick/onedark.vim",
    opts = {},
    config = function(_, opts)
        -- require("onedark").setup(opts)
        vim.cmd("colorscheme onedark")

        vim.api.nvim_set_hl(0, "Normal", {bg = "none"})
        vim.api.nvim_set_hl(0, "NormalFloat", {bg = "none"})
    end
}
