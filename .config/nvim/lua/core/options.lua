local opt = vim.opt
local o = vim.o
local g = vim.g

-- Cursor
opt.cursorline = true
opt.cursorlineopt = 'number'

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.numberwidth = 2
opt.ruler = false

-- Tabs and Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true
opt.breakindent = true

-- Line wrapping
opt.wrap = false

-- File history
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath('data') .. '/undodir'

-- Search settings
opt.hlsearch = false
opt.incsearch = true
opt.inccommand = 'split'
opt.ignorecase = true
opt.smartcase = true

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = 'yes'
opt.colorcolumn = '80'
opt.syntax = 'on'
opt.list = true
opt.listchars = 'tab:+-+,multispace:·,trail:·'

-- Clipboard
o.clipboard = 'unnamedplus'

-- Offset while scrolling
opt.scrolloff = 10

-- Backspace
opt.backspace = 'indent,eol,start'

-- Disable mouse while in nvim
opt.mouse = ''

-- Misc
opt.isfname:append('@-@')
opt.updatetime = 250
opt.timeoutlen = 300
opt.laststatus = 3
opt.showmode = false -- Don't show the mode, since it's already in the status line
opt.fillchars = { eob = ' ' }
opt.shortmess:append('sI')

-- Folding
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldmethod = 'expr'
opt.foldexpr = 'nvim_treesitter#foldexpr()'

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
