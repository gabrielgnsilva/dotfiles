if vim.g.loaded_bigfile_detection_plugin == 1 then
  return
end
vim.g.loaded_bigfile_detection_plugin = 1

vim.api.nvim_create_user_command('BigfileDisable', function()
  require('bigfile_detection').disable()
end, { desc = 'Disable bigfile detection' })

vim.api.nvim_create_user_command('BigfileEnable', function()
  require('bigfile_detection').enable()
end, { desc = 'Enable bigfile detection' })

vim.api.nvim_create_user_command('BigfileToggle', function()
  require('bigfile_detection').toggle()
end, { desc = 'Toggle bigfile detection' })

vim.api.nvim_create_user_command('BigfileRestore', function()
  require('bigfile_detection').restore_current_buffer()
end, { desc = 'Restore current buffer after bigfile detection' })
