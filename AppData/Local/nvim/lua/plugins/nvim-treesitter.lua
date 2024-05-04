--[[
    Parser.
]]

return {
    event = 'VeryLazy',

    'nvim-treesitter/nvim-treesitter',
    dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
    },

    build = ':TSUpdate',

    opts = {
        highlight = {
            enable = true,
            disable = {}, -- List of languages that will be disabled
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
        auto_install = true,
    },
    config = function(_, opts)
        require('nvim-treesitter.configs').setup(opts)
    end,
}
