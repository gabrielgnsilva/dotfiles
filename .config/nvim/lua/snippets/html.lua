local s = require('utils.snippets')

local add = function(trigger, body, description)
  s.add_by_ft('html', {
    trigger = trigger,
    body = body,
    description = description,
  })
  s.add_by_ft('htmlangular', {
    trigger = trigger,
    body = body,
    description = description,
  })
end

-- #region: General
add('doctype', '<!doctype html>', 'HTML5 doctype')

add(
  'input',
  '<label>${1:input_name} <input name="${1:input_name}" type="text" /></label>',
  'Simple input'
)

add(
  'html',
  [[<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>${1:Document}</title>
  </head>
  <body>
    ${0:<p>content</p>}
  </body>
</html>]],
  'Basic HTML document'
)
-- #endregion

-- #region: Fluig
add(
  'fluig-libraries',
  [[<!-- #region: Libraries -->
<script type="text/javascript" src="/TOTVSIP_LIB/resources/js/gd-lib.js"></script>
<script type="text/javascript" src="/TOTVSIP_LIB/resources/js/jMask.js"></script>
<script type="text/javascript" src="/webdesk/vcXMLRPC.js"></script>
<!-- #endregion -->]],
  'Fluig libraries'
)

add(
  'fluig-style-guide',
  [[<!-- #region: Style guide -->
<link rel="stylesheet" type="text/css" href="/style-guide/css/fluig-style-guide.min.css" />
<link rel="stylesheet" type="text/css" href="/style-guide/css/fluig-style-guide-flat.min.css" />
<link rel="stylesheet" type="text/css" href="/TOTVSIP_LIB/resources/css/TOTVSIP_LIB.css" />
<script src="/portal/resources/js/jquery/jquery.js"></script>
<script src="/portal/resources/js/jquery/jquery-ui.min.js"></script>
<script src="/portal/resources/js/mustache/mustache-min.js"></script>
<script src="/style-guide/js/fluig-style-guide.min.js"></script>
<!-- #endregion -->]],
  'Fluig style guide imports'
)

add(
  'fluig-overrides',
  [[<!-- #region: Scripts -->
<script language="javascript">
  function disablePullToRefresh() {
    return true;
  }
</script>
<!-- #endregion -->]],
  'Fluig overrides'
)

add(
  'fluig-default-imports',
  [[<!-- #region: Style guide -->
<link rel="stylesheet" type="text/css" href="/style-guide/css/fluig-style-guide.min.css" />
<link rel="stylesheet" type="text/css" href="/style-guide/css/fluig-style-guide-flat.min.css" />
<link rel="stylesheet" type="text/css" href="/TOTVSIP_LIB/resources/css/TOTVSIP_LIB.css" />
<script src="/portal/resources/js/jquery/jquery.js"></script>
<script src="/portal/resources/js/jquery/jquery-ui.min.js"></script>
<script src="/portal/resources/js/mustache/mustache-min.js"></script>
<script src="/style-guide/js/fluig-style-guide.min.js"></script>
<!-- #endregion -->

<!-- #region: Libraries -->
<script type="text/javascript" src="/TOTVSIP_LIB/resources/js/gd-lib.js"></script>
<script type="text/javascript" src="/TOTVSIP_LIB/resources/js/jMask.js"></script>
<script type="text/javascript" src="/webdesk/vcXMLRPC.js"></script>
<!-- #endregion -->

<!-- #region: Scripts -->
<script language="javascript">
  function disablePullToRefresh() {
    return true;
  }
</script>
<!-- #endregion -->]],
  'Fluig default imports'
)

add(
  'fluig-input',
  [[<div class="form-group col-md-3">
  <label class='control-label fs-ellipsis' for="${1:input-id}">${2:Input ID}</label>
  <input id="$1" name="$1" type="text" class="form-control" />$0
</div>]],
  'Fluig input field'
)
-- #endregion
