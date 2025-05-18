return {
  'zbirenbaum/copilot.lua',
  event = 'InsertEnter',
  build = ':Copilot auth',
  config = function()
    local function toggle_copilot(state)
      if state then
        vim.cmd([[:Copilot enable]])
        vim.notify('Copilot is now enabled')
      else
        vim.cmd([[:Copilot disable]])
        vim.notify('Copilot is now disabled')
      end
    end

    require('copilot').setup({
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = '[[',
          jump_next = ']]',
          accept = '<CR>',
          refresh = 'gr',
          open = '<M-CR>',
        },
        layout = {
          position = 'top',
          ratio = 0.4,
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = false,
        hide_during_completion = true,
        debounce = 75,
        keymap = {
          accept = '<M-l>',
          accept_word = false,
          accept_line = false,
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-]>',
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ['.'] = false,
      },
      copilot_node_command = 'node',
      server_opts_overrides = {},
    })

    require('core.utils').load_keymaps({
      {
        mode = { 'n' },
        bindings = {
          {
            key = '<leader>cpd',
            cmd = function()
              toggle_copilot(false)
            end,
            desc = 'Disable Copilot',
            opts = { silent = true },
          },
          {
            key = '<leader>cpe',
            cmd = function()
              toggle_copilot(true)
            end,
            desc = 'Enable Copilot',
            opts = { silent = true },
          },
        },
      },
    })
  end,
}
