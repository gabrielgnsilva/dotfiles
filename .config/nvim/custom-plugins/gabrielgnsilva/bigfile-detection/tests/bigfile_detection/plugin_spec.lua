describe('bigfile_detection plugin entrypoint', function()
  local original_create_user_command

  before_each(function()
    package.loaded['bigfile_detection'] = nil
    vim.g.loaded_bigfile_detection_plugin = nil
    original_create_user_command = vim.api.nvim_create_user_command
  end)

  after_each(function()
    vim.api.nvim_create_user_command = original_create_user_command
  end)

  it('registers user commands once', function()
    package.loaded['plugin.bigfile-detection'] = nil
    local commands = {}

    vim.api.nvim_create_user_command = function(name)
      table.insert(commands, name)
    end

    dofile('plugin/bigfile-detection.lua')
    dofile('plugin/bigfile-detection.lua')

    assert.are.same({
      'BigfileDisable',
      'BigfileEnable',
      'BigfileToggle',
      'BigfileRestore',
    }, commands)
  end)
end)
