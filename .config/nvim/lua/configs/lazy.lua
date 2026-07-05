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
    { 'nvim-lua/plenary.nvim', lazy = false, priority = 1001 }, -- Used by many plugins, so load it first
    { import = 'plugins.startup', lazy = false, priority = 1000 }, -- Load startup plugins immediately
    { import = 'plugins.lazy', event = 'VeryLazy', priority = 50 }, -- Load the rest of the plugins on the VeryLazy event
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
    colorscheme = { 'catppuccin-mocha' }, -- try to load one of these colorschemes when starting an installation during startup
  },
  ui = {
    border = vim.g.border_style or 'rounded',
    -- stylua: ignore start
    icons = {
      cmd        = '[cmd]',
      config     = '[cfg]',
      debug      = '[dbg]',
      event      = '[event]',
      favorite   = '[fav]',
      ft         = '[ft]',
      init       = '[init]',
      import     = '[import]',
      keys       = '[keys]',
      lazy       = '[lazy]',
      loaded     = '[x]',
      not_loaded = '[ ]',
      plugin     = '[plugin]',
      runtime    = '[rt]',
      require    = '[req]',
      source     = '[src]',
      start      = '[start]',
      task       = '[task]',
      list       = {
        '-',
        '>',
        '*',
        '~',
      },
    },
    -- stylua: ignore end
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
