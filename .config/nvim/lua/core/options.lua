local opt = vim.opt
local o = vim.o
local g = vim.g

-- #region: Leader Key and Basic Settings
g.mapleader = ' ' -- Global leader key
g.maplocalleader = ' ' -- Local leader key (used in specific filetypes)
-- #endregion

-- #region: Appearance Settings
opt.colorcolumn = '80' -- Highlights the 80th column to indicate line length
opt.cursorline = true -- Highlights the line the cursor is on
opt.cursorlineopt = 'number' -- Highlights the line number of the current cursor line
opt.fillchars = { eob = ' ' } -- Replaces end-of-buffer text with spaces
opt.list = true -- Shows invisible characters like tabs and spaces
opt.listchars = 'tab:+-+,multispace:·,trail:·' -- Customizes how invisible characters are displayed
opt.number = true -- Displays line numbers
opt.numberwidth = 2 -- Sets the width of the number column to 2
opt.relativenumber = true -- Displays relative line numbers based on the cursor position
opt.ruler = false -- Disables the ruler (line/column position display)
opt.signcolumn = 'yes' -- Always show the sign column (for diagnostics, etc.)
opt.synmaxcol = 200 -- Limits syntax highlighting to the first 200 columns
opt.syntax = 'on' -- Enables syntax highlighting
opt.termguicolors = true -- Enables 24-bit RGB color support in the terminal
-- #endregion

-- #region: Indentation and Formatting Settings
opt.breakindent = true -- Makes line wrapping aligned with the indentation
opt.expandtab = true -- Converts tabs to spaces
opt.shiftwidth = 4 -- Sets the number of spaces to use for auto-indentation
opt.smartcase = true -- Makes search case-sensitive if any uppercase letters are used
opt.smartindent = true -- Enables automatic indentation for certain syntax
opt.softtabstop = 4 -- Sets the number of spaces to use when pressing tab
opt.tabstop = 4 -- Sets the width of a tab character to 4 spaces
opt.wrap = false -- Disables line wrapping (long lines won't wrap)
-- #endregion

-- #region: File Handling Settings
opt.backup = false -- Disables backup files
opt.swapfile = false -- Disables the use of swap files
opt.undodir = vim.fn.stdpath('data') .. '/undodir' -- Sets directory for undo history files
opt.undofile = true -- Enables persistent undo history
opt.fileencoding = 'utf-8'
-- #endregion

-- #region: Search Settings
opt.hlsearch = false -- Disables highlighting of search matches
opt.ignorecase = true -- Makes search case-insensitive
opt.inccommand = 'split' -- Shows the effect of a command in a split as you type
opt.incsearch = true -- Enables incremental search as you type
-- #endregion

-- #region: Clipboard Settings (WSL specific)
if vim.fn.has('wsl') == 1 then
    o.clipboard = '' -- Disables clipboard integration on WSL
else
    o.clipboard = 'unnamedplus' -- Uses the system clipboard for yank, delete, paste
end
-- #endregion

-- #region: Window and Scrolling Settings
opt.scrolloff = 10 -- Keeps 10 lines visible above and below the cursor while scrolling
opt.splitbelow = true -- Opens new horizontal splits below the current window
opt.splitright = true -- Opens new vertical splits to the right of the current window
-- #endregion

-- #region: Backspace and File Name Settings
opt.backspace = 'indent,eol,start' -- Allows backspacing over indentation, end of line, and start of insert mode
opt.isfname:append('@-@') -- Includes hyphen in file names
-- #endregion

-- #region: Performance Settings
opt.timeoutlen = 300 -- Sets the timeout for key mappings (in milliseconds)
opt.ttyfast = true -- Improves performance when interacting with the terminal
opt.updatetime = 250 -- Sets the time in milliseconds before triggering an update event
-- #endregion

-- #region: UI Settings
opt.laststatus = 3 -- Always show the status line
opt.shortmess:append('sWI') -- Suppresses certain messages in the command line
opt.showmode = false -- Hides the mode display (since it's already in the status line)
-- #endregion

-- #region: Completion and Mouse Settings
opt.completeopt = 'menu,menuone,noselect' -- Sets completion options
opt.mouse = '' -- Disables mouse support in Neovim
-- #endregion

-- #region: Folding Settings
opt.foldenable = true -- Enables code folding
opt.foldexpr = 'nvim_treesitter#foldexpr()' -- Uses Treesitter to determine fold expressions
opt.foldlevel = 99 -- Sets the default fold level to 99 (open all code)
opt.foldlevelstart = 99 -- Starts with all folds open
opt.foldmethod = 'expr' -- Uses an expression (like Treesitter) for folding
-- #endregion

-- #region: Provider Settings
g['loaded_node_provider'] = 0 -- Disables the Node.js provider
g['loaded_perl_provider'] = 0 -- Disables the Perl provider
g['loaded_python3_provider'] = 0 -- Disables the Python 3 provider
g['loaded_ruby_provider'] = 0 -- Disables the Ruby provider
-- #endregion

-- #region: Plugin and Lazy Loading Settings
vim.loader.enable() -- Enables lazy loading of plugins (if needed)
-- #endregion
