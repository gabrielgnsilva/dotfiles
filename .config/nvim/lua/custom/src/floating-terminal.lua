local state = { floating = { buf = -1, win = -1 } }

local function create_floating_window(opts)
  opts = opts or {}

  local ui = {
    width = vim.o.columns,
    height = (vim.o.lines - vim.o.cmdheight),
  }

  local pct = 0.80
  local width = math.floor(ui.width * pct)
  local height = math.floor(ui.height * pct)
  local col = math.floor((ui.width - width) / 2)
  local row = math.floor((ui.height - height) / 3)

  --- @type vim.api.keyset.win_config
  local win_config = {
    title = 'Floating Terminal',
    title_pos = 'center',
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    zindex = 50,
    border = 'rounded',
    style = 'minimal',
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

vim.api.nvim_create_autocmd('VimResized', {
  callback = function()
    if vim.api.nvim_win_is_valid(state.floating.win) then
      local total_w = vim.o.columns
      local total_h = vim.o.lines - vim.o.cmdheight
      local w = math.floor(total_w * 0.90)
      local h = math.floor(total_h * 0.90)
      local c = math.floor((total_w - w) / 2)
      local r = math.floor((total_h - h) / 2)
      vim.api.nvim_win_set_config(state.floating.win, {
        relative = 'editor',
        width = w,
        height = h,
        col = c,
        row = r,
      })
    end
  end,
})

require('utils.mappings').load_keymap({
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
