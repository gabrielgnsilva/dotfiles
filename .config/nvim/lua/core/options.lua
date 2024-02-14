local opt = vim.opt

-- Cursor
-- opt.guicursor = { 'a:ver25' }

-- Line numbers
opt.nu = true
opt.relativenumber = true

-- Tabs and Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true

-- Line wrapping
opt.wrap = false

-- File history
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.config/nvim/undodir"
opt.undofile = true

-- Search settings
opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.colorcolumn = "80"
opt.syntax = "on"
opt.list = true
opt.listchars = "tab:+-+,multispace:·,trail:·"

-- Clipboard
opt.clipboard:append("unnamedplus")

-- Offset while scrolling
opt.scrolloff = 8

-- Backspace
opt.backspace = "indent,eol,start"

-- Disable mouse while in nvim
opt.mouse = ""

-- Misc
opt.isfname:append("@-@")
opt.updatetime = 50

-- Folding
opt.foldlevel = 20
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
