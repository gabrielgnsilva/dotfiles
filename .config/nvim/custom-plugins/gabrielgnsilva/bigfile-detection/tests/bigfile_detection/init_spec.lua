describe('bigfile_detection', function()
  local original_create_user_command
  local original_create_autocmd
  local original_create_augroup
  local original_filetype_add
  local original_get_current_buf
  local original_buf_is_valid
  local original_buf_get_name
  local original_exists
  local original_cmd
  local original_notify
  local original_set_option_value
  local original_win_findbuf
  local original_get_current_win
  local original_win_is_valid

  before_each(function()
    package.loaded['bigfile_detection'] = nil

    original_create_user_command = vim.api.nvim_create_user_command
    original_create_autocmd = vim.api.nvim_create_autocmd
    original_create_augroup = vim.api.nvim_create_augroup
    original_filetype_add = vim.filetype.add
    original_get_current_buf = vim.api.nvim_get_current_buf
    original_buf_is_valid = vim.api.nvim_buf_is_valid
    original_buf_get_name = vim.api.nvim_buf_get_name
    original_exists = vim.fn.exists
    original_cmd = vim.cmd
    original_notify = vim.notify
    original_set_option_value = vim.api.nvim_set_option_value
    original_win_findbuf = vim.fn.win_findbuf
    original_get_current_win = vim.api.nvim_get_current_win
    original_win_is_valid = vim.api.nvim_win_is_valid
  end)

  after_each(function()
    vim.api.nvim_create_user_command = original_create_user_command
    vim.api.nvim_create_autocmd = original_create_autocmd
    vim.api.nvim_create_augroup = original_create_augroup
    vim.filetype.add = original_filetype_add
    vim.api.nvim_get_current_buf = original_get_current_buf
    vim.api.nvim_buf_is_valid = original_buf_is_valid
    vim.api.nvim_buf_get_name = original_buf_get_name
    vim.fn.exists = original_exists
    vim.cmd = original_cmd
    vim.notify = original_notify
    vim.api.nvim_set_option_value = original_set_option_value
    vim.fn.win_findbuf = original_win_findbuf
    vim.api.nvim_get_current_win = original_get_current_win
    vim.api.nvim_win_is_valid = original_win_is_valid
  end)

  it('merges user setup and registers commands and autocmds', function()
    local plugin = require('bigfile_detection')
    local autocmds = {}
    local filetype_config

    vim.api.nvim_create_autocmd = function(event)
      table.insert(autocmds, event)
    end
    vim.api.nvim_create_augroup = function()
      return 1
    end
    vim.filetype.add = function(config)
      filetype_config = config
    end

    plugin.setup({
      thresholds = {
        max_file_size = 1024,
      },
      snacks = {
        bigfile = true,
      },
    })

    assert.are.equal(1024, plugin.opts.thresholds.max_file_size)
    assert.is_true(plugin.config.integration.snacks_bigfile)
    assert.are.same({ 'BufReadPost', 'LspAttach' }, autocmds)
    assert.is_truthy(filetype_config.pattern['.*'])
  end)

  it('restores the buffer filetype, syntax, and lsp when possible', function()
    local plugin = require('bigfile_detection')

    vim.api.nvim_create_user_command = function() end
    vim.api.nvim_create_autocmd = function() end
    vim.api.nvim_create_augroup = function()
      return 1
    end
    vim.filetype.add = function() end

    plugin.setup({})

    vim.api.nvim_buf_is_valid = function()
      return true
    end
    vim.api.nvim_buf_get_name = function()
      return '/tmp/example.lua'
    end
    vim.fn.exists = function(name)
      return name == ':LspStart' and 1 or 0
    end

    local started_lsp = false
    vim.cmd = function(command)
      if command == 'LspStart' then
        started_lsp = true
      end
    end

    plugin.set_reason(1, 'long_lines')
    vim.b[1].disable_lsp = true
    vim.bo[1].filetype = 'bigfile'
    vim.bo[1].syntax = 'off'

    plugin.restore_buffer(1)

    assert.are.equal('lua', vim.bo[1].filetype)
    assert.are.equal('lua', vim.bo[1].syntax)
    assert.is_nil(vim.b[1].bigfile_reason)
    assert.is_nil(vim.b[1].disable_lsp)
    assert.is_true(started_lsp)
  end)

  it('BigfileDisable restores current buffer and notifies', function()
    local plugin = require('bigfile_detection')
    local restore_calls = 0
    local notified

    vim.api.nvim_create_autocmd = function() end
    vim.api.nvim_create_augroup = function()
      return 1
    end
    vim.filetype.add = function() end
    vim.api.nvim_get_current_buf = function()
      return 3
    end
    vim.notify = function(message, level)
      notified = { message = message, level = level }
    end

    plugin.setup({})

    local original_restore = plugin.restore_buffer
    plugin.restore_buffer = function(buf)
      restore_calls = restore_calls + 1
      assert.are.equal(3, buf)
    end

    plugin.disable()

    plugin.restore_buffer = original_restore

    assert.is_true(vim.g.bigfile_detection_disabled)
    assert.are.equal(1, restore_calls)
    assert.are.same({
      message = 'Bigfile detection disabled',
      level = vim.log.levels.INFO,
    }, notified)
  end)

  it('BigfileEnable clears the global disable flag and notifies', function()
    local plugin = require('bigfile_detection')
    local notified

    vim.api.nvim_create_autocmd = function() end
    vim.api.nvim_create_augroup = function()
      return 1
    end
    vim.filetype.add = function() end
    vim.notify = function(message, level)
      notified = { message = message, level = level }
    end

    plugin.setup({})
    vim.g.bigfile_detection_disabled = true

    plugin.enable()

    assert.is_false(vim.g.bigfile_detection_disabled)
    assert.are.same({
      message = 'Bigfile detection enabled',
      level = vim.log.levels.INFO,
    }, notified)
  end)

  it('BigfileToggle switches disable state and restores only when disabling', function()
    local plugin = require('bigfile_detection')
    local notified = {}
    local restore_calls = 0

    vim.api.nvim_create_autocmd = function() end
    vim.api.nvim_create_augroup = function()
      return 1
    end
    vim.filetype.add = function() end
    vim.api.nvim_get_current_buf = function()
      return 7
    end
    vim.notify = function(message, level)
      table.insert(notified, { message = message, level = level })
    end

    plugin.setup({})

    local original_restore = plugin.restore_buffer
    plugin.restore_buffer = function(buf)
      restore_calls = restore_calls + 1
      assert.are.equal(7, buf)
    end

    vim.g.bigfile_detection_disabled = false
    plugin.toggle()
    plugin.toggle()

    plugin.restore_buffer = original_restore

    assert.are.equal(1, restore_calls)
    assert.are.same({
      { message = 'Bigfile detection disabled', level = vim.log.levels.INFO },
      { message = 'Bigfile detection enabled', level = vim.log.levels.INFO },
    }, notified)
    assert.is_false(vim.g.bigfile_detection_disabled)
  end)

  it('BigfileRestore restores the current buffer', function()
    local plugin = require('bigfile_detection')
    local restore_calls = 0

    vim.api.nvim_create_autocmd = function() end
    vim.api.nvim_create_augroup = function()
      return 1
    end
    vim.filetype.add = function() end
    vim.api.nvim_get_current_buf = function()
      return 9
    end

    plugin.setup({})

    local original_restore = plugin.restore_buffer
    plugin.restore_buffer = function(buf)
      restore_calls = restore_calls + 1
      assert.are.equal(9, buf)
    end

    plugin.restore_current_buffer()

    plugin.restore_buffer = original_restore

    assert.are.equal(1, restore_calls)
  end)

  it('does not notify when notifications are globally disabled', function()
    local plugin = require('bigfile_detection')
    local notified = false

    vim.api.nvim_create_autocmd = function() end
    vim.api.nvim_create_augroup = function()
      return 1
    end
    vim.filetype.add = function() end
    vim.api.nvim_get_current_buf = function()
      return 3
    end
    vim.notify = function()
      notified = true
    end

    plugin.setup({
      notifications = {
        enabled = false,
      },
    })

    local original_restore = plugin.restore_buffer
    plugin.restore_buffer = function() end
    plugin.disable()
    plugin.restore_buffer = original_restore

    assert.is_false(notified)
  end)

  it('notifies when filetype cannot be resolved during restore', function()
    local plugin = require('bigfile_detection')
    local notified

    vim.api.nvim_create_user_command = function() end
    vim.api.nvim_create_autocmd = function() end
    vim.api.nvim_create_augroup = function()
      return 1
    end
    vim.filetype.add = function() end
    vim.notify = function(message, level)
      notified = { message = message, level = level }
    end

    plugin.setup({})

    vim.api.nvim_buf_is_valid = function()
      return true
    end
    vim.api.nvim_buf_get_name = function()
      return ''
    end

    plugin.restore_buffer(1)

    assert.are.same({
      message = 'Could not resolve filetype for buffer',
      level = vim.log.levels.WARN,
    }, notified)
  end)

  it('skips unresolved restore notification when disabled', function()
    local plugin = require('bigfile_detection')
    local notified = false

    vim.api.nvim_create_user_command = function() end
    vim.api.nvim_create_autocmd = function() end
    vim.api.nvim_create_augroup = function()
      return 1
    end
    vim.filetype.add = function() end
    vim.notify = function()
      notified = true
    end

    plugin.setup({
      restore = {
        notify_on_unresolved_filetype = false,
      },
    })

    vim.api.nvim_buf_is_valid = function()
      return true
    end
    vim.api.nvim_buf_get_name = function()
      return ''
    end

    plugin.restore_buffer(1)

    assert.is_false(notified)
  end)

  it('registers a filetype override callback that only resolves for disabled normal buffers', function()
    local plugin = require('bigfile_detection')
    local filetype_config

    vim.api.nvim_create_user_command = function() end
    vim.api.nvim_create_autocmd = function() end
    vim.api.nvim_create_augroup = function()
      return 1
    end
    vim.filetype.add = function(config)
      filetype_config = config
    end

    plugin.setup({})

    local callback = filetype_config.pattern['.*'][1]

    vim.bo[1].buftype = ''
    vim.bo[1].filetype = ''
    vim.api.nvim_buf_get_name = function()
      return '/tmp/example.lua'
    end
    vim.g.bigfile_detection_disabled = false
    assert.is_nil(callback('/tmp/example.lua', 1))

    vim.g.bigfile_detection_disabled = true
    assert.are.equal('lua', callback('/tmp/example.lua', 1))

    vim.bo[1].buftype = 'nofile'
    assert.is_nil(callback('/tmp/example.lua', 1))

    assert.is_nil(callback(nil, 1))
    assert.is_nil(callback('/tmp/example.lua', nil))
  end)

  it('applies long lines mode side effects to the buffer and window', function()
    local plugin = require('bigfile_detection')
    local buf = vim.api.nvim_get_current_buf()

    vim.api.nvim_create_user_command = function() end
    vim.api.nvim_create_autocmd = function() end
    vim.api.nvim_create_augroup = function()
      return 1
    end
    vim.filetype.add = function() end
    vim.fn.exists = function(name)
      return name == ':NoMatchParen' and 1 or 0
    end

    local commands = {}
    vim.cmd = function(command)
      table.insert(commands, command)
    end

    plugin.setup({
      long_lines_mode = {
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
        disable_lsp = true,
        disable_matchparen = true,
      },
    })

    plugin.apply_long_lines_mode(buf)

    assert.are.equal('long_lines', vim.b[buf].bigfile_reason)
    assert.is_true(vim.b[buf].disable_lsp)
    assert.are.equal('', vim.bo[buf].syntax)
    assert.are.equal('', vim.bo[buf].filetype)
    assert.is_false(vim.wo.wrap)
    assert.is_false(vim.wo.relativenumber)
    assert.is_false(vim.wo.cursorline)
    assert.is_false(vim.wo.cursorcolumn)
    assert.is_false(vim.bo[buf].swapfile)
    assert.is_false(vim.bo[buf].undofile)
    assert.are.equal(-1, vim.bo[buf].undolevels)
    assert.is_false(vim.wo.foldenable)
    assert.are.equal('manual', vim.wo.foldmethod)
    assert.are.equal('unload', vim.bo[buf].bufhidden)
    assert.is_false(vim.b[buf].snacks_indent)
    assert.are.same({ 'NoMatchParen' }, commands)
  end)

  it('applies window-local options to the target buffer window', function()
    local plugin = require('bigfile_detection')
    local buf = vim.api.nvim_get_current_buf()
    local window_option_calls = {}

    vim.api.nvim_create_user_command = function() end
    vim.api.nvim_create_autocmd = function() end
    vim.api.nvim_create_augroup = function()
      return 1
    end
    vim.filetype.add = function() end
    vim.fn.exists = function()
      return 0
    end
    vim.fn.win_findbuf = function(found_buf)
      if found_buf == buf then
        return { 42 }
      end
      return {}
    end
    vim.api.nvim_win_is_valid = function(win)
      return win == 42
    end
    vim.api.nvim_get_current_win = function()
      return 7
    end
    vim.api.nvim_set_option_value = function(name, value, args)
      if args.win then
        table.insert(window_option_calls, {
          name = name,
          value = value,
          win = args.win,
        })
      end
    end

    plugin.setup({})
    plugin.apply_long_lines_mode(buf)

    assert.are.same({
      { name = 'wrap', value = false, win = 42 },
      { name = 'relativenumber', value = false, win = 42 },
      { name = 'cursorline', value = false, win = 42 },
      { name = 'cursorcolumn', value = false, win = 42 },
      { name = 'foldenable', value = false, win = 42 },
      { name = 'foldmethod', value = 'manual', win = 42 },
    }, window_option_calls)
  end)
end)
