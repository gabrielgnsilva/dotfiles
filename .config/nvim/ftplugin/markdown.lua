local opt = vim.opt
local g = vim.g

opt.wrap = true
opt.breakindent = true
opt.linebreak = true
opt.encoding = 'utf-8'
opt.spelllang = 'pt_br,en_us'
opt.spell = true

g.markdown_recommended_style = 0

opt.conceallevel = 2
g.markdown_syntax_conceal = 1

opt.shiftwidth = 2
opt.tabstop = 2
opt.expandtab = true

require('utils.mappings').load_keymap('markdown')
