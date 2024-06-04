local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
local lazy_opts = require('core.lazy_opts')
vim.g.mapleader = ' '

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('core.options')
require('lazy').setup({
    { import = 'plugins' },
}, lazy_opts)
require('core.autocmds')

vim.schedule(function()
    require('core.keymaps')
end)
