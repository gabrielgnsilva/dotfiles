local lazy_status = require('lazy.status')
-- +-------------------------------------------------+
-- | A | B | C                             X | Y | Z |
-- +-------------------------------------------------+

require('lualine').setup({
    options = {
        icons_enabled = true,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
        refresh = {
            statusline = 1000,
        },
    },

    sections = {
        lualine_a = {
            { 'mode' },
        },
        lualine_b = {
            'branch',
            {
                'diff',
                symbols = {
                    added = '󰐗 ',
                    modified = '󰛿 ',
                    removed = '󰍶 ',
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
            {
                'filename',
                path = 0,
                file_status = true,
                newfile_status = false,
                symbols = {
                    modified = '',
                    readonly = '[R]',
                    unnamed = '[NO NAME]',
                    newfile = '[NEW]',
                },
            },
        },
        lualine_c = {
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
        lualine_x = {
            {
                require('lazy.status').updates,
                cond = require('lazy.status').has_updates,
                color = { fg = '#ff9e64' },
            },
            {
                require('noice').api.status.command.get,
                cond = require('noice').api.status.command.has,
                color = { fg = '#64aaff' },
            },
            {
                require('noice').api.status.mode.get,
                cond = require('noice').api.status.mode.has,
                color = { fg = '#64aaff' },
            },
            {
                require('noice').api.status.search.get,
                cond = require('noice').api.status.search.has,
                color = { fg = '#64aaff' },
            },
        },
        lualine_y = {
            {
                require('custom.configs.lualine-components').lint_status,
            },
            {
                'location',
                separator = '',
                padding = { left = 1, right = 1 },
            },
            {
                'progress',
                separator = '',
                padding = { left = 1, right = 1 },
            },
        },
        lualine_z = {
            function()
                return '󰅐 ' .. os.date('%R')
            end,
        },
    },
    extensions = { 'mason', 'man', 'nvim-dap-ui', 'quickfix', 'trouble', 'fzf', 'fugitive', 'nvim-tree', 'lazy' },
})
