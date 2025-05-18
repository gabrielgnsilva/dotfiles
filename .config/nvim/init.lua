require('core.options')
require('core.autocmds')
require('core.lazy')

vim.schedule(function()
  require('core.utils').load_keymaps('global')
  require('custom')
end)
