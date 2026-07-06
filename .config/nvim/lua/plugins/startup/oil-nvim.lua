--[[ INFO:
  Lazy loading is not recommended because it is very tricky to make it work
  correctly in all situations.
]]

return {
  'stevearc/oil.nvim',
  priority = 1000,
  opts = {
    columns = { 'permissions', 'size' },
    delete_to_trash = true,
    view_options = { show_hidden = true },
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
              local entry = oil.get_cursor_entry()
              local dir = oil.get_current_dir()
              if not entry or not dir then
                return
              end
              local abspath = vim.fn.fnamemodify(dir, ':p') .. entry.name
              vim.fn.setreg('+', abspath)
              vim.notify(
                'Copied absolute path to clipboard:\n' .. abspath,
                vim.log.levels.INFO,
                { title = 'Oil' }
              )
            end,
            desc = 'Copy absolute path to system clipboard',
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
              vim.notify(
                'Copied relative path to clipboard:\n' .. relpath .. entry.name,
                vim.log.levels.INFO,
                { title = 'Oil' }
              )
            end,
            desc = 'Copy relative path to system clipboard',
          },
        },
      },
    })
  end,
}
