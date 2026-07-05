local opt = vim.opt_local
local g = vim.g

opt.wrap = true
opt.spell = true
opt.spelllang = 'pt_br,en_us'

g.markdown_recommended_style = 0
g.markdown_syntax_conceal = 1

require('utils.mappings').load_keymap('markdown')
