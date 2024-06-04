--[[
    Status bar.
]]

return {
    lazy = false,

    'nvim-lualine/lualine.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        'linrongbin16/lsp-progress.nvim',
    },

    opts = {
        options = {
            theme = 'onedark',
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch' },
            lualine_c = {
                {
                    'filename',
                    file_status = true, -- File status (Readonly, modified, etc.)
                    newfile_status = false, -- New file status
                    path = 4, -- 0 (Filename)
                    -- 1 (Relative)
                    -- 2 (Absolute)
                    -- 3 (Absolute, with tilde as homedir)
                    -- 4 (Filename and parent dir, with tilde as homedir)
                    symbols = {
                        modified = '[+]',
                        readonly = '[-]',
                    },
                },
                {
                    'diagnostics',
                    symbols = {
                        error = '󰅙 ',
                        info = '󰋼 ',
                        hint = '󰌵 ',
                        warn = ' ',
                    },
                },
            },
            lualine_y = {
                {
                    'diff',
                    symbols = {
                        added = ' ',
                        modified = ' ',
                        removed = ' ',
                    },
                    source = function()
                        local gitsigns = vim.b.gitsigns_status_dict
                        if gitsigns then
                            return {
                                added = gitsigns.added,
                                modified = gitsigns.changed,
                                removed = gitsigns.removed,
                            }
                        end
                    end,
                },
                { 'progress', separator = ' ', padding = { left = 1, right = 0 } },
                { 'location', padding = { left = 0, right = 1 } },
            },
            lualine_z = {
                function()
                    return ' ' .. os.date('%R')
                end,
            },
        },
        extensions = { 'mason', 'fzf', 'fugitive', 'nvim-tree', 'lazy' },
    },

    config = function(_, opts)
        require('lualine').setup(opts)
    end,
}
