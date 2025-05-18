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
    'package',
    fmt(
      [[
        {{
          "name": "package-name",
          "version": "0.0.0",
          "main": "dist/index.js",
          "license": "MIT",
          "description": "Brief description of what your package does.",
          "author": "Your name <youremail@domain.com>",
          "repository": {{
            "type": "git",
            "url": "https://github.com/yourusername/your-repo.git"
          }},
          "keywords": [
            "tag1",
            "tag2"
          ],
          "bugs": {{
            "url": "https://github.com/yourusername/your-repo/issues"
          }},
          "homepage": "https://github.com/yourusername/your-repo#readme"
        }}
    ]],
      {}
    )
  ),
}
