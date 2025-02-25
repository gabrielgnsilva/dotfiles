local dap = require('dap')
local dapUi = require('dapui')

dapUi.setup()

dap.listeners.after.event_initialized['dapui_config'] = function()
    dapUi.open()
end

dap.listeners.before.event_terminated['dapui_config'] = function()
    dapUi.close()
end

dap.listeners.before.event_exited['dapui_config'] = function()
    dapUi.close()
end
