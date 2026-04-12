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
    local oil = require('oil')
    oil.setup(opts)
    require('utils.mappings').load_keymap({
      {
        mode = { 'n' },
        bindings = {
          {
            key = '-',
            cmd = '<cmd>Oil<cr>',
            desc = 'Open parent directory',
          },
          {
            key = 'yp',
            cmd = function()
              oil.actions.copy_entry_path.callback()
              vim.fn.setreg('+', vim.fn.getreg(vim.v.register))
            end,
            desc = 'Copy filepath to system clipboard',
          },
          {
            key = 'yrp',
            cmd = function()
              local entry = oil.get_cursor_entry()
              local dir = oil.get_current_dir()
              if not entry or not dir then
                return
              end
              local relpath = vim.fn.fnamemodify(dir, ':.')
              vim.fn.setreg('+', relpath .. entry.name)
            end,
          },
        },
      },
    })
  end,
}
