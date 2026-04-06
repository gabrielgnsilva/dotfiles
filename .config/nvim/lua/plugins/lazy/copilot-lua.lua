return {
  'zbirenbaum/copilot.lua',
  enabled = true,
  build = ':Copilot auth',
  event = 'InsertEnter',
  cmd = 'Copilot',
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = false,
      keymap = { accept = false, next = false, prev = false },
    },
    panel = { enabled = false },
    filetypes = { markdown = true, help = false },
  },
  config = function(_, opts)
    require('copilot').setup(opts)
    require('utils.mappings').load_keymap({
      {
        mode = { 'n' },
        bindings = {
          {
            key = '<leader>ai',
            cmd = function()
              vim.b.copilot_suggestion_hidden =
                not vim.b.copilot_suggestion_hidden
              local status = vim.b.copilot_suggestion_hidden and 'disabled'
                or 'enabled'
              vim.notify('Copilot is ' .. status, vim.log.levels.INFO)
            end,
            desc = 'Toggle Copilot',
          },
        },
      },
      {
        mode = { 'i' },
        bindings = {
          {
            key = '<c-a>',
            cmd = function()
              if require('copilot.suggestion').is_visible() then
                require('copilot.suggestion').accept()
                return
              end
              return '<c-a>'
            end,
            desc = 'Accept Copilot suggestion',
          },
          {
            key = '<M-]>',
            cmd = function()
              if require('copilot.suggestion').is_visible() then
                require('copilot.suggestion').next()
              end
            end,
            desc = 'Next Copilot suggestion',
          },
          {
            key = '<M-[>',
            cmd = function()
              if require('copilot.suggestion').is_visible() then
                require('copilot.suggestion').prev()
              end
            end,
            desc = 'Prev Copilot suggestion',
          },
          {
            key = '<c-x>',
            cmd = function()
              if require('copilot.suggestion').is_visible() then
                require('copilot.suggestion').dismiss()
                return
              end
              return '<c-x>'
            end,
            desc = 'Dismiss Copilot suggestion',
          },
        },
      },
    })
  end,
}
