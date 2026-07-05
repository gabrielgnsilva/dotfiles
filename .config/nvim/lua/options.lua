-- =============================================================================
-- OPTIONS
-- =============================================================================

local set = vim.opt
local set_global = vim.g

set_global.mapleader = ' ' -- Global leader key
set_global.maplocalleader = '\\' -- Local leader key (used in specific filetypes)
set_global['loaded_node_provider'] = 0 -- Disables the Node.js provider
set_global['loaded_perl_provider'] = 0 -- Disables the Perl provider
set_global['loaded_python3_provider'] = 0 -- Disables the Python 3 provider
set_global['loaded_ruby_provider'] = 0 -- Disables the Ruby provider

set.termguicolors = true -- Enables 24-bit RGB color support in the terminal
set.number = true -- Displays line numbers
set.numberwidth = 2 -- Sets the width of the number column to 2
set.relativenumber = true -- Displays relative line numbers based on the cursor position
set.cursorline = false -- Disable current line highlighting
set.wrap = false -- Disables line wrapping (long lines won't wrap)
set.linebreak = true -- Wrap lines at convenient points
set.smoothscroll = true -- Enables smooth scrolling
set.scrolloff = 8 -- Keeps 8 lines visible while scrolling
set.sidescrolloff = 8 -- Keeps 8 lines visible while scrolling
set.virtualedit = 'block' -- Allow cursor to move where there is no text in visual block mode
set.laststatus = 2 -- Always show the status line
set.winborder = 'rounded' -- Rounded borders for floating windows
set_global.border_style = 'rounded' -- Rounded borders for all plugins that use this global variable

set.pumblend = 10 -- Popup transparency
set.pumheight = 6 -- Maximum number of entries in a popup
set.winblend = 0 -- Floating window transparency

set.showmode = false -- Hides the mode display (since it's already in the status line)
set.showcmd = false -- Let lualine handle this

set.signcolumn = 'yes' -- Always show the sign column (for diagnostics, etc.), prevents text reflow
set.colorcolumn = '81' -- Highlights the 81th column to indicate line length
set.showmatch = true -- highlights matching brackets
-- set.cmdheight = 1 -- single line command line

set.ignorecase = true -- Makes search case-insensitive
set.smartcase = true -- Makes search case-sensitive if any uppercase letters are used
set.hlsearch = false -- Disables highlighting of search matches
set.incsearch = true -- Enables incremental search as you type
set.inccommand = 'split' -- Shows the effect of a command in a split as you type

set.foldenable = true -- Enables code folding
set.foldmethod = 'expr' -- Uses an expression for folding
set.foldexpr = '0' -- Fold expressions
set.foldlevel = 99 -- Sets the default fold level to 99 (open all code)
set.foldtext = '' -- Inline text displayed when lines are folded

set.autocomplete = false -- Disables automatic completion (we will use a plugin for this)
set.autocompletedelay = 150 -- Delay in milliseconds before showing completion menu
set.completeopt = { 'menu', 'menuone', 'noinsert', 'noselect' } -- Completion options for better experience with completion plugins
set.wildmenu = true -- Enables command-line completion in a menu
set.wildmode = 'longest:full,full' -- Command-line completion mode

set.ruler = false -- Disables the ruler (line/column position display)
set.list = true -- Shows invisible characters like tabs and spaces
set.listchars = 'tab:+-+,multispace:.,trail:.' -- Customizes how invisible characters are displayed
set.formatoptions:append('jcroqlnt')
set.fileformats = { 'unix', 'dos' }
set.fileformat = 'unix'

set.smarttab = true -- Makes tab behavior smarter
set.tabstop = 2 -- Sets the width of a tab character to 4 spaces
set.shiftwidth = 2 -- Size of an indent
set.softtabstop = 2 -- Sets the number of spaces to use when pressing tab
set.expandtab = true -- Converts tabs to spaces
set.autoindent = true -- Enables automatic indentation for certain syntax
set.smartindent = true -- Enables automatic indentation for certain syntax
set.breakindent = true -- Makes line wrapping aligned with the indentation
set.shiftround = true -- Round indent
set.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
set.concealcursor = '' -- Don't hide the cursor in concealed text
set.syntax = 'manual' -- Enables syntax highlighting
set.synmaxcol = 300 -- Limits syntax highlighting to the first 300 columns
set.fillchars = { eob = ' ' } -- hide "~" on empty lines
set.iskeyword:append('-') -- include - in words
set.path:append({ '**' }) -- Search down into subfolders
set.selection = 'inclusive' -- include last char in selection
set.backspace = { 'indent', 'eol', 'start' } -- Allows backspacing over indentation, end of line, and start of insert mode
set.jumpoptions = 'view' -- Saves and restores view when jumping to a different file
set.sessionoptions = {
  'buffers',
  'curdir',
  'tabpages',
  'winsize',
  'help',
  'globals',
  'skiprtp',
  'folds',
} -- Options for :mksession

set.mouse = '' -- Disables mouse support in Neovim
set.clipboard:append('unnamedplus') -- Use the system clipboard for all operations (copy/paste)
set.diffopt:append('internal,algorithm:patience') -- Use the internal diff algorithm with patience for better diffs
set.isfname:append('@-@') -- Includes hyphen in file names
set.wildignore:append({ '*/node_modules/*' }) -- Ignore node_modules in file searches
set.autochdir = false -- do not autochange directories
set.errorbells = false -- Disables error bells
set.hidden = true -- Allow hidden buffers
-- set.modifiable = true -- allow buffer modifications
set.encoding = 'utf-8' -- Sets the default encoding for files
set.grepformat = '%f:%l:%c:%m' -- Format for grep results (file:line:column:message)
set.grepprg = 'rg --vimgrep' -- Use ripgrep for grep commands

set.splitkeep = 'screen' -- Default splitting will cause your main splits to jump when opening an edgebar.
set.splitbelow = true -- Opens new horizontal splits below the current window
set.splitright = true -- Opens new vertical splits to the right of the current window

set.undofile = true -- Enables persistent undo history
set.undodir = string.format('%s/undodir', vim.fn.stdpath('data')) -- Sets directory for undo history files
set.undolevels = 10000 -- Sets the maximum number of undo levels
set.backup = false -- Disables backup files
set.writebackup = false -- Do not write to a backup file before overwriting a file
set.swapfile = false -- Disables the use of swap files
set.updatetime = 200 -- Sets the time in milliseconds before triggering an update event
set.timeoutlen = 500 -- Sets the timeout duration for mapped sequences (in milliseconds)
set.ttimeoutlen = 50 -- Sets the timeout for key codes (in milliseconds)
set.redrawtime = 10000 -- Maximum time for redraw (ms) - prevents freezes
set.maxmempattern = 20000 -- Limits memory for pattern matching
set.autoread = true -- Automatically reloads files when they are changed outside of Neovim
set.autowrite = false -- Automatically saves changes when switching buffers or exiting Neovim
set.confirm = true -- Confirm to save changes before exiting modified buffer

set.shortmess:append({ W = true, I = true, c = true, C = true }) -- Suppresses certain messages in the command line
set.modeline = false -- Disables modeline for security reasons

if vim.loader then
  vim.loader.enable() -- Caches Lua bytecode for require() calls
end
