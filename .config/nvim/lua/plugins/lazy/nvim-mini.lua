return {
  {
    'nvim-mini/mini.ai',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = { n_lines = 500 },
  },
  {
    'nvim-mini/mini.align',
    event = { 'BufReadPost', 'BufNewFile' },
    version = '*',
    opts = {},
  },
  {
    'nvim-mini/mini.move',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      mappings = {
        -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
        left = '<S-h>',
        right = '<S-l>',
        down = '<S-j>',
        up = '<S-k>',
        -- Move current line in Normal mode
        line_left = '',
        line_right = '',
        line_down = '',
        line_up = '',
      },
      options = { reindent_linewise = true },
    },
  },
  {
    'nvim-mini/mini.pairs',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      modes = { insert = true, command = true, terminal = false },
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=], -- skip autopair when next character is one of these
      skip_ts = { 'string' }, -- skip autopair when the cursor is inside these treesitter nodes
      skip_unbalanced = true, -- skip autopair when next character is closing pair and there are more closing pairs than opening pairs
      markdown = true, -- better deal with markdown code blocks
    },
  },
  {
    'nvim-mini/mini.surround',
    event = { 'BufReadPost', 'BufNewFile' },
    version = '*',
    opts = {},
  },
}
