local opt = vim.opt
local g = vim.g

opt.wrap = true
opt.breakindent = true
opt.linebreak = true
opt.encoding = 'utf-8'
opt.spelllang = 'pt_br,en_us'
opt.spell = true

g.markdown_recommended_style = 0 -- Fix markdown indentation settings

require('core.utils').load_keymaps('markdown')
