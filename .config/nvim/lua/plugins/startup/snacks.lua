return {
  'folke/snacks.nvim',
  priority = 1000,
  config = function()
    local snacks = require('snacks')
    local utils = require('core.utils')

    snacks.setup({
      explorer = { enabled = false },
      picker = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },
      notifier = { enabled = false },
      bigfile = { enabled = true },
      input = { enabled = true },
      quickfile = { enabled = true },
      indent = { enabled = true },
      terminal = { win = { style = 'terminal' } },
      image = { enabled = false },
      animate = {
        duration = 20,
        easing = 'linear',
        fps = 60,
      },
      dashboard = {
        enabled = true,
        preset = {
          header = [[
 ██████╗ ███╗   ██╗███████╗
██╔════╝ ████╗  ██║██╔════╝
██║  ███╗██╔██╗ ██║███████╗
██║   ██║██║╚██╗██║╚════██║
╚██████╔╝██║ ╚████║███████║
 ╚═════╝ ╚═╝  ╚═══╝╚══════╝]],
          keys = {
            {
              icon = ' ',
              key = 'e',
              desc = '> New File',
              action = ':ene | startinsert',
            },
            {
              icon = '󰈞 ',
              key = 'f',
              desc = '> Find File',
              action = ':cd $HOME | Telescope find_files<CR>',
            },
            {
              icon = ' ',
              key = 's',
              desc = '> Config',
              action = ':e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd',
            },
            {
              icon = '󰒲 ',
              key = 'L',
              desc = '> Lazy',
              action = ':Lazy',
              enabled = package.loaded.lazy ~= nil,
            },
            { icon = '󰈆 ', key = 'q', desc = '> Quit', action = ':qa' },
          },
        },
        sections = {
          { section = 'header' },
          { section = 'keys', padding = 1, gap = 1 },
          {
            section = 'recent_files',
            icon = ' ',
            title = '> Recent Files',
            indent = 3,
            padding = 2,
          },
          { section = 'startup' },
        },
      },
    })

    utils.load_keymaps({
      {
        mode = { 'n' },
        bindings = {
          {
            key = '<leader>bd',
            cmd = snacks.bufdelete.other,
          },
          {
            key = '<leader>ba',
            cmd = snacks.bufdelete.all,
          },
          {
            key = '<leader>bo',
            cmd = snacks.bufdelete.other,
          },
          {
            key = '<leader>gb',
            cmd = snacks.git.blame_line,
            desc = 'Toggle Git Blame',
          },
          -- {
          --   key = '<leader>st',
          --   cmd = snacks.terminal.toggle,
          --   desc = 'Open small terminal node',
          -- },
        },
      },
    })
  end,
}
