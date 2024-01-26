return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "linrongbin16/lsp-progress.nvim"
    },

    opts={
        options = {
            theme = "onedark"
        },
        sections = {
            lualine_c = {
                {
                    "filename",
                    file_status = true,     -- File status (Readonly, modified, etc.)
                    newfile_status = false, -- New file status
                    path = 4,               -- 0 (Filename), 1 (Relative), 2 (Absolute), 3 (Absolute, with tilde as homedir), 4 (Filename and parent dir, with tilde as homedir)
                    symbols = {
                        modified = "[+]",
                        readonly = "[-]"
                    }
                }
            },
            lualine_x = {
                {
                    function()
                        local icon = require("lazyvim.config").icons.kinds.Copilot
                        local status = require("copilot.api").status.data
                        return icon .. (status.message or "")
                    end,
                    cond = function()
                        if not package.loaded["copilot"] then
                            return
                        end
                        local ok, clients = pcall(require("lazyvim.util").lsp.get_clients, { name = "copilot", bufnr = 0 })
                        if not ok then
                            return false
                        end
                        return ok and #clients > 0
                    end,
                    color = function()
                        if not package.loaded["copilot"] then
                            return
                        end
                        local status = require("copilot.api").status.data
                        local Util = require("lazyvim.util")
                        local colors = {
                            [""] = Util.ui.fg("Special"),
                            ["Normal"] = Util.ui.fg("Special"),
                            ["Warning"] = Util.ui.fg("DiagnosticError"),
                            ["InProgress"] = Util.ui.fg("DiagnosticWarn"),
                        }
                        return colors[status.status] or colors[""]
                    end
                }
            }
        }
    },
    config = function(_, opts)
        require("lualine").setup(opts)
    end,
}
