local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- dont list quickfix buffers
autocmd('FileType', {
    pattern = 'qf',
    callback = function()
        vim.opt_local.buflisted = false
    end,
})

autocmd({ 'bufEnter', 'bufWritePost', 'insertLeave' }, {
    group = augroup('lint', { clear = true }),
    callback = function()
        require('lint').try_lint()
    end,
})

autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
