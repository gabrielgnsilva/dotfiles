--[[
  Bigfile Detection needs to be loaded before any other plugin, so it can disable plugins that are not needed when a big file is detected.
]]

return {
  vim.fn.stdpath('config') .. '/custom-plugins/gabrielgnsilva/bigfile-detection',
  name = 'bigfile-detection',
  priority = 1000,
  dir = vim.fn.stdpath('config') .. '/custom-plugins/gabrielgnsilva/bigfile-detection',
  dependencies = { 'folke/snacks.nvim' },
  main = 'bigfile_detection',
  opts = {
    snacks = { bigfile = true }, -- if true, requires `folke/snacks.nvim`
  },
}
