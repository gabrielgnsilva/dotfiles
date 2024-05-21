--[[
    Modes:
    [n] Normal
    [i] Insert
    [v] Visual
    [x] Visual Line
]]

local keymap = vim.keymap

-- General keymaps
keymap.set('i', 'jj', '<esc>', { desc = 'Escape' })
keymap.set('n', 'Q', '<nop>', { desc = 'Do nothing (disable ex mode)' })

-- Sort lines ascending or descending while preserving selection
keymap.set('x', '<leader>sa', ":'<,'>sort<cr>gv=gv", { desc = 'Sort lines ascending' })
keymap.set('x', '<leader>sd', ":'<,'>sort!<cr>gv=gv", { desc = 'Sort lines descending' })

-- Move lines with visual while preserving selection and autoindenting
keymap.set('v', 'K', ":move '<-2<cr>gv=gv", { desc = 'Move line up' })
keymap.set('v', 'J', ":move '>+1<cr>gv=gv", { desc = 'Move line down' })

-- Append line below or above to current line while preserving cursor position
keymap.set('n', 'J', 'mzJ`z', { desc = 'Append line below to current line' })
keymap.set('n', 'K', 'mz:move -2|j<cr>`z', { desc = 'Append line below to current line' })

-- Add a new line above or below the current line
keymap.set('n', '<leader>nj', 'o<Esc>"_D', { desc = 'Add new line below' })
keymap.set('n', '<leader>nk', 'O<Esc>"_D', { desc = 'Add new line above' })

-- Move page up or down while positioning the cursor on the center of the screen
keymap.set('n', '<C-n>', '<C-d>zz', { desc = 'Move page down' })
keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Move page up' })

-- When searching, center the screen on the current match
keymap.set('n', 'n', 'nzzzv', { desc = 'Move to next match' })
keymap.set('n', 'N', 'Nzzzv', { desc = 'Move to previous match' })

-- When deleting or pasting, don't copy the deleted text to the default register
keymap.set('x', '<leader>p', '"_dP', { desc = 'Paste without copying' })
keymap.set('n', '<leader>d', '"_d', { desc = 'Delete without copying' })
keymap.set('x', '<leader>d', '"_d', { desc = 'Delete without copying' })

-- Replace word under cursor
keymap.set(
    'n',
    '<leader>rw',
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = 'Replace word under cursor' }
)

-- Make current file executable
keymap.set('n', '<leader>x', function()
    vim.ui.input({ prompt = 'chmod +x <file>? [y/N] ' }, function(input)
        if input ~= nil and input:lower() == 'y' then
            vim.cmd('!chmod +x %')
        end
    end)
end, { silent = true, desc = 'Make current file executable' })

-- Source current file
keymap.set('n', '<leader><leader>', ':so<cr>', { desc = 'Source current file' })

-- Split window navigation
keymap.set('n', '<leader>sh', '<C-w>h', { desc = 'Move to left window' })
keymap.set('n', '<leader>sj', '<C-w>j', { desc = 'Move to bottom window' })
keymap.set('n', '<leader>sk', '<C-w>k', { desc = 'Move to top window' })
keymap.set('n', '<leader>sl', '<C-w>l', { desc = 'Move to right window' })

-- Split window management
keymap.set('n', '<leader>sv', '<C-w>v', { desc = 'Split window vertically' })
keymap.set('n', '<leader>ss', '<C-w>s', { desc = 'Split window horizontally' })
keymap.set('n', '<leader>se', '<C-w>=', { desc = 'Equalize window sizes' })
keymap.set('n', '<leader>cw', ':close<cr>', { desc = 'Close window' })

-- Split window resizing
keymap.set('n', '<M-k>', '<C-w>+', { desc = 'Increase window height' })
keymap.set('n', '<M-j>', '<C-w>-', { desc = 'Decrease window height' })
keymap.set('n', '<M-l>', '<C-w><5', { desc = 'Decrease window width' })
keymap.set('n', '<M-h>', '<C-w>>5', { desc = 'Increase window width' })

-- Buffer navigation
-- TODO

-- Buffer management
-- TODO

-- Diagnostics
keymap.set('n', 'gl', ':lua vim.diagnostic.open_float()<cr>zz', { desc = 'Open diagnostics' })
keymap.set('n', '[d', ':lua vim.diagnostic.goto_prev()<cr>zz', { desc = 'Go to previous diagnostic' })
keymap.set('n', ']d', ':lua vim.diagnostic.goto_next()<cr>zz', { desc = 'Go to next diagnostic' })

-- Nvim-tree
keymap.set('n', '<C-d>', ':NvimTreeToggle<cr>', { desc = 'Toggle Nvim-tree' })

-- Telescope
keymap.set('n', '<leader>fr', ':Telescope oldfiles<cr>', { desc = 'Fuzzy find recend files' })
keymap.set('n', '<leader>ff', ':Telescope find_files<cr>', { desc = 'Fuzzy find files on cwd' })
keymap.set('n', '<leader>fu', ':Telescope undo<cr>', { desc = 'Fuzzy find undo history on cwd' })
keymap.set('n', '<leader>fs', function()
    require('telescope.builtin').grep_string({
        search = vim.fn.input('Grep > '),
    })
end, { desc = 'Fuzzy find string in files on cwd' })
keymap.set('n', '<C-g>', ':Telescope git_files<cr>', { desc = 'Fuzzy find git files on cwd' })

-- Git-blame
keymap.set('n', '<leader>gb', ':GitBlameToggle<cr>', { desc = 'Toggle git-blame' })

-- Vim commentary
keymap.set('n', '<C-c>', ':Commentary<cr>', { desc = 'Comment line' })
keymap.set('v', '<C-c>', ':Commentary<cr>', { desc = 'Comment selection' })

-- TreeSJ
keymap.set('n', '<C-i>', ':TSJToggle<cr>', { desc = 'Toggle block splitting' })

-- Formatting
keymap.set({ 'n', 'v', 'x' }, '<leader>mp', function()
    require('conform').format()
end, { desc = 'Format current buffer' })

-- Linting
keymap.set('n', '<leader>l', '<cmd>lua require("lint").try_lint()<CR>', { desc = 'Trigger linting on current buffer' })

-- LuaSnip
keymap.set({ 'i', 's' }, '<C-l>', function()
    if require('luasnip').choice_active() then
        require('luasnip').change_choice(1)
    end
end)

keymap.set({ 'i', 's' }, '<C-j>', function()
    if require('luasnip').jumpable(1) then
        require('luasnip').jump(1)
    end
end, { silent = true })

keymap.set({ 'i', 's' }, '<C-k>', function()
    if require('luasnip').jumpable(-1) then
        require('luasnip').jump(-1)
    end
end, { silent = true })

keymap.set('n', '<leader><leader>s', function()
    require('luasnip.loaders.from_lua').load({ paths = vim.fn.stdpath('config') .. '/lua/snippets' })
end, { desc = 'Source snippets from luaSnip' })

-- Formatter (Used only when configurations cannot be set in nvim-conform.lua)
-- This allows to add a formatter configuration on the fly
keymap.set('n', '<leader>gf', function()
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
