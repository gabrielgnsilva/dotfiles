describe('bigfile_detection config', function()
  before_each(function()
    package.loaded['bigfile_detection.config'] = nil
  end)

  it('returns a fresh merged config without mutating defaults', function()
    local config = require('bigfile_detection.config')

    local merged = config.merge({
      thresholds = {
        max_file_size = 1024,
      },
      notifications = {
        enabled = false,
      },
    })

    local defaults = config.defaults()

    assert.are.equal(1024, merged.thresholds.max_file_size)
    assert.is_false(merged.notifications.enabled)
    assert.are.equal(500 * 1024, defaults.thresholds.max_file_size)
    assert.is_true(defaults.notifications.enabled)
  end)

  it('rejects invalid threshold values', function()
    local config = require('bigfile_detection.config')

    assert.has_error(function()
      config.merge({
        thresholds = {
          max_file_size = 0,
        },
      })
    end, 'bigfile-detection: thresholds.max_file_size must be > 0')
  end)

  it('rejects invalid notification settings', function()
    local config = require('bigfile_detection.config')

    assert.has_error(function()
      config.merge({
        notifications = {
          enabled = 'yes',
        },
      })
    end, 'bigfile-detection: notifications.enabled must be a boolean')
  end)
end)
