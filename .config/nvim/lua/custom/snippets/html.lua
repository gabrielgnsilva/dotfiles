local ls = require('luasnip')
local fmt = require('luasnip.extras.fmt').fmt
local same = require('luasnip.extras').rep
local sn = ls.sn
local d = ls.dynamic_node
local f = ls.function_node
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node

local snip = require('core.utils').luasnip

return {
    -- General
    s('doctype', fmt([[<!doctype html>]], {})),
    s(
        'html',
        fmt(
            [[
                <!doctype html>
                <html lang="en">
                    <head>
                        <meta charset="UTF-8" />
                        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                        <title>{}</title>
                    </head>
                    <body>
                        {}
                    </body>
                </html>
            ]],
            {
                i(1, 'Document'),
                i(0, '<p>content</p>'),
            }
        )
    ),

    -- Fluig
    s('fluig-libraries', fmt(snip.FLUIG.libraries, {})),
    s('fluig-style-guide', fmt(snip.FLUIG.style_guide, {})),
    s('fluig-overrides', fmt(snip.FLUIG.overrides, {})),
    s(
        'fluig-default-imports',
        fmt('\t{style_guide}\n\t{libraries}\n\t{overrides}', {
            style_guide = snip.FLUIG.style_guide,
            libraries = snip.FLUIG.libraries,
            overrides = snip.FLUIG.overrides:gsub('{{', '{'):gsub('}}', '}'),
        })
    ),
}
