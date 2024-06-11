local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
local lazy_opts = require('core.lazy_opts')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', lazyrepo, '--branch=stable', lazypath })
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
