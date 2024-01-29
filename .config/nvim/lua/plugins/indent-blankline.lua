return {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    main = "ibl",
    opts = {
        -- enabled = true,
        -- indent = {
        --     char = "|"
        -- }
    },
    config = function(_, opts)
        require("ibl").setup(opts)
    end
}
