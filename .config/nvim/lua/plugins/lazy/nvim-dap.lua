return {
  'mfussenegger/nvim-dap',
  ft = { 'javascript', 'python', 'typescript', 'rust', 'go', 'cpp' },
  dependencies = { 'williamboman/mason.nvim' },
  config = function()
    local dap = require('dap')

    local files = vim.fn.globpath(
      vim.fn.stdpath('config')
        .. '/lua/plugins/lazy/configs/nvim-dap/adapters/',
      '*.lua',
      false,
      true
    )
    for _, file in ipairs(files) do
      local name = vim.fn.fnamemodify(file, ':t:r')
      local adapter =
        require('plugins.lazy.configs.nvim-dap.adapters.' .. name)
      dap.adapters[adapter.name] = adapter.config
    end

    dap.configurations.typescript = {
      {
        type = 'pwd-node',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        cwd = '${workspaceFolder}',
        runtimeExecutable = 'node',
      },
    }

    dap.configurations.javascript = {
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        cwd = '${workspaceFolder}',
        runtimeExecutable = 'node',
      },
    }

    dap.configurations.rust = {
      {
        type = 'codelldb',
        request = 'launch',
        name = 'Debug using codelldb',
        program = function()
          return vim.fn.input(
            'Path to executable: ',
            vim.fn.getcwd() .. '/',
            'file'
          )
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        runInTerminal = false,
      },
    }

    dap.configurations.cpp = {
      {
        type = 'codelldb',
        request = 'launch',
        name = 'Debug using codelldb',
        program = function()
          return vim.fn.input(
            'Path to executable: ',
            vim.fn.getcwd() .. '/',
            'file'
          )
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        runInTerminal = false,
      },
    }

    dap.configurations.go = {
      {
        type = 'delve',
        name = 'Debug',
        request = 'launch',
        showLog = false,
        program = '${file}',
        dlvToolPath = vim.fn.stdpath('data') .. '/mason/bin/dlv',
      },
    }

    dap.configurations.python = {
      {
        type = 'debugpy',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        pythonPath = function()
          local cwd = vim.fn.getcwd()
          if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
            return cwd .. '/venv/bin/python'
          elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
            return cwd .. '/.venv/bin/python'
          else
            return '/usr/bin/python'
          end
        end,
      },
      {
        type = 'debugpy',
        request = 'launch',
        name = 'Launch file with arguments',
        program = '${file}',
        pythonPath = function()
          local cwd = vim.fn.getcwd()
          if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
            return cwd .. '/venv/bin/python'
          elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
            return cwd .. '/.venv/bin/python'
          else
            return '/usr/bin/python'
          end
        end,
      },
    }

    require('core.utils').load_keymaps({
      {
        mode = { 'n' },
        bindings = {
          {
            key = '<M-q>',
            cmd = '<cmd>DapDisconnect<cr>',
            desc = 'Pause the debugger',
          },
          {
            key = '<M-r>',
            cmd = '<cmd>DapNew<cr>',
            desc = 'Run debugger',
          },
          {
            key = '<M-c>',
            cmd = '<cmd>DapContinue<cr>',
            desc = 'Run or continue the debugger',
          },
          {
            key = '<M-p>',
            cmd = '<cmd>DapPause<cr>',
            desc = 'Pause the debugger',
          },
          {
            key = '<M-b>',
            cmd = '<cmd>DapToggleBreakpoint<cr>',
            desc = 'Add breakpoint to the current line',
          },
          {
            key = '<M-B>',
            cmd = '<cmd>DapClearBreakpoints<cr>',
            desc = 'Clear breakpoints',
          },
          {
            key = '<M-i>',
            cmd = '<cmd>DapStepInto<cr>',
            desc = 'Step in',
          },
          {
            key = '<M-o>',
            cmd = '<cmd>DapStepOver<cr>',
            desc = 'Step over',
          },
          {
            key = '<M-O>',
            cmd = '<cmd>DapStepOut<cr>',
            desc = 'Step out',
          },
        },
      },
    })
  end,
}
