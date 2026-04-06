local s = require('utils.snippets')

local add = function(trigger, body, description)
  s.add_by_ft('javascript', {
    trigger = trigger,
    body = body,
    description = description,
  })
end

add('type', '/** @type {string} */', 'JSDoc type annotation')

-- #region: JSDoc
add(
  '/**',
  [=[/**
 * ${1:What it does}.
 *
 * @param ${2:name} - ${3:Parameter description.}
 * @returns ${4:Type and description of the returned object.}
 *
 * @example
 * ```
 * ${0:Write me later.}
 * ```
 */]=],
  'JSDoc block'
)

add(
  '/*',
  [=[/**
 * ${0:A simple JSDoc comment.}
 */]=],
  'Simple JSDoc block'
)

add(
  '@param',
  '@param {${1:type}} ${2:paramName} ${0:description}',
  'JSDoc @param'
)

add(
  '@returns',
  '@returns {${1:type}} ${0:description}',
  'JSDoc @returns'
)

add(
  '@example',
  [=[@example
* ```
* ${0:example(s)}
* ```]=],
  'JSDoc @example'
)

add(
  '@author',
  '@author ${1:name} <${2:email}>$0',
  'JSDoc @author'
)
-- #endregion

-- #region: Promises & async
add(
  'await Promise.all',
  'await Promise.all(${1:values});$0',
  'Await a Promise.all()'
)

add(
  'await map of promises',
  [=[const promises = ${1:array}.map(async (${2:value}) => {
  const response = await ${3:somePromise}($2);
  return response.json();
});

${0:await Promise.all(promises);}]=],
  'Map to promises + await all'
)

add(
  'new Promise',
  [=[new Promise((resolve, reject) => {
  ${0}
});]=],
  'Create a new Promise'
)
-- #endregion

-- #region: DOM
add(
  'eventListener',
  [=[${1|element,document.querySelector('#el-id')|}.addEventListener('${2:event}', (${3:ev}) => {
  $3.preventDefault();
  $3.stopPropagation();

  ${0}
});]=],
  'Add event listener'
)

add(
  'querySelector',
  "document.${1|querySelector,querySelectorAll|}('${0:selector}');",
  'Query selector'
)

add(
  'createElement',
  "document.createElement('${0:tag}');",
  'Create an element'
)
-- #endregion

-- #region: Arrays
add(
  'forEach',
  [=[${1:array}.forEach((${2:value}) => {
  console.log($2);
  ${0}
});]=],
  'forEach() with block'
)

add(
  'map',
  [=[${1:array}.map((${2:value}) => {
  return ${0:$2};
});]=],
  'map() with return'
)

add(
  'reduce',
  [=[${1:array}.reduce((prev, next) => {
  return ${0:prev + next};
});]=],
  'reduce() with return'
)

add(
  'filter',
  [=[${1:array}.filter((${2:value}) => {
  return ${0:true};
});]=],
  'filter() with return'
)
-- #endregion

-- #region: General
add(
  'ternary',
  '${1:condition} ? ${2:true} : ${0:false};',
  'Ternary expression'
)

add('Object.values', 'Object.values(${0:obj});', 'Object.values()')
add('Object.keys', 'Object.keys(${0:obj});', 'Object.keys()')

add(
  'Object.getOwnPropertyDescriptor',
  'Object.getOwnPropertyDescriptor(${1:obj}, ${0:key});',
  'Object.getOwnPropertyDescriptor()'
)

add(
  'Object.assign',
  'Object.assign({}, ${0:obj});',
  'Object.assign() shallow clone'
)

add(
  'formatNumber',
  [=[// See options on:
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/NumberFormat/NumberFormat#options
new Intl.NumberFormat('${1:pt-BR}', {
  style: '${2|currency,percent,unit,decimal|}',
  currency: '${3:BRL}',
}).format(${0:number});]=],
  'Intl.NumberFormat helper'
)

add(
  'arrayOfIntegers',
  'Array.from({ length: ${1:5} }, (v, k) => k + 1);$0',
  'Array of integers 1..n'
)

add('that', 'const that = this;$0', 'Alias this to that')

add(
  'tryCatch',
  [=[try {
  ${0}
} catch (e) {
  console.error(e.message);
}]=],
  'try/catch'
)

add(
  'tryCatchFinally',
  [=[try {
  ${0}
} catch (e) {
  console.error(e.message);
} finally {
  alert('done');
}]=],
  'try/catch/finally'
)

add(
  'Console',
  'console.${1|log,error,warn,time,timeEnd,table,debug,trace,dir,count|}(${0:Hello world!});',
  'Console statement'
)

add(
  'JSON',
  'JSON.${1|parse,stringify|}(${0:obj});',
  'JSON.parse/stringify'
)
-- #endregion

-- #region: Control flow
add(
  'ForLoop',
  [=[for (${1|let,var,const|} ${2:i} = 0; $2 < ${3:array.length}; $2++) {
  console.log($2);
}]=],
  'for loop'
)

add(
  'ForIn loop',
  [=[for (${1|const,var,let|} ${2:key} in ${3:object}) {
  if ($3.hasOwnProperty($2)) {
    const value = $3[$2];
    ${0}
  }
}]=],
  'for..in loop'
)

add(
  'ForOf loop',
  [=[for (${1|const,var,let|} ${2:element} of ${3:array}) {
  console.log($2);
  ${0}
}]=],
  'for..of loop'
)

add(
  'if',
  [=[if (${1:condition}) {
  ${0}
}]=],
  'if statement'
)

add(
  'if-else',
  [=[if (${1:condition}) {
  ${0}
} else {
  // ...
}]=],
  'if/else statement'
)

add(
  'switch',
  [=[switch (${1:key}) {
  case ${2:value}:
    return true;
  default:
    return false;
}]=],
  'switch statement'
)

add(
  'while',
  [=[while (${1:condition}) {
  ${0}
}]=],
  'while loop'
)

add(
  'do-while',
  [=[do {
  ${0}
} while (${1:condition});]=],
  'do/while loop'
)
-- #endregion

-- #region: Timers
add(
  'setInterval',
  [=[setInterval(() => {
  ${0}
}, ${1:1000});]=],
  'setInterval()'
)

add(
  'setTimeout',
  [=[setTimeout(() => {
  ${0}
}, ${1:1000});]=],
  'setTimeout()'
)
-- #endregion

-- #region: Strings
add('indexOf', '${1:array}.indexOf(${0:element});', 'indexOf()')

add(
  'replace',
  "${1:string}.${2|replace,replaceAll|}('${3:old}', '${0:new}')",
  'replace/replaceAll'
)
-- #endregion

add(
  'var',
  '${1|const,let,var|} ${2:name} = ${0:value}',
  'Variable declaration'
)
