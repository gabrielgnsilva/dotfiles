return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    columns = { 'icon', 'permissions', 'size' },
    delete_to_trash = true,
    view_options = { show_hidden = true },
    -- float = { border = 'rounded' },
    -- confirmation = { border = 'rounded' },
    -- progress = { border = 'rounded' },
    -- ssh = { border = 'rounded' },
    -- keymaps_help = { border = 'rounded' },
  },
  config = function(_, opts)
    require('oil').setup(opts)
    require('utils.mappings').load_keymap({
      {
        mode = { 'n' },
        bindings = {
          {
            key = '-',
            cmd = '<cmd>Oil<cr>',
            desc = 'Open parent directory',
          },
        },
      },
    })
  end,
}
