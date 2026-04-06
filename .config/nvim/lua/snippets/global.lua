local s = require('utils.snippets')

s.add_global({
  trigger = 'shebang',
  body = [[#!/usr/bin/env ${1|bash,python3,node|}
]],
  description = 'Shebang line',
})
