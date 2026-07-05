local M = {}

local default_config = {
  snacks = {
    bigfile = false,
  },
  thresholds = {
    max_file_size = 500 * 1024,
    max_line_length = 500,
    line_sample = 5,
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
  filetype_override = {
    enabled = true,
    priority = 100,
    skip_special_buftypes = true,
  },
  hooks = {
    long_lines = true,
    lsp_attach = true,
  },
  restore = {
    restart_lsp = true,
    restore_syntax = true,
    restore_filetype = true,
    notify_on_unresolved_filetype = true,
  },
  notifications = {
    enabled = true,
    long_lines = {
      level = vim.log.levels.WARN,
      message = 'Long lines detected, disabling heavy features',
    },
    disabled = {
      level = vim.log.levels.INFO,
      message = 'Bigfile detection disabled',
    },
    enabled_detection = {
      level = vim.log.levels.INFO,
      message = 'Bigfile detection enabled',
    },
    unresolved_filetype = {
      level = vim.log.levels.WARN,
      message = 'Could not resolve filetype for buffer',
    },
  },
}

local function clone_defaults()
  return vim.deepcopy(default_config)
end

local function validate_positive_number(path, value)
  if type(value) ~= 'number' or value <= 0 then
    error(string.format('bigfile-detection: %s must be > 0', path))
  end
end

local function validate_boolean(path, value)
  if type(value) ~= 'boolean' then
    error(string.format('bigfile-detection: %s must be a boolean', path))
  end
end

local function validate(config)
  validate_positive_number('thresholds.max_file_size', config.thresholds.max_file_size)
  validate_positive_number('thresholds.max_line_length', config.thresholds.max_line_length)
  validate_positive_number('thresholds.line_sample', config.thresholds.line_sample)
  validate_boolean('notifications.enabled', config.notifications.enabled)

  return config
end

function M.defaults()
  return clone_defaults()
end

function M.merge(opts)
  local merged = vim.tbl_deep_extend('force', clone_defaults(), opts or {})
  return validate(merged)
end

return M
