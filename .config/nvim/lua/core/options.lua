local opt = vim.opt
local o = vim.o
local g = vim.g

-- Cursor
-- opt.guicursor = { 'a:ver25' }
o.cursorline = true
o.cursorlineopt = 'number'

-- Line numbers
o.nu = true
o.relativenumber = true
o.numberwidth = 2
o.ruler = false

-- Tabs and Indentation
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = 4
o.expandtab = true
o.smartindent = true

-- Line wrapping
o.wrap = false

-- File history
o.swapfile = false
o.backup = false
o.undofile = true
o.undodir = vim.fn.stdpath('data') .. '/undodir'

-- Search settings
o.hlsearch = false
o.incsearch = true
o.ignorecase = true

-- Appearance
o.termguicolors = true
o.signcolumn = 'yes'
o.colorcolumn = '80'
o.syntax = 'on'
o.list = true
o.listchars = 'tab:+-+,multispace:·,trail:·'

-- Clipboard
o.clipboard = 'unnamedplus'

-- Offset while scrolling
o.scrolloff = 8

-- Backspace
o.backspace = 'indent,eol,start'

-- Disable mouse while in nvim
o.mouse = ''

-- Misc
opt.isfname:append('@-@')
o.updatetime = 250
o.laststatus = 3
o.showmode = false
opt.fillchars = { eob = ' ' }
o.smartcase = true
opt.shortmess:append('sI')
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400

-- Folding
o.foldenable = true
o.foldlevel = 99
o.foldlevelstart = 99
o.foldmethod = 'expr'
o.foldexpr = 'nvim_treesitter#foldexpr()'

g['loaded_node_provider'] = 0
g['loaded_python3_provider'] = 0
g['loaded_perl_provider'] = 0
g['loaded_ruby_provider'] = 0

-- Filetype mapping
vim.filetype.add({
    extension = {
        ftl = 'html',
        info = 'properties',
    },
})
