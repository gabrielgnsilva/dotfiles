local luasnip = require('luasnip')
luasnip.config.set_config({
    history = true,
    updateevents = 'TextChanged,TextChangedI',
    enbable_autosnippets = true,
})

require('luasnip.loaders.from_lua').load()
require('luasnip.loaders.from_lua').lazy_load({
    paths = vim.fn.stdpath('config') .. '/lua/custom/snippets',
})

vim.api.nvim_create_autocmd('InsertLeave', {
    callback = function()
        if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] and not luasnip.session.jump_active then
            luasnip.unlink_current()
        end
    end,
})
