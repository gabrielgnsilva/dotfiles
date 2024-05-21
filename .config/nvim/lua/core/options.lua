local option = vim.opt

-- Cursor
-- opt.guicursor = { 'a:ver25' }

-- Line numbers
option.nu = true
option.relativenumber = true

-- Tabs and Indentation
option.tabstop = 4
option.shiftwidth = 4
option.softtabstop = 4
option.expandtab = true
option.smartindent = true

-- Line wrapping
option.wrap = false

-- File history
option.swapfile = false
option.backup = false
option.undodir = os.getenv('HOME') .. '/.config/nvim/undodir'
option.undofile = true

-- Search settings
option.hlsearch = false
option.incsearch = true
option.ignorecase = true

-- Appearance
option.termguicolors = true
option.signcolumn = 'yes'
option.colorcolumn = '80'
option.syntax = 'on'
option.list = true
option.listchars = 'tab:+-+,multispace:·,trail:·'

-- Clipboard
option.clipboard:append('unnamedplus')

-- Offset while scrolling
option.scrolloff = 8

-- Backspace
option.backspace = 'indent,eol,start'

-- Disable mouse while in nvim
option.mouse = ''

-- Misc
option.isfname:append('@-@')
option.updatetime = 50

-- Folding
option.foldenable = true
option.foldlevel = 99
option.foldlevelstart = 99
option.foldmethod = 'expr'
option.foldexpr = 'nvim_treesitter#foldexpr()'

-- Filetype mapping
vim.filetype.add({
    extension = {
        ftl = 'html',
        info = 'properties'
    },
})

