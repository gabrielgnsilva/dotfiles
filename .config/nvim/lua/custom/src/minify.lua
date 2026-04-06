local M = {}

-- #region Minifiers configuration
---@class Minifier
---@field cmd string Command to execute
---@field args string[] Additional arguments

---@type table<string, Minifier>
M.minifiers = {
  javascript = {
    cmd = 'terser',
    args = {
      '--mangle',
      '--compress',
      '--comments',
      'all',
    },
  },
  typescript = { cmd = 'terser', args = { '--mangle', '--compress' } },
  -- Future: css, html, json...
}

-- Filetypes that map to the same minifier
local filetype_aliases = {
  javascriptreact = 'javascript',
  typescriptreact = 'typescript',
}
-- #endregion

-- #region Helper functions
---@param cmd string
---@return boolean
local function is_cmd_available(cmd)
  return vim.fn.executable(cmd) == 1
end

---@return string
local function get_filetype()
  local ft = vim.bo.filetype
  return filetype_aliases[ft] or ft
end

---@param minifier Minifier
---@param content string
---@return string|nil, string|nil
local function run_minifier(minifier, content)
  local args = table.concat(minifier.args, ' ')
  local cmd = string.format(
    'echo %s | %s %s',
    vim.fn.shellescape(content),
    minifier.cmd,
    args
  )
  local result = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    return nil, result
  end

  return result, nil
end
-- #endregion

-- #region Core functions
---@param start_line number
---@param end_line number
local function minify_range(start_line, end_line)
  local ft = get_filetype()
  local minifier = M.minifiers[ft]

  if not minifier then
    vim.notify(
      string.format('No minifier configured for filetype: %s', ft),
      vim.log.levels.WARN
    )
    return
  end

  if not is_cmd_available(minifier.cmd) then
    vim.notify(
      string.format(
        "'%s' not found. Install it with: npm install -g %s",
        minifier.cmd,
        minifier.cmd
      ),
      vim.log.levels.ERROR
    )
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local content = table.concat(lines, '\n')

  local result, err = run_minifier(minifier, content)

  if err then
    vim.notify(
      string.format('Minification failed:\n%s', err),
      vim.log.levels.ERROR
    )
    return
  end

  -- Remove trailing newline if present
  result = result:gsub('\n$', '')

  -- Replace lines with minified content
  local result_lines = vim.split(result, '\n', { plain = true })
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, result_lines)

  local num_result_lines = #result_lines
  vim.cmd(
    string.format(
      '%d,%dnormal! ==',
      start_line,
      start_line + num_result_lines - 1
    )
  )

  vim.notify('Minified successfully!', vim.log.levels.INFO)
end

---Minify visual selection or entire buffer
function M.minify()
  local start_line = 1
  local end_line = vim.fn.line('$')
  minify_range(start_line, end_line)
end

---Minify a specific range (used by command with range)
---@param opts table Command options with line1 and line2
function M.minify_command(opts)
  if opts.range == 2 then
    minify_range(opts.line1, opts.line2)
  else
    M.minify()
  end
end
-- #endregion

-- #region Setup command and keymaps
vim.api.nvim_create_user_command('Minify', M.minify_command, { range = true })

require('utils.mappings').load_keymap({
  {
    mode = { 'n' },
    bindings = {
      {
        key = '<leader>min',
        cmd = M.minify,
        desc = 'Minify buffer',
      },
    },
  },
  {
    mode = { 'v', 'x' },
    bindings = {
      {
        key = '<leader>min',
        cmd = ":'<,'>Minify<CR>",
        desc = 'Minify selection',
      },
    },
  },
})
-- #endregion

return M
