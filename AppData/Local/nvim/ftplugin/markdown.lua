local opt = vim.opt

opt.wrap = true
opt.breakindent = true
opt.linebreak = true

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

opt.spelllang = "en_us"
opt.spell = true
