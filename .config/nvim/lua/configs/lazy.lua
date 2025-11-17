return {
  -- Plugins SPEC - SEE: https://lazy.folke.io/spec
  spec = {
    --[[ Events
      BufNewFile              Starting to edit a non-existent file
      BufReadPre BufReadPost  Before and after editing an existing file
      SEE: https://neovim.io/doc/user/autocmd.html#autocmd-events
      VeryLazy  You can use this event for things that can load later
                and are not important for the initial UI
    ]]
    { 'nvim-lua/plenary.nvim', import = 'plugins.startup', lazy = false },
    { 'nvim-lua/plenary.nvim', import = 'plugins.lazy', lazy = true },
  },
  defaults = { version = false }, -- Always use the latest git commit
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  },
  change_detection = {
    enabled = true, -- Automatically update files change
    notify = false, -- Display a notification when a config file is changed
  },
  install = {
    missing = true, -- install missing plugins on startup. This doesn't increase startup time.
    colorscheme = { 'rose-pine' }, -- try to load one of these colorschemes when starting an installation during startup
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
        'bugreport',
        'compiler',
        'ftplugin',
        'getscript',
        'getscriptPlugin',
        'gzip',
        'logipat',
        'matchit',
        'matchparen',
        'netrw',
        'netrwFileHandlers',
        'netrwPlugin',
        'netrwSettings',
        'optwin',
        'rplugin',
        'rrhelper',
        'spellfile_plugin',
        'synmenu',
        'syntax',
        'tar',
        'tarPlugin',
        'tohtml',
        'tutor',
        'vimball',
        'vimballPlugin',
        'zip',
        'zipPlugin',
      },
    },
  },
}
