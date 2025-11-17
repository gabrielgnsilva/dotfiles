return {
  'rcarriga/nvim-dap-ui',
  ft = { 'javascript', 'python', 'typescript', 'rust', 'go', 'cpp' },
  dependencies = {
    'nvim-neotest/nvim-nio',
    {
      'mfussenegger/nvim-dap',
      dependencies = { 'mason-org/mason.nvim' },
      opts = function()
        return require('configs.nvim-dap')
      end,
      config = function(_, opts)
        local dap = require('dap')
        for adapter, config in pairs(opts.adapters) do
          dap.adapters[adapter] = config
        end
        for lang, config in pairs(opts.configurations) do
          dap.configurations[lang] = config
        end

        local DAP = require('utils.nvim-dap')
        DAP.get_installed(true) -- Caches all installed langs
        require('utils').create_autocmd('nvim-dap', 'FileType', {
          desc = 'Enables nvim-dap keymaps',
          callback = function(args)
            local lang = DAP.lang(args.match)

            if not DAP.have(lang) then
              return
            end

            require('utils.mappings').load_keymap({
              {
                mode = { 'n' },
                bindings = {
                  {
                    key = '<M-q>',
                    cmd = function()
                      require('dap').terminate()
                      require('dap').close()
                      require('dapui').close()
                    end,
                    { desc = 'Quit debugger', buffer = args.buf },
                  },
                  {
                    key = '<M-r>',
                    cmd = '<cmd>DapNew<cr>',
                    { desc = 'Run debugger', buffer = args.buf },
                  },
                  {
                    key = '<M-c>',
                    cmd = '<cmd>DapContinue<cr>',
                    {
                      desc = 'Run or continue the debugger',
                      buffer = args.buf,
                    },
                  },
                  {
                    key = '<M-p>',
                    cmd = '<cmd>DapPause<cr>',
                    { desc = 'Pause the debugger', buffer = args.buf },
                  },
                  {
                    key = '<M-b>',
                    cmd = '<cmd>DapToggleBreakpoint<cr>',
                    {
                      desc = 'Add breakpoint to the current line',
                      buffer = args.buf,
                    },
                  },
                  {
                    key = '<M-B>',
                    cmd = '<cmd>DapClearBreakpoints<cr>',
                    { desc = 'Clear breakpoints', buffer = args.buf },
                  },
                  {
                    key = '<M-i>',
                    cmd = '<cmd>DapStepInto<cr>',
                    { desc = 'Step in', buffer = args.buf },
                  },
                  {
                    key = '<M-o>',
                    cmd = '<cmd>DapStepOver<cr>',
                    { desc = 'Step over', buffer = args.buf },
                  },
                  {
                    key = '<M-O>',
                    cmd = '<cmd>DapStepOut<cr>',
                    { desc = 'Step out', buffer = args.buf },
                  },
                },
              },
            })
          end,
        })
      end,
    },
  },
  config = function()
    local dap = require('dap')
    local dapUi = require('dapui')
    dapUi.setup()
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapUi.open()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapUi.close()
    end
  end,
}
