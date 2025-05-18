return {
  'echasnovski/mini.pairs',
  event = { 'VeryLazy' },
  config = function()
    require('mini.pairs').setup({
      modes = { insert = true, command = true, terminal = false },
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=], -- skip autopair when next character is one of these
      skip_ts = { 'string' }, -- skip autopair when the cursor is inside these treesitter nodes
      skip_unbalanced = true, -- skip autopair when next character is closing pair and there are more closing pairs than opening pairs
      markdown = true, -- better deal with markdown code blocks
    })
  end,
}
