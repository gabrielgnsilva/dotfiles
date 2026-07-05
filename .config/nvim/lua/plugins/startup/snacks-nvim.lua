--[[ INFO:
  A couple of plugins require `snacks.nvim` to be set-up early.
  Setup creates some autocmds and does not load any plugins.
]]

return {
  'folke/snacks.nvim',
  priority = 1000,
  dependencies = { 'stevearc/oil.nvim' },
  opts = {
    dashboard = { enabled = false },
    explorer = { enabled = false },
    lazygit = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = false },
    words = { enabled = false },
    image = {
      enabled = true,
    },
    statuscolumn = {
      refresh = 1000, -- ms
    },
    bigfile = {
      enabled = true,
      notify = true,
      size = 1 * 1024 * 1024, -- 1 MB
      line_length = 500,
    },
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
  },
  config = function(_, opts)
    local oil = require('oil')
    local snacks = require('snacks')
    snacks.setup(opts)

    vim.notify = snacks.notifier

    local cwd = function(callback, source)
      local current_dir = oil.get_current_dir()
      if current_dir ~= nil then
        return function()
          callback({ [source] = current_dir })
        end
      end
      return function()
        callback()
      end
    end

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
          { key = '<leader>f/', cmd = snacks.picker.lines,              desc = 'Fuzzy find string on current buffer' },
          { key = '<leader>fb', cmd = snacks.picker.buffers,            desc = 'Fuzzy find currently open buffers' },
          { key = '<leader>fz', cmd = snacks.picker.zoxide,             desc = 'Fuzzy find zoxide entries' },
          { key = '<leader>ff', cmd = cwd(snacks.picker.files, 'dirs'), desc = 'Fuzzy find files on cwd' },
          { key = '<leader>fm', cmd = snacks.picker.marks,              desc = 'Fuzzy find marks' },
          { key = '<leader>fp', cmd = snacks.picker.projects,           desc = 'Fuzzy find projects' },
          { key = '<leader>fr', cmd = snacks.picker.recent,             desc = 'Fuzzy find recent files' },
          { key = '<leader>fw', cmd = cwd(snacks.picker.grep, 'dirs'),  desc = 'Fuzzy find string on cwd' },
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
                desc = 'Fuzzy find symbols on current buffer (using treesitter)',
                opts = { buffer = args.buf },
              },
              {
                key = '<leader>fS',
                cmd = snacks.picker.lsp_workspace_symbols,
                desc = 'LSP fuzzy find symbols on current workspace',
                opts = { buffer = args.buf },
              },
            },
          },
        })
      end,
    })
  end,
}
