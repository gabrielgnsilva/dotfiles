return {
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
  build = ':TSUpdate',
  config = function()
    local notify = vim.notify
    require('nvim-treesitter.configs').setup({
      ensure_installed = {
        'bash',
        'c',
        'c_sharp',
        'cpp',
        'css',
        'csv',
        'dockerfile',
        'gitignore',
        'go',
        'graphql',
        'html',
        'http',
        'hyprlang',
        'java',
        'javascript',
        'jsdoc',
        'json',
        'json5',
        'jsonc',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'php',
        'properties',
        'python',
        'query',
        'readline',
        'regex',
        'rust',
        'scss',
        'sql',
        'tmux',
        'toml',
        'typescript',
        'vim',
        'vimdoc',
        'xcompose',
        'xml',
        'yaml',
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
      auto_install = false,
      textobjects = { enable = true },
      highlight = {
        use_languagetree = true,
        enable = true,
        disable = function(_, buf)
          local maxFileSize = 100 * 1024 -- 100KB
          local ok, stats =
            pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > maxFileSize then
            notify(
              'Treesitter highlighting has been deactivated on this file!'
            )
            return true
          end
        end,
      },
      indent = { enable = true },
      additional_vim_regex_highlighting = false, -- Run `:h syntax` and tree-sitter at the same time
    })
    -- Filetype mapping
    vim.filetype.add({
      extension = {
        info = 'properties',
        ftl = 'html',
      },
      pattern = {
        ['.*/hypr/.*%.conf'] = 'hyprlang',
      },
    })
    vim.treesitter.language.register('html', 'ftl')
    vim.treesitter.language.register('html', 'htmlangular')
    vim.treesitter.language.register('properties', 'info')
  end,
}
