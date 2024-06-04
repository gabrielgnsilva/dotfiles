--[[
    Parser.
]]

return {
    event = {
        'BufReadPost', -- Starting to edit an existing file
        'BufNewFile', -- Starting to edit a non-existent file
    },

    'nvim-treesitter/nvim-treesitter',
    dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
    },

    build = ':TSUpdate',

    opts = {
        auto_install = true,

        highlight = {
            enable = true,
            disable = {}, -- List of languages that will be disabled
            use_languagetree = true,
        },

        indent = {
            enable = true,
        },

        autotag = {
            enable = true,
        },

        ensure_installed = {
            'bash',
            'c',
            'css',
            'gitignore',
            'html',
            'javascript',
            'json',
            'jsonc',
            'lua',
            'markdown',
            'markdown_inline',
            'properties',
            'python',
            'query',
            'toml',
            'vim',
            'vimdoc',
            'yaml',
        },
    },

    config = function(_, opts)
        require('nvim-treesitter.configs').setup(opts)
    end,
}
