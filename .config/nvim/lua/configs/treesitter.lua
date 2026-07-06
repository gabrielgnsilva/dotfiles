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
    'svelte',
    'tmux',
    'toml',
    'tsx',
    'typescript',
    'typst',
    'vim',
    'vimdoc',
    'vue',
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
        [']o'] = '@class.outer',
        [']a'] = '@parameter.inner',
      },
      goto_next_end = {
        [']F'] = '@function.outer',
        [']O'] = '@class.outer',
        [']A'] = '@parameter.inner',
      },
      goto_previous_start = {
        ['[f'] = '@function.outer',
        ['[o'] = '@class.outer',
        ['[a'] = '@parameter.inner',
      },
      goto_previous_end = {
        ['[F'] = '@function.outer',
        ['[O'] = '@class.outer',
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
      local BF = require('bigfile_detection')

      if BF.is_detection_disabled(buf) then
        return false
      end

      local reason = BF.reason(buf)
      if reason == 'snacks_bigfile' then
        return true
      end

      if reason == 'large_file' then
        vim.notify('Treesitter highlighting has been deactivated on this file!')
        return true
      end

      if reason == 'long_lines' then
        vim.notify(
          'Treesitter highlighting disabled: long lines detected',
          vim.log.levels.WARN
        )
        return true
      end
    end,
  },
}
