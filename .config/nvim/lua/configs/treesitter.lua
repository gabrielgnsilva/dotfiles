return {
  ensure_installed = {
    'angular',
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
    'java',
    'javascript',
    'jsdoc',
    'json',
    'json5',
    'latex',
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
  install_dir = vim.fn.stdpath('data') .. '/site',
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<C-space>',
      node_incremental = '<C-space>',
      scope_incremental = false,
      node_decremental = '<bs>',
    },
  },
  auto_install = true,
  textobjects = {
    move = {
      goto_next_start = {
        [']f'] = '@function.outer',
        [']c'] = '@class.outer',
        [']a'] = '@parameter.inner',
      },
      goto_next_end = {
        [']F'] = '@function.outer',
        [']C'] = '@class.outer',
        [']A'] = '@parameter.inner',
      },
      goto_previous_start = {
        ['[f'] = '@function.outer',
        ['[c'] = '@class.outer',
        ['[a'] = '@parameter.inner',
      },
      goto_previous_end = {
        ['[F'] = '@function.outer',
        ['[C'] = '@class.outer',
        ['[A'] = '@parameter.inner',
      },
    },
  },
  folds = { enable = true },
  indent = { enable = true },
  highlight = {
    enable = true,
    use_languagetree = true,
    additional_vim_regex_highlighting = false, -- Run `:h syntax` and tree-sitter at the same time
    disable = function(_, buf)
      -- Disable for large files
      local maxFileSize = 500 * 1024 -- 500KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > maxFileSize then
        vim.notify(
          'Treesitter highlighting has been deactivated on this file!'
        )
        return true
      end

      -- Disable for files with very long lines
      local lines = vim.api.nvim_buf_line_count(buf)
      if lines <= 10 then
        for i = 1, lines do
          local line = vim.api.nvim_buf_get_lines(buf, i - 1, i, false)[1]
            or ''
          if #line > 150 then
            return true
          end
        end
      end
    end,
  },
}
