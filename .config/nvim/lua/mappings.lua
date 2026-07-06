-- =============================================================================
-- MAPPINGS
-- =============================================================================

--[[ Modes:
  [c]ommand line
  [i]nsert
  [n]ormal
  [s]elect
  [t]erminal
  [v]isual
  [x](v)isual Line
]]

local M = {}

M.global = {
  {
    mode = { 'v' },
    bindings = {
      {
        key = 'g=',
        cmd = 'c<C-R>=<C-R>-<cr>',
        desc = 'Evaluate math expression',
      },
    },
  },
  {
    mode = { 'i' },
    bindings = {
      { key = { 'jj', 'jk' }, cmd = '<esc>', desc = 'Escape' },
    },
  },
  {
    mode = { 'x' },
    bindings = {
      {
        key = '<leader>sa',
        cmd = ":'<,'>sort<cr>gv=gv",
        desc = 'Sort lines ascending',
      },
      {
        key = '<leader>sd',
        cmd = ":'<,'>sort!<cr>gv=gv",
        desc = 'Sort lines descending',
      },
      { key = '<leader>d', cmd = '"_d', desc = 'Delete without copying' },
      { key = '<leader>p', cmd = '"_dP', desc = 'Paste without copying' },
    },
  },
  {
    mode = { 'n' },
    bindings = {
      {
        key = '<leader>re',
        cmd = '<cmd>restart<cr>',
        desc = 'Restart Neovim (:restart)',
      },
      { key = '<leader>sf', cmd = ':so<cr>', desc = 'Source current file' },
      { key = 'Q', cmd = '<nop>', desc = 'Do nothing (disable ex mode)' },
      {
        key = '<leader>yp',
        cmd = function()
          local path = vim.fn.expand('%:p')
          vim.fn.setreg('+', path)
          vim.notify(string.format('file:%s', path), vim.log.levels.INFO)
        end,
        desc = 'Copy current file path to system clipboard',
      },
      {
        key = '<leader>yrp',
        cmd = function()
          local path = vim.fn.expand('%:.')
          vim.fn.setreg('+', path)
          vim.notify(string.format('file:%s', path), vim.log.levels.INFO)
        end,
        desc = 'Copy current file path relative to current working directory to system clipboard',
      },
      { key = 'J', cmd = 'mzJ`z', desc = 'Append line below to current line' },
      {
        key = 'K',
        cmd = 'mz:move -2|j<cr>`z',
        desc = 'Append line below to current line',
      },
      { key = '<leader>nj', cmd = 'o<Esc>"_D', desc = 'Add new line below' },
      { key = '<leader>nk', cmd = 'O<Esc>"_D', desc = 'Add new line above' },
      { key = '<C-d>', cmd = '<C-d>zz', desc = 'Move page down' },
      { key = '<C-u>', cmd = '<C-u>zz', desc = 'Move page up' },
      { key = 'N', cmd = 'Nzzzv', desc = 'Move to previous match' },
      { key = 'n', cmd = 'nzzzv', desc = 'Move to next match' },
      { key = '<leader>d', cmd = '"_d', desc = 'Delete without copying' },
      {
        key = '<leader>sh',
        cmd = '<C-w>h',
        desc = 'Move to left window buffer',
      },
      {
        key = '<leader>sj',
        cmd = '<C-w>j',
        desc = 'Move to bottom window buffer',
      },
      {
        key = '<leader>sk',
        cmd = '<C-w>k',
        desc = 'Move to top window buffer',
      },
      {
        key = '<leader>sl',
        cmd = '<C-w>l',
        desc = 'Move to right window buffer',
      },
      { key = '<leader>cw', cmd = ':close<cr>', desc = 'Close window buffer' },
      {
        key = '<leader>se',
        cmd = '<C-w>=',
        desc = 'Equalize window buffer sizes',
      },
      {
        key = '<leader>sm',
        cmd = '<C-W>_<cr><C-W>|',
        desc = 'Maximize current window buffer',
      },
      {
        key = '<leader>ss',
        cmd = '<C-w>s',
        desc = 'Split window buffer horizontally',
      },
      {
        key = '<leader>sv',
        cmd = '<C-w>v',
        desc = 'Split window buffer vertically',
      },
      {
        key = '<M-h>',
        cmd = ':vertical resize +2<cr>',
        desc = 'Increase window buffer width',
      },
      {
        key = '<M-j>',
        cmd = ':resize -2<cr>',
        desc = 'Decrease window buffer height',
      },
      {
        key = '<M-k>',
        cmd = ':resize +2<cr>',
        desc = 'Increase window buffer height',
      },
      {
        key = '<M-l>',
        cmd = ':vertical resize -2<cr>',
        desc = 'Decrease window buffer width',
      },
      {
        key = '<leader>cb',
        cmd = '<cmd>bdelete<cr>',
        desc = 'Delete current buffer',
      },
      {
        key = '<leader>sn',
        cmd = '<cmd>bNext<cr>',
        desc = 'Switch to next buffer',
      },
      {
        key = '<leader>sp',
        cmd = '<cmd>bprevious<cr>',
        desc = 'Switch to previous buffer',
      },
      {
        key = '[d',
        cmd = function()
          vim.diagnostic.jump({ count = -1, float = true, wrap = false })
        end,
        desc = 'Previous diagnostic',
      },
      {
        key = ']d',
        cmd = function()
          vim.diagnostic.jump({ count = 1, float = true, wrap = false })
        end,
        desc = 'Next diagnostic',
      },
      {
        key = '<leader>e',
        cmd = vim.diagnostic.open_float,
        desc = 'Show diagnostics under cursor in a floating window',
      },
      {
        key = '<leader>qo',
        cmd = vim.diagnostic.setloclist,
        desc = 'Add buffer diagnostics to location list',
      },
      {
        key = ';j',
        cmd = '<cmd>cnext<cr>zzzv',
        desc = 'Next quickfix list item',
      },
      {
        key = ';k',
        cmd = '<cmd>cprev<cr>zzzv',
        desc = 'Previous quickfix list item',
      },
      { key = ';q', cmd = '<cmd>cclose<cr>', desc = 'Close quickfix list' },
      {
        key = '<leader>rw',
        cmd = [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
        desc = 'Replace word under cursor',
      },
      {
        key = '<leader>mx',
        cmd = function()
          vim.ui.input({ prompt = 'chmod +x <file>? [y/N] ' }, function(input)
            if input ~= nil and input:lower() == 'y' then
              vim.cmd('!chmod +x %')
            end
          end)
        end,
        desc = 'Make current file executable',
        opts = { silent = true },
      },
      {
        key = '@',
        cmd = function()
          ---@diagnostic disable-next-line: undefined-field
          local lazyredraw_saved = vim.opt.lazyredraw:get()
          vim.opt.lazyredraw = true
          vim.cmd(
            string.format(
              'noautocmd norm! %d@%s',
              vim.v.count1,
              vim.fn.getcharstr()
            )
          )
          vim.opt.lazyredraw = lazyredraw_saved
        end,
        desc = 'Run macro silently',
        opts = { noremap = true },
      },
      {
        key = '<leader>g/',
        cmd = function()
          local _, col = table.unpack(vim.api.nvim_win_get_cursor(0))
          local line = vim.api.nvim_get_current_line()
          local raw_path
          local eq_index = line:find('=')
          if eq_index then
            raw_path = line:sub(eq_index + 1):match('^%s*([^%s]+)')
          else
            local start_col = col
            local end_col = col + 1
            while
              start_col > 0 and not line:sub(start_col, start_col):match('%s')
            do
              start_col = start_col - 1
            end
            while
              end_col <= #line and not line:sub(end_col, end_col):match('%s')
            do
              end_col = end_col + 1
            end
            raw_path = line:sub(start_col + 1, end_col - 1)
          end
          raw_path = raw_path:gsub('[\'"{}%[%]<>]', '')
          local path = vim.fn.expand(raw_path)
          if vim.fn.filereadable(path) == 0 then
            vim.notify('File not found: ' .. path, vim.log.levels.WARN)
            return
          end
          vim.cmd('edit ' .. vim.fn.fnameescape(path))
        end,
        desc = 'Open file under cursor',
      },
      {
        key = '<leader>mtv',
        desc = 'List open groups',
        cmd = function()
          local bufnr = vim.api.nvim_get_current_buf()

          local all_autocmds = vim.api.nvim_get_autocmds({
            buffer = bufnr,
          })

          local group_map = {}

          for _, ac in ipairs(all_autocmds) do
            local group = ac.group_name or 'NO_GROUP'
            if not group_map[group] then
              group_map[group] = {}
            end
            table.insert(group_map[group], ac)
          end

          local lines = { '' }
          table.insert(lines, '==== Autocmd Groups Summary ====')
          for group, cmds in pairs(group_map) do
            table.insert(lines, ('Group: %s (Total: %d)'):format(group, #cmds))
            for _, ac in ipairs(cmds) do
              table.insert(
                lines,
                ('  Event: %-15s Pattern: %-10s Command: %s'):format(
                  ac.event,
                  ac.pattern or 'nil',
                  ac.command or 'lua-callback'
                )
              )
            end
          end
          table.insert(lines, '==== End ====')
          vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO)
        end,
      },
    },
  },
  {
    mode = { 't' },
    bindings = {
      {
        key = '<esc><esc>',
        cmd = '<C-\\><C-n>',
        desc = 'Exit terminal mode',
      },
    },
  },
}

M.markdown = {
  {
    mode = { 'n' },
    bindings = {
      { key = 'j', cmd = 'gj', desc = 'Go to next visible line' },
      { key = 'k', cmd = 'gk', desc = 'Go to previous visible line' },
      {
        key = '[s',
        cmd = '[s',
        desc = 'Prev spelling error',
        opts = { noremap = true, silent = true },
      },
      {
        key = ']s',
        cmd = ']s',
        desc = 'Next spelling error',
        opts = { noremap = true, silent = true },
      },
      {
        key = 'z=',
        cmd = 'z=',
        desc = 'Fix spelling error',
        opts = { noremap = true, silent = true },
      },
    },
  },
}

return M
