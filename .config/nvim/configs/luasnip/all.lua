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

return {
  s(
    'shebang',
    fmt('#!/usr/bin/env {}\n', {
      c(1, { t('bash'), t('python3'), t('node') }),
    })
  ),
}
