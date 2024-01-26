return {
    event = "VeryLazy",

    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "debugloop/telescope-undo.nvim"
    },

    opts = {
        extensions = {
            undo = {
            },
        },
        defaults = {
            layout_config = {
                vertical = {
                    width = 0.75
                }
            }
        }
    },
    config = function(_, opts)
        require("telescope").setup(opts)
        require("telescope").load_extension("undo")
    end
}
