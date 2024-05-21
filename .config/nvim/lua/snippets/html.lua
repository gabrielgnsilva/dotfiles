local ls = require('luasnip')
local fmt = require('luasnip.extras.fmt').fmt
local same = require('luasnip.extras').rep
local d = ls.dynamic_node
local f = ls.function_node
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node

return {
    -- General

    -- Fluig
    s(
        'dataset',
        fmt(
            [[
                <!-- ACESSO A DATASETS POR MEIO DA BIBLIOTECA vcXMLRPC.js -->
                <script type="text/javascript" src="/webdesk/vcXMLRPC.js"></script>
            ]],
            {}
        )
    ),
}
