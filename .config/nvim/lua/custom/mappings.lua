local M = {}

M.dap = {
    {
        mode = { 'n' },
        bindings = {
            ['<leader>bp'] = { '<cmd>DapToggleBreakpoint<cr>', 'Add breakpoint to the current line' },
            ['<leader>dr'] = { '<cmd>DapContinue<cr>', 'Run or continue the debugger' },
        },
    },
}

M['todo-comments'] = {
    {
        mode = { 'n' },
        bindings = {
            [']c'] = {
                function()
                    require('todo-comments').jump_next()
                end,
                'Todo Commetns Next comment',
            },
            ['[c'] = {
                function()
                    require('todo-comments').jump_prev()
                end,
                'Todo Comments Previous comment',
            },
        },
    },
}

M.noice = {
    {
        mode = { 'n' },
        bindings = {
            ['<leader>cm'] = { '<cmd>NoiceDismiss<cr>', 'Dismiss noice message' },
        },
    },
}

M.tmux = {
    {
        mode = { 'n' },
        bindings = {
            ['<C-h>'] = { '<cmd>TmuxNavigateLeft<cr>', 'TMUX navigate to left window' },
            ['<C-l>'] = { '<cmd>TmuxNavigateRight<cr>', 'TMUX navigate to right window' },
            ['<C-j>'] = { '<cmd>TmuxNavigateDown<cr>', 'TMUX navigate to bottom window' },
            ['<C-k>'] = { '<cmd>TmuxNavigateUp<cr>', 'TMUX navigate to top window' },
        },
    },
}

M.telescope = function()
    local builtin = require('telescope.builtin')
    local extensions = require('telescope').extensions

    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local make_entry = require('telescope.make_entry')
    local conf = require('telescope.config').values

    local multi_grep = function(opts)
        opts = opts or {}
        opts.cwd = opts.cwd or vim.uv.cwd()
        local finder = finders.new_async_job({
            command_generator = function(prompt)
                if not prompt or prompt == '' then
                    return nil
                end

                local pieces = vim.split(prompt, '  ')
                local args = { 'rg' }
                if pieces[1] then
                    table.insert(args, '-e')
                    table.insert(args, pieces[1])
                end
                if pieces[2] then
                    table.insert(args, '-g')
                    table.insert(args, pieces[2])
                end

                return vim.tbl_flatten({
                    args,
                    {
                        '--color=never',
                        '--no-heading',
                        '--with-filename',
                        '--line-number',
                        '--column',
                        '--smart-case',
                    },
                })
            end,
            entry_maker = make_entry.gen_from_vimgrep(opts),
            cwd = opts.cwd,
        })

        pickers
            .new(opts, {
                debounce = 100,
                prompt_title = 'Multi Grep',
                finder = finder,
                previewer = conf.grep_previewer(opts),
                sorter = require('telescope.sorters').empty(),
            })
            :find()
    end

    local current_buffer_fzf = function()
        builtin.current_buffer_fuzzy_find()
    end

    local find_files = function()
        builtin.find_files({ cwd = vim.fn.stdpath('config') })
    end

    return {
        {
            mode = { 'n' },
            bindings = {
                ['<leader>fh'] = { builtin.help_tags, 'Telescope fuzzy find help tag' },
                ['<leader>fd'] = { builtin.diagnostics, 'Telescope fuzzy find files on cwd' },
                ['<leader>fb'] = { builtin.buffers, 'Telescope fuzzy find curenltly open buffers' },
                ['<leader>ff'] = { builtin.find_files, 'Telescope fuzzy find files on cwd' },
                ['<leader>fg'] = { builtin.git_files, 'Telescope fuzzy find git files on cwd' },
                ['<leader>fr'] = { builtin.oldfiles, 'Telescope fuzzy find recend files' },
                ['<leader>fu'] = { extensions.undo.undo, 'Telescope fuzzy find undo history on cwd' },
                ['<leader>fs'] = { multi_grep, 'Telescope fuzzy find string on worktree' },
                ['<leader>f/'] = { current_buffer_fzf, 'Telescope fuzzy find string on current buffer' },
                ['<leader>fn'] = { find_files, 'Telescope fuzzy find neovim config files' },
            },
        },
    }
end

M.lint = {
    {
        mode = { 'n' },
        bindings = {
            ['<leader>l'] = {
                function()
                    require('lint').try_lint()
                end,
                'Trigger linting on current buffer',
            },
        },
    },
}

M.gitblame = {
    {
        mode = { 'n' },
        bindings = {
            ['<leader>gb'] = {
                function()
                    require('gitblame').toggle()
                end,
                'GIT Blame toggle',
            },
        },
    },
}

