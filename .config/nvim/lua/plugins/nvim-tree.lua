--[[
    File navigation
]]

return {
    lazy = false,

    'nvim-tree/nvim-tree.lua',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },

    opts = {
        filters = {
            dotfiles = false,
            custom = { '^.git$' },
        },

        disable_netrw = true,
        hijack_netrw = true,
        hijack_cursor = true,
        hijack_unnamed_buffer_when_opening = false,
        sync_root_with_cwd = true,

        update_focused_file = {
            enable = true,
            update_root = false,
        },

        view = {
            side = 'right',
            adaptive_size = false,
            width = 40,
            preserve_window_proportions = true,
        },

        git = {
            enable = true,
            ignore = true,
        },

        filesystem_watchers = {
            enable = true,
        },

        actions = {
            open_file = {
                resize_window = true,
                window_picker = {
                    enable = false,
                },
            },
        },

        renderer = {
            root_folder_label = false,
            highlight_git = true,
            highlight_opened_files = 'none',

            indent_markers = {
                enable = false,
            },

            icons = {
                show = {
                    file = true,
                    folder = true,
                    folder_arrow = true,
                    git = true,
                },

                glyphs = {
                    git = {
                        unstaged = '✗',
                        staged = '✓',
                        unmerged = '',
                        renamed = '➜',
                        untracked = '★',
                        deleted = '',
                        ignored = '◌',
                    },
                },
            },
        },
    },

    config = function(_, opts)
        local function on_attach(bufnr)
            local map = vim.keymap.set
            local api = require('nvim-tree.api')
            local function make_desc(desc)
                return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end

            api.config.mappings.default_on_attach(bufnr)

            map('n', '<C-d>', api.tree.toggle, { desc = 'Toggle Nvim-tree' })
            map('n', '<C-t>', api.tree.change_root_to_parent, make_desc('Up'))
            map('n', '?', api.tree.toggle_help, make_desc('Help'))
        end

        opts.on_attach = on_attach
        require('nvim-tree').setup(opts)
    end,
}
