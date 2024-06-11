--[[
    Modes:
    [n] Normal
    [i] Insert
    [v] Visual
    [x] Visual Line
]]

local k = vim.keymap.set

-- General keymaps
k('i', 'jj', '<esc>', { desc = 'Escape' })
k('n', '<leader><leader>', ':so<cr>', { desc = 'Source current file' })
k('n', 'Q', '<nop>', { desc = 'Do nothing (disable ex mode)' })
k('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Sort lines ascending or descending while preserving selection
k('x', '<leader>sa', ":'<,'>sort<cr>gv=gv", { desc = 'Sort lines ascending' })
k('x', '<leader>sd', ":'<,'>sort!<cr>gv=gv", { desc = 'Sort lines descending' })

-- Move lines with visual while preserving selection and autoindenting
k('v', 'J', ":move '>+1<cr>gv=gv", { desc = 'Move line down' })
k('v', 'K', ":move '<-2<cr>gv=gv", { desc = 'Move line up' })

-- Append line below or above to current line while preserving cursor position
k('n', 'J', 'mzJ`z', { desc = 'Append line below to current line' })
k('n', 'K', 'mz:move -2|j<cr>`z', { desc = 'Append line below to current line' })

-- Add a new line above or below the current line
k('n', '<leader>nj', 'o<Esc>"_D', { desc = 'Add new line below' })
k('n', '<leader>nk', 'O<Esc>"_D', { desc = 'Add new line above' })

-- Move page up or down while positioning the cursor on the center of the screen
k('n', '<C-n>', '<C-d>zz', { desc = 'Move page down' })
k('n', '<C-u>', '<C-u>zz', { desc = 'Move page up' })

-- When searching, center the screen on the current match
k('n', 'N', 'Nzzzv', { desc = 'Move to previous match' })
k('n', 'n', 'nzzzv', { desc = 'Move to next match' })

-- When deleting or pasting, don't copy the deleted text to the default register
k('n', '<leader>d', '"_d', { desc = 'Delete without copying' })
k('x', '<leader>d', '"_d', { desc = 'Delete without copying' })
k('x', '<leader>p', '"_dP', { desc = 'Paste without copying' })

-- Replace word under cursor
k('n', '<leader>rw', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Replace word under cursor' })

-- Make current file executable
k('n', '<leader>x', function()
    vim.ui.input({ prompt = 'chmod +x <file>? [y/N] ' }, function(input)
        if input ~= nil and input:lower() == 'y' then
            vim.cmd('!chmod +x %')
        end
    end)
end, { silent = true, desc = 'Make current file executable' })

-- Split window buffer navigation
k('n', '<leader>sh', '<C-w>h', { desc = 'Move to left window buffer' })
k('n', '<leader>sj', '<C-w>j', { desc = 'Move to bottom window buffer' })
k('n', '<leader>sk', '<C-w>k', { desc = 'Move to top window buffer' })
k('n', '<leader>sl', '<C-w>l', { desc = 'Move to right window buffer' })

-- Split window buffer management
k('n', '<leader>cw', ':close<cr>', { desc = 'Close window buffer' })
k('n', '<leader>se', '<C-w>=', { desc = 'Equalize window buffer sizes' })
k('n', '<leader>ss', '<C-w>s', { desc = 'Split window buffer horizontally' })
k('n', '<leader>sv', '<C-w>v', { desc = 'Split window buffer vertically' })

-- Split window buffer resizing
k('n', '<M-h>', '<C-w>>5', { desc = 'Increase window buffer width' })
k('n', '<M-j>', '<C-w>-', { desc = 'Decrease window buffer height' })
k('n', '<M-k>', '<C-w>+', { desc = 'Increase window buffer height' })
k('n', '<M-l>', '<C-w><5', { desc = 'Decrease window buffer width' })

-- TODO: Buffer Management
-- TODO: Buffer Navigation

-- Diagnostics
k('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>zz', { desc = 'Previous diagnostic' })
k('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>zz', { desc = 'Next diagnostic' })
k('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<cr>zz', { desc = 'Expand diagnostics' })
k('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<cr>zz', { desc = 'Open diagnostics quickfix list' })

-- Formatter (Used only when configurations cannot be set in nvim-conform.lua)
-- This allows to add a formatter configuration on the fly
k('n', '<leader>gf', function()
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
end, { desc = 'Format current buffer with formatter' })

vim.keymap.set('n', '@', function()
    local count = vim.v.count1
    local register = vim.fn.getcharstr()
    vim.opt.lazyredraw = true
    vim.cmd(string.format('noautocmd norm! %d@%s', count, register))
    vim.opt.lazyredraw = false
end, { noremap = true })
