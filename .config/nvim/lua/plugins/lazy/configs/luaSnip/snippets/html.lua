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

local snip = {
  FLUIG = {
    libraries = [[
    <!-- #region: Libraries -->
    <script type="text/javascript" src="/TOTVSIP_LIB/resources/js/gd-lib.js"></script>
    <script type="text/javascript" src="/TOTVSIP_LIB/resources/js/jMask.js"></script>
    <script type="text/javascript" src="/webdesk/vcXMLRPC.js"></script>
    <!-- #endregion -->
]],
    style_guide = [[
    <!-- #region: Style guide -->
    <link rel="stylesheet" type="text/css" href="/style-guide/css/fluig-style-guide.min.css" />
    <link rel="stylesheet" type="text/css" href="/style-guide/css/fluig-style-guide-flat.min.css" />
    <link rel="stylesheet" type="text/css" href="/TOTVSIP_LIB/resources/css/TOTVSIP_LIB.css" />
    <script src="/portal/resources/js/jquery/jquery.js"></script>
    <script src="/portal/resources/js/jquery/jquery-ui.min.js"></script>
    <script src="/portal/resources/js/mustache/mustache-min.js"></script>
    <script src="/style-guide/js/fluig-style-guide.min.js"></script>
    <!-- #endregion -->
]],
    overrides = [[
    <!-- #region: Scripts -->
    <script language="javascript">
        function disablePullToRefresh() {{
            return true;
        }}
    </script>
    <!-- #endregion -->
]],
  },
}

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
