local M = {}

---Verifica se o buffer tem linhas muito longas
---@param buf number Buffer handle
---@param max_length? number Limite de caracteres por linha (default 500)
---@param max_lines? number Quantas linhas verificar (default 5)
---@return boolean
function M.has_long_lines(buf, max_length, max_lines)
  max_length = max_length or 500
  max_lines = max_lines or 5

  local line_count = vim.api.nvim_buf_line_count(buf)
  local lines_to_check = math.min(line_count, max_lines)

  for i = 1, lines_to_check do
    local line = vim.api.nvim_buf_get_lines(buf, i - 1, i, false)[1] or ''
    if #line > max_length then
      return true
    end
  end

  return false
end

return M
