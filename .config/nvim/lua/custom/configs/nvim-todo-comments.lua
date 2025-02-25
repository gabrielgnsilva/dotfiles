require('todo-comments').setup({
    signs = false,
    keywords = {
        OK = { icon = ' ', color = 'hint', alt = { 'DONE' } },
        region = {
            icon = ' ',
            color = '#10B981',
            alt = {
                'REGION',
                '#REGION',
                '#region',
            },
        },
        section = {
            icon = ' ',
            color = '#B94F7E',
            alt = {
                'SECTION',
                '#SECTION',
                '#section',
            },
        },
    },
})
