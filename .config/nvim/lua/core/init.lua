require('core.options')
require('core.lazy')
require('core.autocmds')

vim.schedule(function()
    require('core.keymaps')
end)
