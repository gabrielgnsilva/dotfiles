local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function create_floating_window(opts)
  opts = opts or {}

  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local win_config = {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
  }

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

vim.api.nvim_create_user_command('FloatingTerminal', function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window({ buf = state.floating.buf })
    if vim.bo[state.floating.buf].buftype ~= 'terminal' then
      vim.cmd.terminal()
    end
    vim.api.nvim_feedkeys('A', 'n', false)
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end, {})

require('core.utils').load_keymaps({
  {
    mode = { 'n' },
    bindings = {
      {
        key = '<leader>t',
        cmd = '<cmd>:FloatingTerminal<cr>',
        desc = 'Open floating terminal',
      },
    },
  },
  {
    mode = { 't' },
    bindings = {
      {
        key = '<Esc><Esc>',
        cmd = '<C-\\><C-n>',
        desc = 'Exit terminal mode',
      },
    },
  },
})
