local s = require('utils.snippets')

local add = function(trigger, body, description)
  s.add_by_ft('markdown', {
    trigger = trigger,
    body = body,
    description = description,
  })
end

local add_codeblock = function(lang)
  add(
    lang,
    string.format('```%s\n\n$0\n```', lang),
    string.format('Code block (%s)', lang)
  )
end

-- #region: Code blocks
add_codeblock('ansible')
add_codeblock('apache')
add_codeblock('bash')
add_codeblock('c')
add_codeblock('cmd')
add_codeblock('cpp')
add_codeblock('csharp')
add_codeblock('css')
add_codeblock('csv')
add_codeblock('dart')
add_codeblock('diff')
add_codeblock('dockerfile')
add_codeblock('dotenv')
add_codeblock('go')
add_codeblock('graphql')
add_codeblock('html')
add_codeblock('http')
add_codeblock('ini')
add_codeblock('java')
add_codeblock('javascript')
add_codeblock('json')
add_codeblock('kotlin')
add_codeblock('latex')
add_codeblock('less')
add_codeblock('log')
add_codeblock('makefile')
add_codeblock('markdown')
add_codeblock('nginx')
add_codeblock('patch')
add_codeblock('perl')
add_codeblock('php')
add_codeblock('plaintext')
add_codeblock('powershell')
add_codeblock('python')
add_codeblock('r')
add_codeblock('ruby')
add_codeblock('rust')
add_codeblock('sass')
add_codeblock('scala')
add_codeblock('scss')
add_codeblock('sh')
add_codeblock('shell')
add_codeblock('sql')
add_codeblock('swift')
add_codeblock('terraform')
add_codeblock('text')
add_codeblock('toml')
add_codeblock('typescript')
add_codeblock('xml')
add_codeblock('yaml')
add_codeblock('zsh')
-- #endregion

add(
  'link',
  '[${1:Google}](${2:http://google.com/})$0',
  'Clickable link'
)
