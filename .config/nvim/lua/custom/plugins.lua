--[[
    BufNewFile                   Starting to edit a non-existent file
    BufReadPre    BufReadPost    Before and after editing an existing file

    SEE: https://neovim.io/doc/user/autocmd.html#autocmd-events

    VeryLazy    You can use this event for things that can load later
                and are not important for the initial UI
]]

local plugins = {
    -- #region: Always loads
    {
        'joshdick/onedark.vim',
        lazy = false, -- Theme
        priority = 1000,
        config = function()
            require('custom.configs.theme')
        end,
    },
    {
        'goolord/alpha-nvim',
        lazy = false, -- Greeter
        config = function()
            require('custom.configs.nvim-alpha')
        end,
    },
    {
        'LunarVim/bigfile.nvim',
        lazy = false, --[[
            Disable some features on big files for better performance
                indent_blankline
                illuminate
                lsp
                treesitter
                syntax
                matchparen
                vimopts
                filetype
        ]]
    },
    {
        'nvim-tree/nvim-tree.lua',
        lazy = false, -- File tree navigator
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('custom.configs.nvim-tree')
        end,
    },
    {
        'christoomey/vim-tmux-navigator',
        lazy = false, -- I'm always using TMUX
        config = function()
            require('core.utils').load_keymaps('tmux')
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        lazy = false, -- Should always load at startup
        dependencies = {
            'folke/noice.nvim',
            'nvim-tree/nvim-web-devicons',
            'linrongbin16/lsp-progress.nvim',
        },
        config = function()
            require('custom.configs.lualine')
        end,
    },
    {
        'stevearc/dressing.nvim',
        lazy = false, -- Should always load at startup
    },
    {
        'mrcjkb/rustaceanvim',
        lazy = false, -- This plugin is already lazy
        version = '^5',
    },
    -- {
    --     'stevearc/oil.nvim',
    --     lazy = false, -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    --     dependencies = { 'nvim-tree/nvim-web-devicons' },
    --     config = function()
    --         require('custom.configs.oil-nvim')
    --         require('core.utils').load_keymaps('oil-nvim')
    --     end,
    -- },
    -- -- #endregion

    -- #region: Triggered by a command
    {
        'michaelrommel/nvim-silicon',
        lazy = true, -- Only needed when capturing screenshots
        cmd = 'Silicon',
        config = function()
            require('custom.configs.nvim-silicon')
        end,
    },
    {
        'williamboman/mason.nvim',
        cmd = { 'Mason', 'MasonInstall', 'MasonInstallAll', 'MasonUpdate' },
        config = function()
            require('custom.configs.mason')
        end,
    },
    {
        'folke/trouble.nvim',
        opts = {},
        cmd = 'Trouble',
        -- stylua: ignore
        keys = {
            { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
            { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)', },
            { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
            { '<leader>xl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP Definitions / references / ... (Trouble)', },
            { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
            { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
        },
    },
    -- #endregion

    -- #region: Triggered by a key
    {
        'Wansmer/treesj',
        keys = { '<Tab>' },
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            require('custom.configs.treesj')
            require('core.utils').load_keymaps('treesj')
        end,
    },
    -- #endregion

    -- #region: Triggered by an event
    {
        'ThePrimeagen/harpoon',
        event = { 'BufNewFile', 'BufReadPost' },
        dependencies = { 'nvim-lua/plenary.nvim' },
        branch = 'harpoon2',
        config = function()
            require('custom.configs.nvim-harpoon')
            require('core.utils').load_keymaps('harpoon')
        end,
    },
    {
        'saecki/crates.nvim',
        event = { 'BufRead Cargo.toml' },
    },
    {
        'nvim-treesitter/nvim-treesitter',
        event = { 'BufReadPost', 'BufNewFile' },
        dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
        build = ':TSUpdate',
        config = function()
            require('custom.configs.nvim-treesitter')
        end,
    },
    {
        'kylechui/nvim-surround',
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            require('custom.configs.nvim-surround')
        end,
    },
    {
        'mfussenegger/nvim-lint',
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            require('custom.configs.nvim-lint')
            require('core.utils').load_keymaps('lint')
        end,
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        main = 'ibl',
        config = function()
            require('custom.configs.indent-blankline')
        end,
    },
    {
        'brenoprata10/nvim-highlight-colors',
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            require('custom.configs.nvim-highlight-colors')
        end,
    },
    {
        'lewis6991/gitsigns.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            require('custom.configs.gitsigns')
        end,
    },
    {
        'f-person/git-blame.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            require('custom.configs.git-blame')
            require('core.utils').load_keymaps('gitblame')
        end,
    },
    {
        'folke/flash.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            require('core.utils').load_keymaps('flash')
        end,
    },
    {
        'stevearc/conform.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            require('custom.configs.nvim-conform')
            require('core.utils').load_keymaps('conform')
        end,
    },
    {
        'windwp/nvim-autopairs',
        event = { 'InsertEnter' },
        config = function()
            require('custom.configs.nvim-autopairs')
        end,
    },
    {
        'L3MON4D3/LuaSnip',
        event = { 'InsertEnter' },
        build = 'make install_jsregexp',
        config = function()
            require('custom.configs.luaSnip')
        end,
    },
    {
        'hrsh7th/nvim-cmp',
        event = { 'InsertEnter' },
        dependencies = {
            'windwp/nvim-autopairs',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'onsails/lspkind.nvim',
        },
        config = function()
            require('custom.configs.nvim-cmp')
            require('core.utils').load_keymaps('cmp')
        end,
    },
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPost', 'BufNewFile' },
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'hrsh7th/cmp-nvim-lsp',
            'nvim-telescope/telescope.nvim',
        },
        cmd = { 'LspInstallAll' },
        config = function()
            require('custom.configs.lspconfig')
        end,
    },
    {
        'windwp/nvim-ts-autotag',
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            require('custom.configs.nvim-ts-autotag')
        end,
    },
    -- #endregion

    -- #region: VeryLazy
    {
        'github/copilot.vim',
        event = 'VeryLazy',
        build = ':Copilot setup',
        config = function()
            require('core.utils').load_keymaps('copilot')
        end,
    },
    {
        'tpope/vim-sleuth',
        event = 'VeryLazy',
    },
    {
        'tpope/vim-fugitive',
        event = 'VeryLazy',
        config = function()
            require('core.utils').load_keymaps('vim-fugitive')
        end,
    },
    {
        'tpope/vim-commentary',
        event = 'VeryLazy',
        config = function()
            require('core.utils').load_keymaps('vim-commentary')
        end,
    },
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
    },
    {
        'folke/todo-comments.nvim',
        event = 'VeryLazy',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('custom.configs.nvim-todo-comments')
            require('core.utils').load_keymaps('todo-comments')
        end,
    },
    {
        'nvim-telescope/telescope.nvim',
        event = 'VeryLazy',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'debugloop/telescope-undo.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            { 'nvim-tree/nvim-web-devicons' },
        },
        config = function()
            require('custom.configs.nvim-telescope')
            require('core.utils').load_keymaps('telescope')
        end,
    },
    {
        'folke/noice.nvim',
        event = 'VeryLazy',
        dependencies = {
            'MunifTanjim/nui.nvim',
            'rcarriga/nvim-notify',
            'hrsh7th/nvim-cmp',
        },
        config = function()
            require('custom.configs.nvim-noice')
            require('core.utils').load_keymaps('noice')
        end,
    },
    -- #endregion

    -- #region: Load by filetype
    {
        'mfussenegger/nvim-dap',
        ft = { 'javascript', 'python', 'typescript', 'rust', 'go', 'cpp' },
        dependencies = { 'williamboman/mason.nvim' },
        config = function()
            require('custom.configs.nvim-dap')
            require('core.utils').load_keymaps('dap')
        end,
    },
    {
        'rcarriga/nvim-dap-ui',
        ft = { 'javascript', 'python', 'typescript', 'rust', 'go', 'cpp' },
        dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
        config = function()
            require('custom.configs.nvim-dap-ui')
        end,
    },
    {
        'olexsmir/gopher.nvim',
        ft = 'go',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
        },
        build = function()
            vim.cmd([[silent! GoInstallDeps]])
        end,
    },
    {
        lazy = false,
        'mzlogin/vim-markdown-toc',
        ft = { 'md' },
    },
    -- #endregion
}

return plugins
