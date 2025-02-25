local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        lazyrepo,
        '--branch=stable',
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({ { import = 'custom.plugins' } }, {
    defaults = { lazy = true },
    checker = { enabled = true, nofity = false },
    install = {
        missing = true, -- install missing plugins on startup. This doesn't increase startup time.
        colorscheme = { 'onedark' }, -- try to load one of these colorschemes when starting an installation during startup
    },

    ui = { icons = { ft = '', lazy = '󰂠 ', loaded = '', not_loaded = '' } },

    performance = {
        rtp = {
            disabled_plugins = {
                '2html_plugin',
                'tohtml',
                'getscript',
                'getscriptPlugin',
                'gzip',
                'logipat',
                'netrw',
                'netrwPlugin',
                'netrwSettings',
                'netrwFileHandlers',
                'matchit',
                'tar',
                'tarPlugin',
                'rrhelper',
                'spellfile_plugin',
                'vimball',
                'vimballPlugin',
                'zip',
                'zipPlugin',
                'tutor',
                'rplugin',
                'syntax',
                'synmenu',
                'optwin',
                'compiler',
                'bugreport',
                'ftplugin',
            },
        },
    },

    change_detection = {
        enabled = true, -- Automatically update files change
        notify = false, -- Display a notification when a config file is changed
    },
})
