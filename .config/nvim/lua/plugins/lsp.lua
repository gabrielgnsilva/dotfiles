return {
    event = "VeryLazy",

    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "L3MON4D3/LuaSnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local mason = require("mason")
        local mason_config = require("mason-lspconfig")
        local cmp = require("cmp")
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        local lspconfig = require("lspconfig")
        local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
        local lsp_attach = function(client)
            local opt = { buffer = client.buf, remap = false }
            -- Keymaps
            vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opt)
            vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opt)
            vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opt)
            vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opt)
            vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opt)
            vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opt)
            vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opt)
            vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opt)
            vim.keymap.set('n', '<F3>',
                '<cmd>lua vim.lsp.buf.format({ async = false, tabSize = 4, insertSpaces = true, trimTrailingWhitespace = true, trimFinalNewlines = true, insertFinalNewline = true })<cr>',
                opt)
            vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opt)
        end

        -- Diagnostics are not exclusive to lsp servers
        -- so these can be global keybindings
        vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
        vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
        vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

        require("fidget").setup()

        mason.setup({})

        mason_config.setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "eslint",
                "cssls",
                "html",
                "tsserver",
                "bashls",
                "jsonls",
            },

            handlers = {
                function(server_name)
                    lspconfig[server_name].setup({
                        on_attach = lsp_attach,
                        capabilities = lsp_capabilities,
                    })
                end,
                ["lua_ls"] = function()
                    lspconfig.lua_ls.setup {
                        on_attach = lsp_attach,
                        capabilities = lsp_capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim" },
                                }
                            }
                        }
                    }
                end
            }
        })

        cmp.setup({
            sources = {
                { name = "nvim_lsp" }
            },

            mapping = cmp.mapping.preset.insert({
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
            }),

            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end
            }
        })
    end
}
