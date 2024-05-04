local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

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

vim.g.mapleader = ' '

local opts = {
    change_detection = {
        enabled = true, -- Automatically update files change
        notify = false, -- Display a notification when a config file is changed
    },
}

require('lazy').setup('plugins', opts)
require('core.options')
require('core.keymaps')
