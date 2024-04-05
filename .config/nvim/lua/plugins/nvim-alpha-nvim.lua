--[[
    Welcome message for Neovim.
]]

return {
    'goolord/alpha-nvim',

    config = function()
        local alpha = require('alpha')
        local dashboard = require('alpha.themes.dashboard')

        -- Header
        dashboard.section.header.val = {
            '                                                     ',
            '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
            '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
            '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
            '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
            '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
            '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
            '                                                     ',
        }

        -- Menu
        dashboard.section.buttons.val = {
            dashboard.button(
                'e',
                'ICON > New file',
                ':ene <BAR> startinsert <CR>'
            ),
            dashboard.button(
                'f',
                'ICON > Find file',
                ':cd $HOME | Telescope find_files<CR>'
            ),
            dashboard.button('r', 'ICON > Recent', ':Telescope oldfiles<CR>'),
            dashboard.button(
                's',
                'ICON > Settings',
                ':e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>'
            ),
            dashboard.button('p', 'ICON > Plugins', ':Lazy<CR>'),
            dashboard.button('q', 'ICON > Quit', ':qa<CR>'),
        }

        -- Footer
        dashboard.section.footer.val = require('alpha.fortune')()

        -- Config alpha
        alpha.setup(dashboard.opts)

        -- Disable folding on alpha buffer
        vim.cmd([[
            autocmd FileType alpha setlocal nofoldenable
        ]])
    end,
}
