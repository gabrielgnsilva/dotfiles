local create_autocmd = vim.api.nvim_create_autocmd
local function create_augroup(name)
  return vim.api.nvim_create_augroup('custom_gp_' .. name, { clear = true })
end

create_autocmd('termOpen', {
  desc = 'Disable line numbers on terminal',
  group = create_augroup('custom-term-open'),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  desc = 'Check if we need to reload the file when it changed',
  group = create_augroup('checktime'),
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
})

create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = create_augroup('highlight_yank'),
  callback = function()
    (vim.highlight or vim.hl).on_yank()
  end,
})

create_autocmd('BufReadPost', {
  desc = 'Go to last location when opening a buffer',
  group = create_augroup('last_loc'),
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

create_autocmd('BufWritePre', {
  desc = 'Auto create dir when saving a file, in case some intermediate directory does not exist',
  group = create_augroup('auto_create_dir'),
  callback = function(event)
    if event.match:match('^%w%w+:[\\/][\\/]') then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

create_autocmd('FileType', {
  desc = 'Close some filetypes with <q>',
  group = create_augroup('close_with_q'),
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

if vim.fn.has('wsl') == 1 then
  create_autocmd('FocusGained', {
    desc = 'Sync with system clipboard on focus gained',
    pattern = { '*' },
    command = [[call setreg("@", getreg("+"))]],
  })
  create_autocmd('FocusLost', {
    desc = 'Sync with system clipboard on focus lost',
    pattern = { '*' },
    command = [[call setreg("+", getreg("@"))]],
  })
end
