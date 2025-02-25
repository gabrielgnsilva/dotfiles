require('gitsigns').setup({
    signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '│' },
    },
    on_attach = function(bufnr)
        require('core.utils').load_keymaps('gitsigns', { buffer = bufnr })
    end,
})
