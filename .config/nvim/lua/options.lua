local opt = vim.opt
local o = vim.o
local g = vim.g

-- #region: Leader Key and provider Settings
g.mapleader = ' ' -- Global leader key
g.maplocalleader = '\\' -- Local leader key (used in specific filetypes)
g['loaded_node_provider'] = 0 -- Disables the Node.js provider
g['loaded_perl_provider'] = 0 -- Disables the Perl provider
g['loaded_python3_provider'] = 0 -- Disables the Python 3 provider
g['loaded_ruby_provider'] = 0 -- Disables the Ruby provider
-- #endregion

-- #region: Appearance Settings
opt.title = true
opt.colorcolumn = '81' -- Highlights the 80th column to indicate line length
opt.cursorline = false -- Disable current line highlighting
opt.fillchars = {
  foldopen = '',
  foldclose = '',
  fold = ' ',
  foldsep = ' ',
  diff = '╱',
  eob = ' ',
}
opt.foldenable = true -- Enables code folding
opt.foldexpr = '0' -- Fold expressions
opt.foldlevel = 99 -- Sets the default fold level to 99 (open all code)
opt.foldlevelstart = 99 -- Starts with all folds open
opt.foldmethod = 'expr' -- Uses an expression (like Treesitter) for folding
opt.foldtext = '' -- Inline text displayed when lines are folded
opt.list = true -- Shows invisible characters like tabs and spaces
opt.listchars = 'tab:+-+,multispace:·,trail:·' -- Customizes how invisible characters are displayed
opt.number = true -- Displays line numbers
opt.numberwidth = 2 -- Sets the width of the number column to 2
opt.relativenumber = true -- Displays relative line numbers based on the cursor position
opt.ruler = false -- Disables the ruler (line/column position display)
opt.signcolumn = 'yes' -- Always show the sign column (for diagnostics, etc.), prevents text reflow
opt.synmaxcol = 300 -- Limits syntax highlighting to the first 300 columns
opt.syntax = 'manual' -- Enables syntax highlighting
opt.termguicolors = true -- Enables 24-bit RGB color support in the terminal
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.splitkeep = 'screen' -- Default splitting will cause your main splits to jump when opening an edgebar.
opt.path:append({ '*' })
opt.wildignore:append({ '*/node_modules/*' })
opt.formatoptions:append('jcroqlnt')
opt.winborder = 'rounded'
g.border_style = 'rounded'
-- #endregion

-- #region: Indentation and Formatting Settings
opt.breakindent = true -- Makes line wrapping aligned with the indentation
opt.expandtab = true -- Converts tabs to spaces
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.smartcase = true -- Makes search case-sensitive if any uppercase letters are used
opt.autoindent = true -- Enables automatic indentation for certain syntax
opt.smartindent = true -- Enables automatic indentation for certain syntax
opt.smarttab = true -- Makes tab behavior smarter
opt.softtabstop = 2 -- Sets the number of spaces to use when pressing tab
opt.tabstop = 2 -- Sets the width of a tab character to 4 spaces
opt.wrap = false -- Disables line wrapping (long lines won't wrap)
opt.linebreak = true -- Wrap lines at convenient points
opt.jumpoptions = 'view'
-- #endregion

-- #region: File Handling Settings
opt.backup = false -- Disables backup files
opt.swapfile = false -- Disables the use of swap files
opt.undodir = vim.fn.stdpath('data') .. '/undodir' -- Sets directory for undo history files
opt.undolevels = 10000
opt.undofile = true -- Enables persistent undo history
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'
vim.scriptencoding = 'utf-8'
opt.diffopt:append('internal,algorithm:patience')
opt.confirm = true -- Confirm to save changes before exiting modified buffer
-- #endregion

-- #region: Search Settings
opt.hlsearch = false -- Disables highlighting of search matches
opt.ignorecase = true -- Makes search case-insensitive
opt.inccommand = 'split' -- Shows the effect of a command in a split as you type
opt.incsearch = true -- Enables incremental search as you type
opt.grepformat = '%f:%l:%c:%m'
opt.grepprg = 'rg --vimgrep'
-- #endregion

-- #region: Clipboard Settings
if vim.fn.has('wsl') == 1 then
  vim.cmd([[
    let g:clipboard = {
      \   'name': 'win32yank',
      \   'copy': {
      \      '+': 'win32yank.exe -i --crlf',
      \      '*': 'win32yank.exe -i --crlf',
      \    },
      \   'paste': {
      \      '+': 'win32yank.exe -o --lf',
      \      '*': 'win32yank.exe -o --lf',
      \   },
      \   'cache_enabled': 0,
      \ }
  ]])
else
  o.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'
end
-- #endregion

-- #region: Window and Scrolling Settings
opt.smoothscroll = true
opt.scrolloff = 8 -- Keeps 10 lines visible while scrolling
opt.splitbelow = true -- Opens new horizontal splits below the current window
opt.splitright = true -- Opens new vertical splits to the right of the current window
-- #endregion

-- #region: Backspace and File Name Settings
opt.backspace = { 'start', 'eol', 'indent' } -- Allows backspacing over indentation, end of line, and start of insert mode
opt.isfname:append('@-@') -- Includes hyphen in file names
-- #endregion

-- #region: Performance Settings
opt.timeoutlen = 300 -- Sets the timeout for key mappings (in milliseconds)
opt.updatetime = 200 -- Sets the time in milliseconds before triggering an update event
opt.redrawtime = 1500 -- Maximum time for redraw (ms) - prevents freezes
opt.maxmempattern = 1000 -- Limits memory for pattern matching

-- #endregion

-- #region: UI Settings
opt.shortmess:append({ W = true, I = true, c = true, C = true }) -- Suppresses certain messages in the command line
opt.showmode = false -- Hides the mode display (since it's already in the status line)
opt.showcmd = false -- Let lualine handle this
opt.laststatus = 2
-- global statusline
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.virtualedit = 'block' -- Allow cursor to move where there is no text in visual block mode
-- #endregion

-- #region: Completion and Mouse Settings
opt.completeopt = 'menu,menuone,noselect,preview' -- Sets completion options
opt.mouse = '' -- Disables mouse support in Neovim
opt.wildmode = 'longest:full,full' -- Command-line completion mode
-- #endregion

-- #region: Session
opt.modeline = false -- Disables modeline for security reasons
opt.sessionoptions = {
  'buffers',
  'curdir',
  'tabpages',
  'winsize',
  'help',
  'globals',
  'skiprtp',
  'folds',
}
-- #endregion

-- #region: Plugin and Lazy Loading Settings
if vim.loader then
  vim.loader.enable() -- Caches Lua bytecode for require() calls
end
-- #endregion
