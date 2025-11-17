return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  dependencies = {
    {
      'nvim-treesitter/nvim-treesitter-textobjects',
      branch = 'main',
      opts = { move = { set_jumps = true } },
    },
    { 'nvim-treesitter/nvim-treesitter-context', opts = { max_lines = 3 } },
  },
  build = ':TSUpdate',
  cmd = { 'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo' },
  opts = function()
    return require('configs.treesitter')
  end,
  config = function(_, opts)
    local TS = require('nvim-treesitter')
    local TSUtils = require('utils.treesitter')

    TS.setup(opts)
    TSUtils.get_installed(true) -- Caches all installed langs

    -- install missing parsers
    local install = vim.tbl_filter(function(lang)
      return not TSUtils.have(lang)
    end, opts.ensure_installed or {})
    if #install > 0 then
      vim.notify(
        'Installing treesitter parsers: ' .. table.concat(install, ', ')
      )
      TS.install(install, { summary = true }):await(function()
        TSUtils.get_installed(true) -- refresh the installed langs
        TSUtils.start_treesitter()
      end)
      return
    end
    TSUtils.start_treesitter()
  end,
}
