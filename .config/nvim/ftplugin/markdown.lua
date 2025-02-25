local opt = vim.opt
local map = vim.keymap.set

opt.wrap = true
opt.breakindent = true
opt.linebreak = true
opt.spelllang = 'pt_br,en_us'
opt.spell = true

map('n', 'j', 'gj')
map('n', 'k', 'gk')