M.flash = function()
    local flash = require('flash')
    return {
        {
            mode = { 'n', 'x', 'o' },
            bindings = {
                ['<leader>/'] = { flash.jump, 'Flash' },
                -- ['S'] = { flash.treesitter, 'Flash Treesitter' },
            },
        },
        -- {
        --     mode = { 'o', 'x' },
        --     bindings = {
        --         ['R'] = { flash.treesitter_search, 'Treesitter Search' },
        --     },
        -- },
        -- {
        --     mode = { 'o' },
        --     bindings = {
        --         ['<c-s>'] = { flash.toggle, 'Toggle Flash Search' },
        --     },
        -- },
        -- {
        --     mode = { 'c' },
        --     bindings = {
        --         ['<c-s>'] = { flash.toggle, 'Toggle Flash Search' },
        --     },
        -- },
    }
end

M.harpoon = function()
    local harpoon = require('harpoon')
    local toggle_telescope = function(harpoon_files)
        local conf = require('telescope.config').values
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
            table.insert(file_paths, item.value)
        end
        require('telescope.pickers')
            .new({}, {
                prompt_title = 'Harpoon',
                finder = require('telescope.finders').new_table({ results = file_paths }),
                previewer = conf.file_previewer({}),
                sorter = conf.generic_sorter({}),
            })
            :find()
    end

    return {
        {
            mode = { 'n' },
            bindings = {
                ['<C-e>'] = {
                    function()
                        toggle_telescope(harpoon:list())
                    end,
                    'Harpoon toggle harpoon menu',
                },
                ['<leader>ah'] = {
                    function()
                        harpoon:list():add()
                    end,
                    'Harpoon add file to harpoon',
                },
                ['<leader>rh'] = {
                    function()
                        harpoon:list():remove()
                    end,
                    'Harpoon remove file to harpoon',
                },
                ['<leader>nh'] = {
                    function()
                        harpoon:list():next()
                    end,
                    'Harpoon select next harpoon file',
                },
                ['<leader>ph'] = {
                    function()
                        harpoon:list():prev()
                    end,
                    'Harpoon select prev harpoon file',
                },
            },
        },
    }
end

M.gitsigns = function()
    local gs = package.loaded.gitsigns
    return {
        {
            mode = { 'n' },
            bindings = {
                ['<leader>rh'] = { gs.reset_hunk, 'Reset Hunk' },
                ['<leader>ph'] = { gs.preview_hunk, 'Preview Hunk' },
                ['<leader>gb'] = { gs.blame_line, 'Blame Line' },
            },
        },
    }
end

M.cmp = function()
    local luasnip = require('luasnip')
    return {
        {
            mode = { 'i', 's' },
            bindings = {
                ['<C-j>'] = {
                    function()
                        if luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end,
                    {
                        desc = 'LuaSnip next jump',
                        silent = true,
                    },
                },
                ['<C-k>'] = {
                    function()
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end,
                    {
                        desc = 'LuaSnip prev jump',
                        silent = true,
                    },
                },
            },
        },
        {
            mode = { 'n' },
            bindings = {
                ['<leader><leader>s'] = {
                    function()
                        require('luasnip.loaders.from_lua').load({
                            paths = vim.fn.stdpath('config') .. '/lua/gns/snippets',
                        })
                    end,
                    'LuaSnip source snippets',
                },
            },
        },
        {
            mode = { 'i' },
            bindings = {
                ['<C-i>'] = {
                    function()
                        if luasnip.choice_active() then
                            luasnip.change_choice(1)
                        end
                    end,
                    'LuaSnip next choice',
                },
                ['<C-l>'] = {
                    function()
                        if luasnip.choice_active() then
                            luasnip.change_choice(-1)
                        end
                    end,
                    'LuaSnip prev choice',
                },
            },
        },
    }
end

M.conform = {
    {
        mode = { 'n', 'v', 'x' },
        bindings = {
            ['<leader>mp'] = {
                function()
                    require('conform').format()
                end,
                'Format current buffer with Conform',
            },
        },
    },
}

M.treesj = {
    {
        mode = { 'n' },
        bindings = {
            ['<Tab>'] = { '<cmd>TSJToggle<cr>', 'TreeSJ toggle block splitting' },
        },
    },
}

M['vim-fugitive'] = {
    {
        mode = { 'n' },
        bindings = {
            ['<leader>gs'] = { vim.cmd.Git, 'Fugitive Show git status' },
        },
    },
}

M['vim-commentary'] = {
    {
        mode = { 'n', 'v' },
        bindings = {
            ['<C-c>'] = { ':Commentary<cr>', 'Toggle comment' },
        },
    },
}

M['oil-nvim'] = {
    {
        mode = { 'n' },
        bindings = {
            ['-'] = { '<cmd>Oil<cr>', 'Open parent directory' },
        },
    },
}

M.copilot = {
    {
        mode = { 'n' },
        bindings = {
            ['<leader>cpd'] = { '<cmd>Copilot disable<cr>', { desc = 'Disable Copilot', silent = true } },
            ['<leader>cpe'] = { '<cmd>Copilot enable<cr>', { desc = 'Enable Copilot', silent = true } },
        },
    },
}

return M
