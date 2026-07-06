local s = require('utils.snippets')

local add = function(trigger, body, description)
  s.add_by_ft('lua', {
    trigger = trigger,
    body = body,
    description = description,
  })
end

add(
  'req',
  [[local ${1:mod} = require('${2:module}')$0]],
  'Require a Lua module'
)

add(
  'snippet',
  [=[s.add_by_ft('${1:filetype}', {
  trigger = '${2:trigger}',
  body = [[
${0}
]],
  description = '${3:description}',
})]=],
  'Add a builtin snippet'
)
