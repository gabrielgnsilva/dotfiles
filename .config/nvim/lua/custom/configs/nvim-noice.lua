local filters = {
    {
        filter = { event = 'msg_showmode' },
        view = 'mini',
    },
    {
        filter = { event = 'notify', min_height = 15 },
        view = 'split',
    },
    {
        filter = {
            event = 'notify',
            cond = function(msg)
                local title = msg.title or msg.opts and msg.opts.title or ''
                return vim.tbl_contains({ 'mason' }, title)
            end,
        },
        view = 'mini',
    },
    {
        filter = {
            event = 'notify',
            kind = { 'debug', 'trace' },
        },
        opts = { timeout = 5000 },
        view = 'mini',
    },
    {
        filter = {
            min_height = 10,
            ['not'] = { event = 'lsp' },
            kind = { 'error' },
        },
        view = 'split',
    },
    {
        filter = {
            event = 'msg_show',
            any = {
                { find = '%d+L, %d+B' },
                { find = '; after #%d+' },
                { find = '; before #%d+' },
                { find = '%d+ fewer lines' },
                { find = '%d+ lines changed' },
                { find = '%d+ more lines' },
                { find = '%d+ lines yanked' },
                { find = 'search hit %a+, continuing at %a+' },
                { find = '%d+ lines <ed %d+ time' },
                { find = '%d+ lines >ed %d+ time' },
                { find = '%d+ substitutions on %d+ lines' },
                { find = 'Hunk %d+ of %d+' },
                { find = '%-%-No lines in buffer%-%-' },
                { find = '^E486: Pattern not found' },
                { find = '^Word .*%.add$' },
                { find = '^E486' },
                { find = '^E42' },
                { find = '^E776' },
                { find = '^E348' },
                { find = '^W325' },
                { find = '^E1513' },
                { find = '^E553' },
                { find = 'E211: File .* no longer available' },
                { find = 'No more valid diagnostics to move to' },
                { find = 'No code actions available' },
                { find = '^[/?].' }, -- search patterns
                { find = '^%s*at process.processTicksAndRejections%s*' }, -- broken LSP some times
            },
        },
        opts = { skip = true },
    },
    {
        filter = {
            event = 'notify',
            kind = 'info',
            any = {
                { find = 'clipboard' },
                { find = 'hidden' },
                { find = 'Deleted' },
                { find = 'removed.' },
                { find = 'created' },
                { find = 'Renamed' },
                { find = 'No information available' },
                { find = 'Plugin Updates' },
            },
        },
        opts = { skip = true },
    },
    {
        filter = { event = 'msg_show', kind = 'search_count' },
        opts = { skip = true },
    },
    {
        filter = { event = 'msg_show', kind = '' },
        opts = { skip = true },
    },
    {
        filter = {
            kind = 'error',
            find = '%s*at process.processTicksAndRejections', -- broken LSP some times
        },
        opts = { skip = true },
    },
}

local views = {
    mini = {
        timeout = 3000,
        zindex = 10,
        position = { col = -3 },
        format = { '{title} ', '{message}' },
    },
    hover = {
        border = { style = vim.g.borde_style },
        size = { max_width = 80 },
        win_options = { scrolloff = 4, wrap = true },
    },
    popup = {
        border = { style = vim.g.borde_style },
        size = { width = 90, height = 25 },
        win_options = { scrolloff = 8, wrap = true, concealcursor = 'nv' },
        close = { keys = { 'q' } },
        enter = true,
    },
    split = {
        enter = true,
        size = '50%',
        win_options = { scrolloff = 6 },
        close = { keys = { 'q' } },
    },
}

require('noice').setup({
    presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = false, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
    },
    cmdline = { view = 'cmdline' },
    routes = filters,
    views = views,
    lsp = {
        progress = { enabled = true },
        override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
        },
    },
    keys = {
        {
            '<S-Enter>',
            function()
                require('noice').redirect(vim.fn.getcmdline())
            end,
            mode = 'c',
            desc = 'Redirect cmdline',
        },
        {
            '<c-f>',
            function()
                if not require('noice.lsp').scroll(4) then
                    return '<c-f>'
                end
            end,
            silent = true,
            expr = true,
            desc = 'Scroll forward',
            mode = { 'i', 'n', 's' },
        },
        {
            '<c-b>',
            function()
                if not require('noice.lsp').scroll(-4) then
                    return '<c-b>'
                end
            end,
            silent = true,
            expr = true,
            desc = 'Scroll backward',
            mode = { 'i', 'n', 's' },
        },
    },
})
