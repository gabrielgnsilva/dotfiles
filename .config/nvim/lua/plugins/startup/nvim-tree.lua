return {
  'nvim-tree/nvim-tree.lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local nvim_tree = require('nvim-tree')
    local api = require('nvim-tree.api')
    local utils = require('core.utils')

    nvim_tree.setup({
      filters = { dotfiles = false, custom = { '^.git$', '^node_modules$' } },
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = true,
      hijack_unnamed_buffer_when_opening = false,
      sync_root_with_cwd = true,
      update_focused_file = { enable = true, update_root = false },
      view = {
        side = 'right',
        adaptive_size = false,
        width = 40,
        preserve_window_proportions = true,
        relativenumber = true,
      },
      git = { enable = true, ignore = true },
      filesystem_watchers = { enable = true },
      actions = {
        open_file = {
          resize_window = true,
          window_picker = { enable = false },
        },
      },
      renderer = {
        root_folder_label = false,
        highlight_git = true,
        highlight_opened_files = 'none',
        indent_markers = { enable = false },
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
      on_attach = function(bufnr)
        api.config.mappings.default_on_attach(bufnr)
        utils.load_keymaps({
          {
            mode = { 'n' },
            bindings = {
              {
                key = '<C-d>',
                cmd = api.tree.toggle,
                desc = 'Toggle Nvim-tree',
              },
              {
                key = '<C-t>',
                cmd = api.tree.change_root_to_parent,
                desc = 'nvim-tree: Up',
                opts = {
                  buffer = bufnr,
                  noremap = true,
                  silent = true,
                  nowait = true,
                },
              },
              {
                key = '?',
                cmd = api.tree.toggle_help,
                desc = 'nvim-tree: Help',
                opts = {
                  buffer = bufnr,
                  noremap = true,
                  silent = true,
                  nowait = true,
                },
              },
            },
          },
        })
      end,
    })
  end,
}
