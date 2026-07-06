local M = {}
local config = require('bigfile_detection.config')
local detector = require('bigfile_detection.detector')

local running_ft_resolve = false

---@param value any
---@param fallback table
---@return table
local function ensure_table(value, fallback)
  if type(value) == 'table' then
    return value
  end
  return vim.deepcopy(fallback)
end

M.config = {
  thresholds = {
    max_file_size = 500 * 1024,
    max_line_length = 500,
    line_sample = 5,
  },
  integration = {
    snacks_bigfile = false,
  },
  rules = {
    snacks_bigfile = {
      lint = true,
      lsp = true,
      treesitter = true,
      statusline = true,
    },
    long_lines = {
      lint = true,
      lsp = true,
      treesitter = true,
      statusline = false,
    },
    large_file = {
      lint = false,
      lsp = false,
      treesitter = true,
      statusline = false,
    },
  },
  long_lines_mode = {
    disable_lsp = true,
    syntax = 'off',
    filetype = '',
    wrap = false,
    relativenumber = false,
    cursorline = false,
    cursorcolumn = false,
    swapfile = false,
    undofile = false,
    undolevels = -1,
    foldenable = false,
    foldmethod = 'manual',
    bufhidden = 'unload',
    snacks_indent = false,
    disable_matchparen = true,
  },
}

local function apply_runtime_config(opts)
  M.opts = opts
  M.config = vim.tbl_deep_extend('force', M.config, {
    thresholds = opts.thresholds,
    integration = {
      snacks_bigfile = opts.snacks.bigfile == true,
    },
    rules = opts.rules,
    long_lines_mode = opts.long_lines_mode,
  })
end

local function get_opts(opts)
  local defaults = config.defaults()

  opts = opts or {}
  opts.snacks = ensure_table(opts.snacks, defaults.snacks)
  opts.thresholds = ensure_table(opts.thresholds, defaults.thresholds)
  opts.rules = ensure_table(opts.rules, defaults.rules)
  opts.long_lines_mode =
    ensure_table(opts.long_lines_mode, defaults.long_lines_mode)
  opts.filetype_override =
    ensure_table(opts.filetype_override, defaults.filetype_override)
  opts.hooks = ensure_table(opts.hooks, defaults.hooks)
  opts.restore = ensure_table(opts.restore, defaults.restore)
  opts.notifications = ensure_table(opts.notifications, defaults.notifications)

  return vim.tbl_deep_extend('force', defaults, opts)
end

local function maybe_notify(notification)
  local notifications = M.opts.notifications or {}
  if notifications.enabled == false or not notification then
    return
  end
  vim.notify(notification.message, notification.level)
end

---@param buf? number
---@return boolean
function M.is_disabled(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  return vim.g.bigfile_detection_disabled == true
    or vim.b[buf].bigfile_detection_disabled == true
end

---@param buf? number
---@return number
function M.normalize_buf(buf)
  return buf or vim.api.nvim_get_current_buf()
end

---@param buf? number
---@return boolean
function M.is_detection_disabled(buf)
  buf = M.normalize_buf(buf)
  return vim.g.bigfile_detection_disabled == true
    or vim.b[buf].bigfile_detection_disabled == true
end

---@param buf? number
---@return boolean
function M.is_snacks_bigfile(buf)
  buf = M.normalize_buf(buf)
  if M.config.integration.snacks_bigfile ~= true then
    return false
  end
  return vim.bo[buf].filetype == 'bigfile'
end

---@param buf number
---@param max_length? number
---@param max_lines? number
---@return boolean
function M.has_long_lines(buf, max_length, max_lines)
  return detector.has_long_lines(buf, M.config, max_length, max_lines)
end

---@param buf? number
---@param max_file_size? number
---@return boolean
function M.is_large_file(buf, max_file_size)
  return detector.is_large_file(buf, M.config, max_file_size)
end

---@param buf? number
---@return 'snacks_bigfile'|'long_lines'|'large_file'|nil
function M.reason(buf)
  buf = M.normalize_buf(buf)

  if M.is_snacks_bigfile(buf) then
    return 'snacks_bigfile'
  end

  if M.is_detection_disabled(buf) then
    return nil
  end

  if vim.b[buf].bigfile_reason ~= nil then
    return vim.b[buf].bigfile_reason
  end

  return detector.reason(buf, M.config)
end

---@param buf? number
---@return boolean
function M.is_heavy(buf)
  return M.reason(buf) ~= nil
end

---@param feature 'lint'|'lsp'|'treesitter'|'statusline'
---@param buf? number
---@return boolean
function M.should_disable(feature, buf)
  return detector.should_disable(feature, buf, M.config)
end

---@param buf? number
---@param reason 'long_lines'|'large_file'|'snacks_bigfile'
function M.set_reason(buf, reason)
  buf = M.normalize_buf(buf)
  vim.b[buf].bigfile_reason = reason
end

---@param buf? number
function M.clear_runtime_flags(buf)
  buf = M.normalize_buf(buf)
  vim.b[buf].bigfile_reason = nil
  vim.b[buf].disable_lsp = nil
  vim.b[buf].snacks_indent = nil
  vim.b[buf].completion = nil
  vim.b[buf].minianimate_disable = nil
  vim.b[buf].minihipatterns_disable = nil
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
    if M.opts.restore.notify_on_unresolved_filetype ~= false then
      maybe_notify(M.opts.notifications.unresolved_filetype)
    end
    return
  end

  M.clear_runtime_flags(buf)

  if M.opts.restore.restore_filetype ~= false then
    vim.bo[buf].filetype = ft
  end
  if M.opts.restore.restore_syntax ~= false then
    vim.bo[buf].syntax = ft
  end

  if
    M.opts.restore.restart_lsp ~= false and vim.fn.exists(':LspStart') ~= 0
  then
    pcall(function()
      vim.cmd('LspStart')
    end)
  end
end

local function setup_filetype_override()
  if M.opts.filetype_override.enabled == false then
    return
  end

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

          if
            M.opts.filetype_override.skip_special_buftypes ~= false
            and vim.bo[buf].buftype ~= ''
          then
            return nil
          end

          local ft = resolve_filetype_from_path(buf)
          if ft == nil or ft == '' or ft == 'bigfile' then
            return nil
          end

          return ft
        end,
        { priority = M.opts.filetype_override.priority },
      },
    },
  })
