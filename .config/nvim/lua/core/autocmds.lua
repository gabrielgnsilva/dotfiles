local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd('FileType', {
    desc = 'Dont list quickfix buffers',
    pattern = 'qf',
    callback = function()
        vim.opt_local.buflisted = false
    end,
})

autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

autocmd({ 'termOpen' }, {
    desc = 'Disable line numbers on terminal',
    group = augroup('custom-term-open', { clear = true }),
    callback = function()
        vim.opt.number = false
        vim.opt.relativenumber = false
    end,
})

if vim.fn.has('wsl') == 1 then
    autocmd({ 'FocusGained' }, {
        desc = 'Sync with system clipboard on focus gained',
        pattern = { '*' },
        command = [[call setreg("@", getreg("+"))]],
    })
    autocmd({ 'FocusLost' }, {
        desc = 'Sync with system clipboard on focus lost',
        pattern = { '*' },
        command = [[call setreg("+", getreg("@"))]],
    })
end
