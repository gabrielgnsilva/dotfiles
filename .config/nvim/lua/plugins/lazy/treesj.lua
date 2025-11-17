return {
  'Wansmer/treesj',
  keys = { '<Tab>' },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    local tsj_utils = require('treesj.langs.utils')
    require('treesj').setup({
      langs = {
        -- Merge HTML and TypeScript to support Angular
        angular = tsj_utils.merge_preset(
          require('treesj.langs.html'),
          require('treesj.langs.typescript')
        ),
      },
    })

    require('utils.mappings').load_keymap({
      {
        mode = { 'n' },
        bindings = {
          {
            key = '<Tab>',
            cmd = '<cmd>TSJToggle<cr>',
            desc = 'Toggle block splitting',
          },
        },
      },
    })
  end,
}
