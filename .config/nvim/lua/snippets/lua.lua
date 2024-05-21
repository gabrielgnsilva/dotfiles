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
    s(
        'req',
        fmt("{}{} = require('{}')", {
            c(1, { t('local '), t('') }),
            f(function(import_name)
                local parts = vim.split(import_name[1][1], '.', true)
                return parts[#parts] or ''
            end, { 2 }),
            i(2),
        })
    ),

    s(
        'snippet',
        fmt("s(\n\t'{}',\n\tfmt(\n\t\t{}\n\t\t\t{}\n\t\t{},\n\t\t{{}}\n\t)\n),", {
            i(1, 'snippet'),
            c(2, { t('[['), t('"') }),
            i(0),
            f(function(name)
                if name[1][1] == '[[' then
                    return ']]'
                else
                    return '"'
                end
            end, { 2 }),
        })
    ),
}
