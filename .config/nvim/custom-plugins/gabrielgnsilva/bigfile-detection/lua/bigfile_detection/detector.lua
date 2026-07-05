local M = {}

local function normalize_buf(buf)
  return buf or vim.api.nvim_get_current_buf()
end

function M.has_long_lines(buf, config, max_length, max_lines)
  buf = normalize_buf(buf)
  local thresholds = config.thresholds or {}
  max_length = max_length or thresholds.max_line_length
  max_lines = max_lines or thresholds.line_sample

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

function M.is_large_file(buf, config, max_file_size)
  buf = normalize_buf(buf)
  local thresholds = config.thresholds or {}
  max_file_size = max_file_size or thresholds.max_file_size

  local path = vim.api.nvim_buf_get_name(buf)
  if path == '' then
    return false
  end

  local ok, stats = pcall((vim.uv or vim.loop).fs_stat, path)
  return ok and stats and stats.size > max_file_size or false
end

function M.reason(buf, config)
  buf = normalize_buf(buf)

  if config.integration and config.integration.snacks_bigfile == true and vim.bo[buf].filetype == 'bigfile' then
    return 'snacks_bigfile'
  end

  if M.is_large_file(buf, config) then
    return 'large_file'
  end

  if M.has_long_lines(buf, config) then
    return 'long_lines'
  end

  return nil
end

function M.should_disable(feature, buf, config)
  local reason = M.reason(buf, config)
  if reason == nil then
    return false
  end

  return config.rules[reason] and config.rules[reason][feature] or false
end

return M
