describe('bigfile_detection detector', function()
  local original_buf_line_count
  local original_buf_get_lines
  local original_buf_get_name
  local original_fs_stat

  before_each(function()
    package.loaded['bigfile_detection.detector'] = nil
    original_buf_line_count = vim.api.nvim_buf_line_count
    original_buf_get_lines = vim.api.nvim_buf_get_lines
    original_buf_get_name = vim.api.nvim_buf_get_name
    original_fs_stat = (vim.uv or vim.loop).fs_stat
  end)

  after_each(function()
    vim.api.nvim_buf_line_count = original_buf_line_count
    vim.api.nvim_buf_get_lines = original_buf_get_lines
    vim.api.nvim_buf_get_name = original_buf_get_name
    ;(vim.uv or vim.loop).fs_stat = original_fs_stat
  end)

  it('detects long lines from the configured sample', function()
    local detector = require('bigfile_detection.detector')

    vim.api.nvim_buf_line_count = function()
      return 3
    end
    vim.api.nvim_buf_get_lines = function(_, start_line)
      local lines = { 'short', string.rep('x', 20), 'short' }
      return { lines[start_line + 1] }
    end

    local result = detector.has_long_lines(1, {
      thresholds = {
        max_line_length = 10,
        line_sample = 3,
      },
    })

    assert.is_true(result)
  end)

  it('detects large files from fs stats', function()
    local detector = require('bigfile_detection.detector')

    vim.api.nvim_buf_get_name = function()
      return '/tmp/example.txt'
    end
    ;(vim.uv or vim.loop).fs_stat = function()
      return { size = 2048 }
    end

    local result = detector.is_large_file(1, {
      thresholds = {
        max_file_size = 1024,
      },
    })

    assert.is_true(result)
  end)

  it('returns the first matching reason and disable rule', function()
    local detector = require('bigfile_detection.detector')

    vim.api.nvim_buf_get_name = function()
      return '/tmp/example.txt'
    end
    ;(vim.uv or vim.loop).fs_stat = function()
      return { size = 2048 }
    end
    vim.api.nvim_buf_line_count = function()
      return 1
    end
    vim.api.nvim_buf_get_lines = function()
      return { 'short' }
    end

    local config = {
      thresholds = {
        max_file_size = 1024,
        max_line_length = 500,
        line_sample = 5,
      },
      integration = {
        snacks_bigfile = false,
      },
      rules = {
        large_file = {
          lsp = false,
          treesitter = true,
        },
      },
    }

    assert.are.equal('large_file', detector.reason(1, config))
    assert.is_true(detector.should_disable('treesitter', 1, config))
    assert.is_false(detector.should_disable('lsp', 1, config))
  end)
end)
