local create_autocmd = require('utils').create_autocmd

create_autocmd('open_oil_on_startup', 'VimEnter', {
  desc = 'Open Oil when starting without args',
  callback = function()
    if vim.fn.argc() ~= 0 then
      return
    end

    if vim.bo.buftype ~= '' then
      return
    end

    if vim.api.nvim_buf_get_name(0) ~= '' then
      return
    end

    local lines = vim.api.nvim_buf_get_lines(0, 0, 1, false)
    if vim.api.nvim_buf_line_count(0) ~= 1 or lines[1] ~= '' then
      return
    end

    vim.schedule(function()
      if vim.fn.exists(':Oil') == 2 then
        vim.cmd('Oil')
      end
    end)
  end,
})

create_autocmd('custom-term-open', 'termOpen', {
  desc = 'Disable line numbers on terminal',
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

create_autocmd('checktime', { 'FocusGained', 'TermClose', 'TermLeave' }, {
  desc = 'Check if we need to reload the file when it changed',
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
})

create_autocmd('highlight_yank', 'TextYankPost', {
  desc = 'Highlight when yanking text',
  callback = function()
    (vim.highlight or vim.hl).on_yank()
  end,
})

create_autocmd('last_loc', 'BufReadPost', {
  desc = 'Go to last location when opening a buffer',
  callback = function(event)
    local exclude = { 'gitcommit' }
    local buf = event.buf
    if
      vim.tbl_contains(exclude, vim.bo[buf].filetype)
      or vim.b[buf].lazyvim_last_loc
    then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

create_autocmd('auto_create_dir', 'BufWritePre', {
  desc = 'Auto create dir when saving a file, in case some intermediate directory does not exist',
  callback = function(event)
    if event.match:match('^%w%w+:[\\/][\\/]') then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

create_autocmd('xrdb_merge_Xresources', 'BufWritePost', {
  desc = 'Automatically call xrdb when saving a Xresources file',
  callback = function(event)
    if event.match:match('^%w%w+:[\\/][\\/]') then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    if file:match('/%.?Xresources$') then
      local filePath = vim.fn.shellescape(file)
      vim.cmd(string.format('silent !xrdb -merge %s', filePath))
      vim.notify(string.format('%s merged using `xrdb`', filePath))
    end
  end,
})

create_autocmd('close_with_q', 'FileType', {
  desc = 'Close some filetypes with <q>',
  pattern = {
    'PlenaryTestPopup',
    'checkhealth',
    'dbout',
    'gitsigns-blame',
    'grug-far',
    'help',
    'lspinfo',
    'neotest-output',
    'neotest-output-panel',
    'neotest-summary',
    'notify',
    'qf',
    'spectre_panel',
    'startuptime',
    'tsplayground',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set('n', 'q', function()
        vim.cmd('close')
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = 'Quit buffer',
      })
    end)
  end,
})

create_autocmd('lint', { 'BufWritePost', 'InsertLeave' }, {
  desc = 'Auto lint current buffer',
  callback = function(event)
    local buf = event.buf

    -- Skip when snacks.bigfile is active (filetype is set to `bigfile`)
    if vim.bo[buf].filetype == 'bigfile' then
      return
    end

    if
      vim.g.bigfile_detection_disabled ~= true
      and require('utils.bigfile').has_long_lines(buf)
    then
      return
    end

    require('lint').try_lint()
  end,
})

if vim.fn.has('wsl') == 1 then
  create_autocmd('clipboard', 'FocusGained', {
    desc = 'Sync with system clipboard on focus gained',
    pattern = { '*' },
    command = [[call setreg("@", getreg("+"))]],
  })
  create_autocmd('clipboard', 'FocusLost', {
    desc = 'Sync with system clipboard on focus lost',
    pattern = { '*' },
    command = [[call setreg("+", getreg("@"))]],
  })
end

create_autocmd('long_lines_detection', 'BufReadPost', {
  desc = 'Disable heavy features for files with very long lines',
  callback = function(event)
    local buf = event.buf

    if vim.g.bigfile_detection_disabled == true then
      return
    end

    -- Skip when snacks.bigfile is active (filetype is set to `bigfile`)
    if vim.bo[buf].filetype == 'bigfile' then
      return
    end

    if not require('utils.bigfile').has_long_lines(buf) then
      return
    end

    vim.notify(
      'Long lines detected, disabling heavy features',
      vim.log.levels.WARN
    )

    -- LSP
    vim.b[buf].disable_lsp = true

    -- Syntax and filetype
    vim.bo[buf].syntax = 'off'
    vim.bo[buf].filetype = ''

    -- Wrap
    vim.wo.wrap = false

    -- Line numbers
    vim.wo.relativenumber = false

    -- Cursor highlighting
    vim.wo.cursorline = false
    vim.wo.cursorcolumn = false

    -- Swap and undo (I/O)
    vim.bo[buf].swapfile = false
    vim.bo[buf].undofile = false
    vim.bo[buf].undolevels = -1

    -- Folding
    vim.wo.foldenable = false
    vim.wo.foldmethod = 'manual'

    -- Matchparen (builtin plugin)
    if vim.fn.exists(':NoMatchParen') ~= 0 then
      vim.cmd('NoMatchParen')
    end

    -- Memory management
    vim.bo[buf].bufhidden = 'unload'

    -- Plugins
    vim.b[buf].snacks_indent = false
  end,
})

create_autocmd('lsp_bigfile_guard', 'LspAttach', {
  desc = 'Prevent LSP from attaching to buffers with long lines',
  callback = function(args)
    local buf = args.buf

    if not (vim.bo[buf].filetype == 'bigfile' or vim.b[buf].disable_lsp) then
      return
    end

    local client_id = args.data.client_id
    vim.schedule(function()
      pcall(vim.lsp.buf_detach_client, buf, client_id)
    end)
  end,
})

create_autocmd('vertical_helper', { 'FileType' }, {
  desc = 'Open help in vertical spli',
  pattern = { 'help' },
  command = 'wincmd L',
})

create_autocmd('auto_resize_splits', { 'VimREsized' }, {
  desc = 'Resize splits when the terminal is resized',
  command = 'wincmd =',
})

create_autocmd('no_auto_comment', { 'FileType' }, {
  desc = 'Disable auto comment continuation',
  callback = function()
    vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
  end,
})

-- create_autocmd('create_autocmd',
