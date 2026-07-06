local M = {}

function M.create_install_all_cmd()
  local config = require('configs.mason')
  vim.api.nvim_create_user_command('MasonInstallAll', function()
    if #config.ensure_installed > 0 then
      vim.cmd('MasonInstall ' .. table.concat(config.ensure_installed, ' '))
    end
  end, {})
end

return M
