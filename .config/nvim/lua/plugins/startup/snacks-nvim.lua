return {
  'folke/snacks.nvim',
  priority = 1000,
  opts = {
    explorer = { enabled = false },
    image = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
    bigfile = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    picker = {
      focus = 'input',
      matcher = { frecency = true },
      ui_select = true,
      preset = 'ivy',
      layout = {
        position = 'bottom',
        cycle = true,
        preset = function()
          return vim.o.columns >= 120 and 'ivy' or 'vertical'
        end,
      },
    },
    quickfile = { exclude = {} },
    zen = {
      toggles = { dim = false },
      backdrop = { transparent = true },
      win = {
        height = 0,
        width = 0.8,
        col = 0.4,
      },
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
          -- stylua: ignore start
          { icon = ' ', key = 'e', desc = '> New File',  action = ':ene | startinsert' },
          { icon = '󰈞 ', key = 'f', desc = '> Find File', action = function() require('snacks').picker.files() end },
          { icon = ' ', key = 's', desc = '> Config',    action = ':e $MYVIMRC | :cd %:p:h | pwd' },
          { icon = ' ', key = 'p', desc = '> Zoxisde',   action = function() require('snacks').picker.zoxide() end },
          { icon = '󰒲 ', key = 'L', desc = '> Lazy',      action = ':Lazy', enabled = package.loaded.lazy ~= nil },
          { icon = '󰈆 ', key = 'q', desc = '> Quit',      action = ':qa' },
          -- stylua: ignore end
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
  },
  config = function(_, opts)
    local snacks = require('snacks')
    snacks.setup(opts)

    vim.notify = snacks.notifier

    vim.api.nvim_set_option_value(
      'statuscolumn',
      [[%!v:lua.require'snacks.statuscolumn'.get()]],
      { scope = 'global' }
    )

    require('utils.mappings').load_keymap({
      {
        mode = { 'n' },
        bindings = {
          -- stylua: ignore start
          -- buf
          { key = '<leader>ba', cmd = snacks.bufdelete.all,             desc = 'Delete all buffers' },
          { key = '<leader>bd', cmd = snacks.bufdelete.delete,          desc = 'Delete current buffer' },
          { key = '<leader>bo', cmd = snacks.bufdelete.other,           desc = 'Delete all buffers except the current one (focused)' },
          -- git
          { key = '<leader>fg', cmd = snacks.picker.git_files,          desc = 'Fuzzy find git files on cwd' },
          -- diagnostics
          { key = '<leader>fD', cmd = snacks.picker.diagnostics,        desc = 'Fuzzy find diagnostics on cwd' },
          { key = '<leader>fd', cmd = snacks.picker.diagnostics_buffer, desc = 'Fuzzy find diagnostics on current buffer' },
          -- navigation
          { key = '<c-d>',      cmd = snacks.picker.explorer,           desc = 'Open file explorer' },
          { key = '<leader>f/', cmd = snacks.picker.lines,              desc = 'Fuzzy find string on current buffer' },
          { key = '<leader>fb', cmd = snacks.picker.buffers,            desc = 'Fuzzy find curenltly open buffers' },
          { key = '<leader>fd', cmd = snacks.picker.zoxide,             desc = 'Fuzzy find zoxide entries' },
          { key = '<leader>ff', cmd = snacks.picker.files,              desc = 'Fuzzy find files on cwd' },
          { key = '<leader>fm', cmd = snacks.picker.marks,              desc = 'Fuzzy find marks' },
          { key = '<leader>fp', cmd = snacks.picker.projects,           desc = 'Fuzzy find projects' },
          { key = '<leader>fr', cmd = snacks.picker.recent,             desc = 'Fuzzy find recent files' },
          { key = '<leader>fw', cmd = snacks.picker.grep,               desc = 'Fuzzy find string on cwd' },
          -- misc
          { key = '<leader>fH', cmd = snacks.picker.highlights,         desc = 'Fuzzy find highlights' },
          { key = '<leader>fM', cmd = snacks.picker.man,                desc = 'Fuzzy find man pages' },
          { key = '<leader>fW', cmd = snacks.picker.spelling,           desc = 'Fuzzy find spelling suggestions for the word under cursor' },
          { key = '<leader>fh', cmd = snacks.picker.help,               desc = 'Fuzzy find help tags' },
          { key = '<leader>fi', cmd = snacks.picker.icons,              desc = 'Fuzzy find icons' },
          { key = '<leader>fk', cmd = snacks.picker.keymaps,            desc = 'Fuzzy find keymaps' },
          { key = '<leader>fn', cmd = snacks.picker.notifications,      desc = 'Fuzzy find notification messages' },
          { key = '<leader>fu', cmd = snacks.picker.undo,               desc = 'Fuzzy find undo history' },
          { key = '<leader>fc', cmd = snacks.picker.pickers,            desc = 'Fuzzy find all available pickers' },
          { key = '<leader>z',  cmd = function () snacks.zen() end,     desc = 'Toggle Zen mode' },
          -- stylua: ignore end
        },
      },
    })

    local TS = require('utils.treesitter')
    TS.get_installed(true) -- Caches all installed langs
    require('utils').create_autocmd('snacks:treesitter', 'FileType', {
      desc = 'Enables Snacks symbols picker if treesitter textobjects are available',
      callback = function(args)
        local lang = TS.lang(args.match)
        if not TS.have(lang, 'textobjects') then
          return
        end

        require('utils.mappings').load_keymap({
          {
            mode = { 'n' },
            bindings = {
              {
                key = '<leader>fs',
                cmd = snacks.picker.treesitter,
                {
                  desc = 'Fuzzy find symbols on current buffer (using treesitter)',
                  buffer = args.buf,
                },
              },
              {
                key = '<leader>fS',
                cmd = snacks.picker.lsp_workspace_symbols,
                {
                  desc = 'LSP fuzzy find symbols on current workspace',
                  buffer = args.buf,
                },
              },
            },
          },
        })
      end,
    })
  end,
}
