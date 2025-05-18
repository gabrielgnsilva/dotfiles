return {
  'Wansmer/treesj',
  keys = { '<Tab>' },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('treesj').setup({
      use_default_keymaps = false,
      dot_repeat = true,
    })

    require('core.utils').load_keymaps({
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
