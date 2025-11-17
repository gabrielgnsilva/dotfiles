local M = {}

M.regex_cheatsheet = function()
  require('custom.src.regex-cheatsheet')
end
M.floaterminal = function()
  require('custom.src.floating-terminal')
end
M.compile = function()
  require('custom.src.compile')
end

M.setupAll = function()
  M.compile()
  M.floaterminal()
  M.regex_cheatsheet()
end

return M
