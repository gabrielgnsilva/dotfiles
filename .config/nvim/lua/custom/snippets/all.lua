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

-- Function to determine comment syntax based on file type
local function commentStartSyntax()
    local ft = vim.bo.filetype
    if ft == 'lua' then
        return '-- '
    elseif ft == 'python' then
        return '# '
    elseif ft == 'html' or ft == 'xml' then
        return '<!-- '
    elseif ft == 'cpp' or ft == 'c' or ft == 'csharp' or ft == 'java' or ft == 'javascript' or ft == 'typescript' then
        return '// '
    else
        return '# ' -- Default for unknown file types
    end
end

-- Function to determine comment end syntax based on file type
local function commentEndSyntax()
    local ft = vim.bo.filetype
    if ft == 'html' or ft == 'xml' then
        return ' -->'
    else
        return '' -- No closing comment for most languages
    end
end

-- Function to determine region prefix based on file type
local function regionPrefix()
    local ft = vim.bo.filetype
    if
        ft == 'html'
        or ft == 'xml'
        or ft == 'lua'
        or ft == 'cpp'
        or ft == 'c'
        or ft == 'csharp'
        or ft == 'java'
        or ft == 'javascript'
        or ft == 'typescript'
    then
        return '#'
    else
        return '' -- Default for unknown file types
    end
end

local function content()
    return commentStartSyntax() .. '...' .. commentEndSyntax()
end

local function equalSigns()
    local sStart = commentStartSyntax()
    local sEnd = commentEndSyntax()
    local totalLength = #sStart + #sEnd -- Calculate the total length of sStart and sEnd
    local remainingLength = 80 - totalLength -- Calculate how many equals signs are needed to make the total length 79
    if remainingLength < 0 then
        return string.rep('=', 80)
    end
    return string.rep('=', remainingLength) -- Generate the required number of equal signs
end

return {
    s(
        'section',
        fmt(
            [[
{}{}{}
{}SECTION: {}{}
{}{}{}
    ]],
            {
                f(commentStartSyntax),
                f(equalSigns),
                f(commentEndSyntax),
                f(commentStartSyntax),
                i(0, 'Section name'),
                f(commentEndSyntax),
                f(commentStartSyntax),
                f(equalSigns),
                f(commentEndSyntax),
            }
        )
    ),
    s(
        'region',
        fmt('{}{}region: {}{}\n{}{}\n{}{}regionend{}', {
            f(commentStartSyntax),
            f(regionPrefix),
            i(1, 'name'),
            f(commentEndSyntax),
            f(content),
            i(0),
            f(commentStartSyntax),
            f(regionPrefix),
            f(commentEndSyntax),
        })
    ),
    s('regionStart', fmt('{}region {}{}', { f(commentStartSyntax), i(1, 'name'), f(commentEndSyntax) })),
    s('regionEnd', fmt('{}regionend{}{}', { f(commentStartSyntax), i(0), f(commentEndSyntax) })),
}
