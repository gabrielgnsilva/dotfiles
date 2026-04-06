local M = {}

local running_ft_resolve = false

---@param buf? number
---@return boolean
function M.is_disabled(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  return vim.g.bigfile_detection_disabled == true
    or vim.b[buf].bigfile_detection_disabled == true
end

---@param buf number
---@return string|nil
local function resolve_filetype_from_path(buf)
  local path = vim.api.nvim_buf_get_name(buf)
  if path == nil or path == '' then
    return nil
  end

  if running_ft_resolve then
    return nil
  end

  running_ft_resolve = true
  local ok, ft = pcall(vim.filetype.match, { filename = path })
  running_ft_resolve = false

  if not ok then
    return nil
  end

  return ft
end

---@param buf number
function M.restore_buffer(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  local ft = resolve_filetype_from_path(buf)
  if ft == nil or ft == '' or ft == 'bigfile' then
    vim.notify('Could not resolve filetype for buffer', vim.log.levels.WARN)
    return
  end

  vim.b[buf].disable_lsp = nil
  vim.b[buf].snacks_indent = nil
  vim.b[buf].completion = nil
  vim.b[buf].minianimate_disable = nil
  vim.b[buf].minihipatterns_disable = nil

  vim.bo[buf].filetype = ft
  vim.bo[buf].syntax = ft

  if vim.fn.exists(':LspStart') ~= 0 then
    pcall(vim.cmd, 'LspStart')
  end
end

local function setup_filetype_override()
  vim.filetype.add({
    pattern = {
      ['.*'] = {
        function(path, buf)
          if not path or not buf then
            return nil
          end

          if not M.is_disabled(buf) then
            return nil
          end

          if vim.bo[buf].buftype ~= '' then
            return nil
          end

          local ft = resolve_filetype_from_path(buf)
          if ft == nil or ft == '' or ft == 'bigfile' then
            return nil
          end

          return ft
        end,
        { priority = 100 },
      },
    },
  })
end

local function setup_commands()
  vim.api.nvim_create_user_command('BigfileDisable', function()
    vim.g.bigfile_detection_disabled = true
    M.restore_buffer(vim.api.nvim_get_current_buf())
    vim.notify('Bigfile detection disabled', vim.log.levels.INFO)
  end, { desc = 'Disable bigfile detection' })

  vim.api.nvim_create_user_command('BigfileEnable', function()
    vim.g.bigfile_detection_disabled = false
    vim.notify('Bigfile detection enabled', vim.log.levels.INFO)
  end, { desc = 'Enable bigfile detection' })

  vim.api.nvim_create_user_command('BigfileToggle', function()
    vim.g.bigfile_detection_disabled = not (vim.g.bigfile_detection_disabled == true)
    if vim.g.bigfile_detection_disabled == true then
      M.restore_buffer(vim.api.nvim_get_current_buf())
      vim.notify('Bigfile detection disabled', vim.log.levels.INFO)
      return
    end
    vim.notify('Bigfile detection enabled', vim.log.levels.INFO)
  end, { desc = 'Toggle bigfile detection' })

  vim.api.nvim_create_user_command('BigfileRestore', function()
    M.restore_buffer(vim.api.nvim_get_current_buf())
  end, { desc = 'Restore current buffer after bigfile detection' })
end

setup_filetype_override()
setup_commands()

return M
