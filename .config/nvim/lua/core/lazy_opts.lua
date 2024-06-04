return {
    defaults = { lazy = true },
    install = {
        missing = true, -- install missing plugins on startup. This doesn't increase startup time.
        colorscheme = { 'onedark' }, -- try to load one of these colorschemes when starting an installation during startup
    },

    ui = {
        icons = {
            ft = '',
            lazy = '󰂠 ',
            loaded = '',
            not_loaded = '',
        },
    },

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
}
