local M = setmetatable({}, {
  __call = function(M, ...)
    return M.zen(...)
  end,
})

M.meta = {
  desc = 'Zen mode • distraction-free coding',
}

M.win = nil
M.backdrop_win = nil
M.backdrop_buf = nil
M._aug_enter = nil
M._aug_buf = nil

local function aug(name)
  return vim.api.nvim_create_augroup('ZEN_' .. name, { clear = true })
end

local function is_float(win)
  local c = vim.api.nvim_win_get_config(win)
  return c and c.relative ~= '' -- floats têm relative != ''
end

---@param opts? {statusline: boolean, tabline: boolean}
local function get_main(opts)
  opts = opts or {}
  local bottom = vim.o.cmdheight
    + (opts.statusline and vim.o.laststatus == 3 and 1 or 0)
  local top = opts.tabline
      and ((vim.o.showtabline == 2 or (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1)) and 1 or 0)
    or 0
  local ret = {
    width = vim.o.columns,
    row = top,
    height = vim.o.lines - top - bottom,
  }
  return ret
end

local function open_backdrop(z_above_rest, show_opts)
  local main = get_main(show_opts)
  if not pcall(vim.api.nvim_get_hl, 0, { name = 'ZenBackdrop' }) then
    vim.api.nvim_set_hl(0, 'ZenBackdrop', { bg = '#000000' })
  end

  local buf = M.backdrop_buf
  if not (buf and vim.api.nvim_buf_is_valid(buf)) then
    buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].buftype = 'nofile'
    vim.bo[buf].bufhidden = 'wipe'
    vim.bo[buf].modifiable = true
    local line = (' '):rep(math.max(1, main.width))
    local lines = {}
    for _ = 1, math.max(1, main.height) do
      lines[#lines + 1] = line
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    M.backdrop_buf = buf
  end

  local win = vim.api.nvim_open_win(buf, false, {
    relative = 'editor',
    row = main.row,
    col = 0,
    width = main.width,
    height = main.height,
    style = 'minimal',
    border = 'none',
    focusable = false,
    noautocmd = true,
    zindex = z_above_rest,
  })
  vim.wo[win].winhighlight = 'Normal:ZenBackdrop'
  vim.wo[win].winblend = 40
  M.backdrop_win = win
end

local function close_backdrop()
  if M.backdrop_win and vim.api.nvim_win_is_valid(M.backdrop_win) then
    pcall(vim.api.nvim_win_hide, M.backdrop_win)
  end
  M.backdrop_win = nil
  if M.backdrop_buf and vim.api.nvim_buf_is_valid(M.backdrop_buf) then
    pcall(vim.api.nvim_buf_delete, M.backdrop_buf, { force = true })
  end
  M.backdrop_buf = nil
end

local function deactivate()
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    pcall(vim.api.nvim_win_hide, M.win)
  end
  M.win = nil
  close_backdrop()
  if M._aug_enter then
    pcall(vim.api.nvim_del_augroup_by_id, M._aug_enter)
  end
  if M._aug_buf then
    pcall(vim.api.nvim_del_augroup_by_id, M._aug_buf)
  end
  M._aug_enter, M._aug_buf = nil, nil
end

M.zen = function()
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    deactivate()
    return
  end

  local opts = { show = { statusline = true, tabline = false } }

  local buf = vim.api.nvim_get_current_buf()
  if vim.api.nvim_buf_is_valid(buf) then
    buf = buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  local ui = {
    width = vim.o.columns,
    height = (vim.o.lines - vim.o.cmdheight),
  }
  local pct = 0.50
  local width = math.floor(ui.width * pct)
  local height = 0 -- to be calculated later
  local col = math.floor((ui.width - width) / 2)
  local row = math.floor((ui.height - height) / 3)

  local parent_win = vim.api.nvim_get_current_win()
  local parent_zindex = vim.api.nvim_win_get_config(parent_win).zindex

  local zindex = (parent_zindex and parent_zindex + 2) or 40
  local backdrop_zindex = zindex - 1

  open_backdrop(backdrop_zindex, opts.show)

  ---@type vim.api.keyset.win_config
  local win_opts = {
    width = width,
    height = height,
    col = col,
    row = row,
    border = 'none',
    style = 'minimal',
    relative = 'editor',
    zindex = zindex,
  }

  -- calculate window size
  if
    win_opts.height == 0
    and (opts.show.statusline or opts.show.tabline or vim.o.cmdheight > 0)
  then
    local main = get_main(opts.show)
    win_opts.row = main.row
    win_opts.height = get_main(opts.show).height
  end

  -- create window
  local win = vim.api.nvim_open_win(buf, true, win_opts)
  vim.wo[win].number = true
  vim.wo[win].relativenumber = true

  vim.cmd([[norm! zz]])

  M._aug_enter = aug('WINENTER')
  vim.api.nvim_create_autocmd('WinEnter', {
    group = M._aug_enter,
    desc = 'Zen: close when focus moves to another window',
    callback = function()
      if not (M.win and vim.api.nvim_win_is_valid(M.win)) then
        return
      end
      local w = vim.api.nvim_get_current_win()
      if w ~= M.win and not is_float(w) then
        vim.schedule(deactivate)
      end
    end,
  })

  M._aug_buf = aug('BUFWINENTER')
  vim.api.nvim_create_autocmd('BufWinEnter', {
    group = M._aug_buf,
    buffer = buf,
    desc = 'Zen: keep parent_win on zen buffer',
    callback = function()
      if
        parent_win
        and vim.api.nvim_win_is_valid(parent_win)
        and vim.api.nvim_buf_is_valid(buf)
      then
        pcall(vim.api.nvim_win_set_buf, parent_win, buf)
      end
    end,
  })

  M.win = win
end

return M
