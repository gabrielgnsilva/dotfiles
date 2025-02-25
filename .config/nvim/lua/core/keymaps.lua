--[[
    Modes:
        [n]ormal
        [i]nsert
        [v]isual
        [x](v)isual Line
]]

local map = vim.keymap.set
local utils = require('core.utils')

-- #region: General Keymaps
map('i', 'jj', '<esc>', { desc = 'Escape' })
map('n', '<leader><leader>', ':so<cr>', { desc = 'Source current file' })
map('n', 'Q', '<nop>', { desc = 'Do nothing (disable ex mode)' })
map('n', '@', function()
    vim.opt.lazyredraw = true
    vim.cmd(string.format('noautocmd norm! %d@%s', vim.v.count1, vim.fn.getcharstr()))
    vim.opt.lazyredraw = false
end, { noremap = true })
-- #endregion

-- #region: Terminal Management
local job_id = 0
map('n', '<leader>st', function()
    vim.cmd.vnew()
    vim.cmd.term()
    vim.cmd.wincmd('J')
    vim.api.nvim_win_set_height(0, 4)
    job_id = vim.bo.channel
end, { desc = 'Open small terminal node' })
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('n', '<leader>tb', function()
    if utils.is_angular_project() then
        vim.fn.chansend(job_id, { 'ng build\r\n' })
    end
end, { desc = 'Run build command.' })
map('n', '<leader>tc', function()
    if utils.is_angular_project() then
        vim.fn.chansend(job_id, { 'clear\r\n' })
    end
end, { desc = 'Run clear command.' })
-- #endregion

-- #region: Sorting and Moving Lines
map('x', '<leader>sa', ":'<,'>sort<cr>gv=gv", { desc = 'Sort lines ascending' })
map('x', '<leader>sd', ":'<,'>sort!<cr>gv=gv", { desc = 'Sort lines descending' })
map('v', 'J', ":move '>+1<cr>gv=gv", { desc = 'Move line down' })
map('v', 'K', ":move '<-2<cr>gv=gv", { desc = 'Move line up' })
-- #endregion

-- #region: Line Manipulation
map('n', 'J', 'mzJ`z', { desc = 'Append line below to current line' })
map('n', 'K', 'mz:move -2|j<cr>`z', { desc = 'Append line below to current line' })
map('n', '<leader>nj', 'o<Esc>"_D', { desc = 'Add new line below' })
map('n', '<leader>nk', 'O<Esc>"_D', { desc = 'Add new line above' })
-- #endregion

-- #region: Scrolling and Search
map('n', '<C-n>', '<C-d>zz', { desc = 'Move page down' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Move page up' })
map('n', 'N', 'Nzzzv', { desc = 'Move to previous match' })
map('n', 'n', 'nzzzv', { desc = 'Move to next match' })
-- #endregion

-- #region: Delete and Paste Without Register
map('n', '<leader>d', '"_d', { desc = 'Delete without copying' })
map('x', '<leader>d', '"_d', { desc = 'Delete without copying' })
map('x', '<leader>p', '"_dP', { desc = 'Paste without copying' })
-- #endregion

-- #region: Word Replacement and File Permissions
map('n', '<leader>rw', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Replace word under cursor' })
map('n', '<leader>mx', function()
    vim.ui.input({ prompt = 'chmod +x <file>? [y/N] ' }, function(input)
        if input ~= nil and input:lower() == 'y' then
            vim.cmd('!chmod +x %')
        end
    end)
end, { silent = true, desc = 'Make current file executable' })
-- #endregion

-- #region: Window and Buffer Management
map('n', '<leader>sh', '<C-w>h', { desc = 'Move to left window buffer' })
map('n', '<leader>sj', '<C-w>j', { desc = 'Move to bottom window buffer' })
map('n', '<leader>sk', '<C-w>k', { desc = 'Move to top window buffer' })
map('n', '<leader>sl', '<C-w>l', { desc = 'Move to right window buffer' })
map('n', '<leader>cw', ':close<cr>', { desc = 'Close window buffer' })
map('n', '<leader>se', '<C-w>=', { desc = 'Equalize window buffer sizes' })
map('n', '<leader>sm', '<C-W>_<cr><C-W>|', { desc = 'Maximize current window buffer' })
map('n', '<leader>ss', '<C-w>s', { desc = 'Split window buffer horizontally' })
map('n', '<leader>sv', '<C-w>v', { desc = 'Split window buffer vertically' })
map('n', '<M-h>', '<C-w>>5', { desc = 'Increase window buffer width' })
map('n', '<M-j>', '<C-w>-', { desc = 'Decrease window buffer height' })
map('n', '<M-k>', '<C-w>+', { desc = 'Increase window buffer height' })
map('n', '<M-l>', '<C-w><5', { desc = 'Decrease window buffer width' })
-- #endregion

-- #region: Buffer Navigation and Management
map('n', '<leader>cb', '<cmd>bdelete<cr>', { desc = 'Delete current buffer' })
map('n', '<leader>sn', '<cmd>bNext<cr>', { desc = 'Switch to next buffer' })
map('n', '<leader>sp', '<cmd>bprevious<cr>', { desc = 'Switch to previous buffer' })
-- #endregion

-- #region: Diagnostics and Quickfix
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>zz', { desc = 'Previous diagnostic' })
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>zz', { desc = 'Next diagnostic' })
map('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<cr>zz', { desc = 'Expand diagnostics' })
map('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<cr>zz', { desc = 'Open diagnostics quickfix list' })
map('n', '<M-n>', '<cmd>cnext<cr>', { desc = 'Next quickfix list item' })
map('n', '<M-p>', '<cmd>cprev<cr>', { desc = 'Previous quickfix list item' })
map('n', '<M-c>', '<cmd>cclose<cr>', { desc = 'Close quickfix list' })
-- #endregion

-- #region: Formatter Configuration

-- Used only when configurations cannot be set in `nvim-conform.lua`.
-- This allows to add a formatter configuration on the fly
map('n', '<leader>gf', function()
    local formatters = {
        ['[Formatter] Stylua'] = 'stylua.toml',
        ['[Linter] ESLINT'] = 'eslintrc.json',
    }

    vim.ui.select(vim.tbl_keys(formatters), {
        prompt = 'Select formatter: ',
        default = '[Formatter] Prettier',
    }, function(selected)
        local formatter = formatters[selected]
        if formatter == nil then
            print('List of formatters: ' .. vim.inspect(formatters))
            return
        end

        local formattersPath = os.getenv('HOME') .. '/.config/nvim/formatters'
        local formatterPath = formattersPath .. '/' .. formatter
        if vim.fn.filereadable(formatterPath) == 0 then
            print('Formatter configuration not found in -> ' .. formatterPath)
            return
        end

        local formatterFile = io.open(formatterPath, 'r')

        if formatterFile == nil then
            print('Failed to open formatter configuration -> ' .. formatterPath)
            return
        end

        local formatterContent = formatterFile:read('*a')
        formatterFile:close()

        local workspace = vim.fn.getcwd()
        local formatterDestFilePath = workspace .. '/.' .. formatter
        local formatterDestFile = io.open(formatterDestFilePath, 'w')

        if formatterDestFile == nil then
            print('Failed to open formatter configuration -> ' .. formatterDestFilePath)
            return
        end

        formatterDestFile:write(formatterContent)
        formatterDestFile:close()
    end)
end, { desc = "Fetch a formatter config from the formatter's directory" })
-- #endregion
