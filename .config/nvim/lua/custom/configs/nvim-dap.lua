local dap = require('dap')

dap.adapters.debugpy = function(cb, config)
    if config.request == 'attach' then
        local port = (config.connect or config).port
        local host = (config.connect or config).host or '127.0.0.1'
        cb({
            type = 'server',
            port = assert(port, '`connect.port` is required for a python `attach` configuration'),
            host = host,
            options = {
                source_filetype = 'python',
            },
        })
    else
        cb({
            type = 'executable',
            command = os.getenv('VIRTUAL_ENV') .. '/bin/python' or '/bin/python',
            args = { '-m', 'debugpy.adapter' },
            options = {
                source_filetype = 'python',
            },
        })
    end
end

dap.adapters['pwa-node'] = {
    type = 'server',
    host = 'localhost',
    port = '8123',
    executable = {
        command = vim.fn.stdpath('data') .. '/mason/bin/js-debug-adapter',
    },
}

dap.adapters.codelldb = {
    executable = {
        args = { '--port', '${port}' },
        command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
    },
    port = '${port}',
    type = 'server',
}

dap.adapters.delve = {
    executable = {
        args = { 'dap', '-l', '127.0.0.1:${port}' },
        command = vim.fn.stdpath('data') .. '/mason/bin/dlv',
    },
    port = '${port}',
    type = 'server',
}

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
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
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
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
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
