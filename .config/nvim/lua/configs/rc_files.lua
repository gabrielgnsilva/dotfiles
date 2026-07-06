local M = {}

function M.get_rcfiles_path(dir)
  return string.format('%s/configs/%s', vim.fn.stdpath('config'), dir)
end

return M