end

local function setup_autocmds()
  local group = vim.api.nvim_create_augroup('BigfileDetection', { clear = true })

  if M.opts.hooks.long_lines ~= false then
    vim.api.nvim_create_autocmd('BufReadPost', {
      group = group,
      desc = 'Disable heavy features for files with very long lines',
      callback = function(event)
        local buf = event.buf
        if M.is_detection_disabled(buf) then
          return
        end
        if M.reason(buf) ~= 'long_lines' then
          return
        end
        M.notify_long_lines()
        M.apply_long_lines_mode(buf)
      end,
    })
  end

  if M.opts.hooks.lsp_attach ~= false then
    vim.api.nvim_create_autocmd('LspAttach', {
      group = group,
      desc = 'Prevent LSP from attaching to heavy buffers',
      callback = function(args)
        local buf = args.buf
        if not M.should_disable('lsp', buf) then
          return
        end
        local client_id = args.data.client_id
        vim.schedule(function()
          pcall(vim.lsp.buf_detach_client, buf, client_id)
        end)
      end,
    })
  end
end

---@param buf number
---@return number
local function target_window_for_buf(buf)
  local windows = vim.fn.win_findbuf(buf)

  for _, win in ipairs(windows) do
    if vim.api.nvim_win_is_valid(win) then
      return win
    end
  end

  return vim.api.nvim_get_current_win()
end

function M.setup(opts)
  if M._initialized then
    return
  end
  M._initialized = true

  apply_runtime_config(get_opts(opts))

  setup_filetype_override()
  setup_autocmds()
end

function M.disable()
  vim.g.bigfile_detection_disabled = true
  M.restore_buffer(vim.api.nvim_get_current_buf())
  maybe_notify(M.opts.notifications.disabled)
end

function M.enable()
  vim.g.bigfile_detection_disabled = false
  maybe_notify(M.opts.notifications.enabled_detection)
end

function M.toggle()
  vim.g.bigfile_detection_disabled = not (vim.g.bigfile_detection_disabled == true)
  if vim.g.bigfile_detection_disabled == true then
    M.restore_buffer(vim.api.nvim_get_current_buf())
    maybe_notify(M.opts.notifications.disabled)
    return
  end

  maybe_notify(M.opts.notifications.enabled_detection)
end

function M.restore_current_buffer()
  M.restore_buffer(vim.api.nvim_get_current_buf())
end

function M.notify_long_lines()
  maybe_notify(M.opts.notifications.long_lines)
end

---@param buf? number
function M.apply_long_lines_mode(buf)
  buf = M.normalize_buf(buf)
  M.set_reason(buf, 'long_lines')

  local config = M.config.long_lines_mode
  local win = target_window_for_buf(buf)

  if config.disable_lsp then
    vim.b[buf].disable_lsp = true
  end
  vim.bo[buf].syntax = config.syntax
  vim.bo[buf].filetype = config.filetype
  vim.api.nvim_set_option_value('wrap', config.wrap, { win = win })
  vim.api.nvim_set_option_value('relativenumber', config.relativenumber, { win = win })
  vim.api.nvim_set_option_value('cursorline', config.cursorline, { win = win })
  vim.api.nvim_set_option_value('cursorcolumn', config.cursorcolumn, { win = win })
  vim.bo[buf].swapfile = config.swapfile
  vim.bo[buf].undofile = config.undofile
  vim.bo[buf].undolevels = config.undolevels
  vim.api.nvim_set_option_value('foldenable', config.foldenable, { win = win })
  vim.api.nvim_set_option_value('foldmethod', config.foldmethod, { win = win })
  vim.bo[buf].bufhidden = config.bufhidden
  vim.b[buf].snacks_indent = config.snacks_indent

  if config.disable_matchparen and vim.fn.exists(':NoMatchParen') ~= 0 then
    vim.cmd('NoMatchParen')
  end
end

apply_runtime_config(get_opts())

return M
