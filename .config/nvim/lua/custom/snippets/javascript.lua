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
    -- JSDOC
    s(
        '/**',
        fmt(
            [[
                /**
                 * {}.
                 *
                 * @param {} - {}
                 * @returns {}
                 *
                 * @example
                 * ```
                 * {}
                 * ```
                 */
            ]],
            {
                i(1, 'What it does.'),
                i(2, 'name'),
                i(3, 'Parameter description.'),
                i(4, 'Type and description of the returned object.'),
                i(5, 'Write me later.'),
            }
        )
    ),

    s(
        '/*',
        fmt(
            [[
                /**
                 * {}
                 */
            ]],
            {
                i(1, 'A simple JSDoc comment.'),
            }
        )
    ),

    s(
        'at',
        fmt(
            [[
                @{}{}
            ]],
            {
                c(1, {
                    t('param '),
                    t('returns '),
                    t('example'),
                    t('author '),
                    t('async'),
                }),
                d(2, function(a)
                    local choice = a[1][1]
                    local option = ''
                    local node = {}

                    if choice == 'author ' then
                        option = '{}{}{}{}'
                        table.insert(node, i(1, 'name'))
                        table.insert(
                            node,
                            f(function(b)
                                if b[1][1] ~= '' then
                                    return ' <'
                                end
                                return ''
                            end, { 2 })
                        )
                        table.insert(node, c(2, { t('email'), t('') }))
                        table.insert(
                            node,
                            f(function(b)
                                if b[1][1] ~= '' then
                                    return '>'
                                end
                                return ''
                            end, { 2 })
                        )
                    end

                    if choice == 'example' then
                        option = '\n\n* ```\n* {}\n* ```'
                        table.insert(node, i(1, 'example(s)'))
                    end

                    if choice == 'param ' then
                        option = '{{{}{}{}}} {} {}'
                        table.insert(
                            node,
                            c(1, {
                                t(''),
                                t('['),
                            })
                        )
                        table.insert(
                            node,
                            c(2, {
                                t('string'),
                                t('number'),
                                t('boolean'),
                                t('null'),
                                t('undefined'),
                                t('symbol'),
                                t('Object'),
                                t('Array'),
                                t('Function'),
                                t('Date'),
                                t('Element'),
                                t('MyType', {
                                    node_ext_opts = {
                                        passive = {
                                            virt_text = {
                                                { 'Represents a custom type named `MyType`', 'GruvboxBlue' },
                                            },
                                        },
                                    },
                                }),
                            })
                        )
                        table.insert(
                            node,
                            f(function(b)
                                if b[1][1] == '[' then
                                    return ']'
                                end
                                return ''
                            end, { 1 })
                        )
                        table.insert(node, i(3, 'paramName'))
                        table.insert(node, i(4, 'description'))
                    end

                    if choice == 'returns ' then
                        option = '{{{}}} {}'
                        table.insert(node, i(1, 'type'))
                        table.insert(node, i(2, 'description'))
                    end

                    return sn(nil, fmt(option, node))
                end, { 1 }),
            }
        )
    ),

    -- General
    s(
        'validateCNPJ',
        fmt(
            [[
                {}function cnpjIsValid(value) {{
                    const cnpj = String(value.replace(/[^\d]+/g, ''));

                    if (cnpj.length != 14) return false;
                    if (cnpj.split(cnpj[0]).join('').length == 0) return false;

                    let size = 12;
                    let numbers = cnpj.substring(0, size);
                    let digits = cnpj.substring(size);

                    let sum = 0;
                    let pos = size - 7;

                    for (let i = size; i >= 1; i--) {{
                        sum += numbers.charAt(size - i) * pos--;
                        if (pos < 2) pos = 9;
                    }}

                    let result = sum % 11 < 2 ? 0 : 11 - (sum % 11);
                    if (result != digits.charAt(0)) return false;

                    size = size + 1;
                    numbers = cnpj.substring(0, size);

                    sum = 0;
                    pos = size - 7;

                    for (let i = size; i >= 1; i--) {{
                        sum += numbers.charAt(size - i) * pos--;
                        if (pos < 2) pos = 9;
                    }}

                    result = sum % 11 < 2 ? 0 : 11 - (sum % 11);
                    if (result != digits.charAt(1)) return false;

                    return true;
                }}
            ]],
            {
                i(0),
            }
        )
    ),

    s(
        'validateCPF',
        fmt(
            [[
                {}function cpfIsValid(value) {{
                    const cpf = String(value.replace(/[^\d]+/g, ''));

                    if (cpf.length != 11) return false;
                    if (cpf.split(cpf[0]).join('').length == 0) return false;

                    let sum = 0;
                    let spill = 0;

                    // First digit
                    for (let i = 1; i <= 9; i++) sum += (11 - i) * parseInt(cpf.substring(i - 1, i));
                    spill = (sum * 10) % 11;

                    if (spill === 10 || spill === 11) spill = 0;
                    if (spill !== parseInt(cpf.substring(9, 10))) return false;

                    sum = 0;
                    spill = 0;

                    // Second digit
                    for (let i = 1; i <= 10; i++) sum += (12 - i) * parseInt(cpf.substring(i - 1, i));
                    spill = (sum * 10) % 11;

                    if (spill === 10 || spill === 11) spill = 0;
                    if (spill !== parseInt(cpf.substring(10, 11))) return false;

                    return true; // Return true if the verification digits are expected.
                }}
            ]],
            {
                i(0),
            }
        )
    ),

    s(
        'await Promise.all',
        fmt(
            [[
                await Promise.all({});
            ]],
            { i(1, 'value') }
        )
    ),

    s(
        'await map of promises',
        fmt(
            [[
                const promises = {}.map(async ({}) => {{
                    const response = await somePromise({});
                    return response.json();
                }});

                {}await Promise.all(promises);
            ]],
            {
                i(1, 'array'),
                i(2, 'value'),
                same(2),
                i(0),
            }
        )
    ),

    s(
        'new Promise',
        fmt(
            [[
                new Promise((resolve, reject) => {{
                    {}
                }});
            ]],
            { i(0) }
        )
    ),

    s(
        'eventListener',
        fmt(
            [[
                {}.addEventListener('{}', ({}) => {{
                    {}.preventDefault();
                    {}.stopPropagation();

                    {}
                }});
            ]],
            {
                c(1, { t('element'), t("document.querySelector('#el-id')") }),
                i(2, 'event'),
                i(3, 'ev'),
                same(3),
                same(3),
                i(0),
            }
        )
    ),

    s(
        'querySelector',
        fmt(
            [[
                document.{}('{}');
            ]],
            { c(1, { t('querySelector'), t('querySelectorAll') }), i(0) }
        )
    ),

    s(
        'createElement',
        fmt(
            [[
                document.createElement('{}');
            ]],
            { i(0) }
        )
    ),

    s(
        'forEach',
        fmt(
            [[
                {}.forEach(({}) {}{});
            ]],
            {
                i(1, 'array'),
                i(2, 'value'),
                c(3, {
                    t('=> {'),
                    t('=> '),
                }),
                d(4, function(type)
                    if type[1][1] == '=> {' then
                        return sn(nil, fmt('\n\n\tconsole.log(' .. type[2][1] .. ')\n}}', {}))
                    end
                    return sn(nil, fmt('console.log(' .. type[2][1] .. ')', {}))
                end, { 3, 2 }),
            }
        )
    ),

    s(
        'map',
        fmt(
            [[
                {}.map(({}) {}{});
            ]],
            {
                i(1, 'array'),
                i(2, 'value'),
                c(3, {
                    t('=> {'),
                    t('=> '),
                }),
                d(4, function(a)
                    if a[1][1] == '=> {' then
                        return sn(nil, fmt('\n\n\treturn ' .. a[2][1] .. ' * 2;\n}}', {}))
                    end
                    return sn(nil, fmt(a[2][1] .. ' * 2', {}))
                end, { 3, 2 }),
            }
        )
    ),

    s(
        'reduce',
        fmt(
            [[
                {}.reduce((prev, next) {}{});
            ]],
            {
                i(1, 'array'),
                c(2, {
                    t('=> {'),
                    t('=> '),
                }),
                d(3, function(type)
                    if type[1][1] == '=> {' then
                        return sn(nil, fmt('\n\n\treturn prev + next\n}}', {}))
                    end
                    return sn(nil, fmt('prev + next', {}))
                end, { 2 }),
            }
        )
    ),

    s(
        'filter',
        fmt(
            [[
                {}.filter(({}) {}{});
            ]],
            {
                i(1, 'array'),
                i(2, 'value'),
                c(3, {
                    t('=> {'),
                    t('=> '),
                }),
                d(4, function(type)
                    if type[1][1] == '=> {' then
                        return sn(nil, fmt('\n\n\t' .. type[2][1] .. ' = true;\n}}', {}))
                    end
                    return sn(nil, fmt(type[2][1] .. ' = true', {}))
                end, { 3, 2 }),
            }
        )
    ),

    s(
        'ternary',
        fmt(
            [[
                {} ? {} : {};
            ]],
            {
                i(3, 'condition'),
                i(4, 'true'),
                i(5, 'false'),
            }
        )
    ),

    s(
        'Object.values',
        fmt(
            [[
                Object.values({});
            ]],
            {
                i(1, 'obj'),
            }
        )
    ),

    s(
        'Object.keys',
        fmt(
            [[
                Object.keys({});
            ]],
            {
                i(1, 'obj'),
            }
        )
    ),

    s(
        'Object.getOwnPropertyDescriptor',
        fmt(
            [[
                Object.getOwnPropertyDescriptor({}, {});
            ]],
            {
                i(1, 'obj'),
                i(2, 'key'),
            }
        )
    ),

    s(
        'Object.assign',
        fmt(
            [[
                Object.assign({{}}, {})
            ]],
            {
                i(1, 'obj'),
            }
        )
    ),

    s(
        'formatNumber',
        fmt(
            [[
                // see other options on: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/NumberFormat/NumberFormat#options
                new Intl.NumberFormat('{}', {{
                    style: '{}'{}{}
                }}).format({}{});
            ]],
            {
                c(1, { t('pt-BR'), t('en-US'), t('es') }),
                c(2, { t('currency'), t('percent'), t('unit'), t('decimal') }),
                d(3, function(cur)
                    if cur[1][1] == 'currency' then
                        return sn(
                            nil,
                            fmt(",\n\tcurrency: '{}',\n\tcurrencyDisplay: '{}'", {
                                c(1, { t('BRL'), t('USD'), t('MXN') }),
                                c(2, { t('symbol'), t('narrowSymbol'), t('code'), t('name') }),
                            })
                        )
                    end
                    return sn(nil, fmt('', {}))
                end, { 2 }),
                d(4, function(cur)
                    if cur[1][1] == 'unit' then
                        return sn(
                            nil,
                            fmt(",\n\tunit: '{}',\n\tunitDisplay: '{}'", {
                                c(1, { t('hour'), t('minute'), t('month') }),
                                c(2, { t('short'), t('narrow'), t('long') }),
                            })
                        )
                    end
                    return sn(nil, fmt('', {}))
                end, { 2 }),
                i(5, 'number'),
                i(0),
            }
        )
    ),

    s(
        'arrayOfIntegers',
        fmt(
            [[
                Array.from({{ length: {} }}, (v, k) => k + 1);
            ]],
            {
                i(1, '5'),
            }
        )
    ),

    s(
        'that',
        fmt(
            [[
                const that = this;
            ]],
            {}
        )
    ),

    s(
        'tryCatch',
        fmt(
            [[
                try {{
                    {}
                }} catch (e) {{
                    console.error(e.message);
                }}
            ]],
            { i(0) }
        )
    ),

    s(
        'tryCatchFinally',
        fmt(
            [[
                try {{
                    {}
                }} catch (e) {{
                    console.error(e.message);
                }} finally {{
                    alert('done');
                }}
            ]],
            { i(0) }
        )
    ),

    s(
        'Function',
        fmt(
            [[
                {}{}{}({}) {}{}{};
            ]],
            {
                c(1, { t(''), t('(') }),
                c(2, { t(''), t('async ') }),
                c(3, { t('function '), t('') }),
                i(4, 'arg'),
                f(function(a)
                    if a[1][1] == 'function ' then
                        return '{'
                    end
                    return '=> '
                end, { 3 }),
                d(5, function(a)
                    if a[1][1] ~= 'function ' then
                        return sn(
                            nil,
                            fmt('{}{}', {
                                c(1, { t('{'), t('') }),
                                d(2, function(b)
                                    if b[1][1] == '{' then
                                        return sn(nil, fmt('\n\n\treturn {} == true;\n}}', { i(1, a[2][1]) }))
                                    end
                                    return sn(nil, fmt('{} == true', { i(1, a[2][1]) }))
                                end, { 1 }),
                            })
                        )
                    end
                    return sn(nil, fmt('\n\n\treturn {} == true;\n}}', { i(1, a[2][1]) }))
                end, { 3, 4 }),
                f(function(a)
                    if a[1][1] == '(' then
                        return ')()'
                    end
                    return ''
                end, { 1 }),
            }
        )
    ),

    s(
        'get',
        fmt(
            [[
                {}function get{}({}){{
                    {}
                }}
            ]],
            {
                c(1, {
                    t(''),
                    t('async '),
                }),
                i(2, 'Name'),
                i(3, 'value'),
                i(0),
            }
        )
    ),

    s(
        'set',
        fmt(
            [[
                {}function set{}({}){{
                    {}
                }}
            ]],
            {
                c(1, {
                    t(''),
                    t('async '),
                }),
                i(2, 'Name'),
                i(3, 'value'),
                i(0),
            }
        )
    ),

    s(
        'Console',
        fmt(
            [[
                console.{}({});
            ]],
            {
                c(1, {
                    t('log'),
                    t('error'),
                    t('warn'),
                    t('time'),
                    t('timeEnd'),
                    t('table'),
                    t('debug'),
                    t('trace'),
                    t('dir'),
                    t('count'),
                }),
                i(0, 'Hello world!'),
            }
        )
    ),

    s(
        'JSON',
        fmt(
            [[
                JSON.{}({});
            ]],
            { c(1, { t('parse'), t('stringify') }), i(2, 'obj') }
        )
    ),

    s(
        'ForLoop',
        fmt(
            [[
                for ({} {} = 0; {} < {}; {}++) {{
                    console.log({});
                }}
            ]],
            {
                c(1, { t('let'), t('var') }),
                i(2, 'i'),
                same(2),
                i(3, 'array.length'),
                same(2),
                same(2),
            }
        )
    ),

    s(
        'ForIn loop',
        fmt(
            [[
                for ({} {} in {}) {{
                    if ({}.hasOwnProperty({})) {{
                        {} value = {}[{}];
                        {}
                    }}
                }}
            ]],
            {
                c(1, { t('const'), t('var') }),
                i(2, 'key'),
                i(3, 'object'),
                same(3),
                same(2),
                same(1),
                same(3),
                same(2),
                i(0),
            }
        )
    ),

    s(
        'ForOf loop',
        fmt(
            [[
                for ({} {} of {}) {{
                    console.log({});
                }}
            ]],
            {
                c(1, {
                    t('const'),
                    t('var'),
                }),
                i(2, 'element'),
                i(3, 'array'),
                same(2),
            }
        )
    ),

    s(
        'if',
        fmt(
            [[
                if ({}) {}{}
            ]],
            {
                i(1, 'condition'),
                c(2, { t('{'), t('') }),
                d(3, function(a)
                    if a[1][1] == '{' then
                        return sn(nil, fmt('\n\n\t{}\n}}', { i(1) }))
                    end
                    return sn(nil, fmt(';', {}))
                end, { 2 }),
            }
        )
    ),

    s(
        'if-else',
        fmt(
            [[
                if ({}) {{
                    {}
                }} else {{
                    
                }}
            ]],
            {
                i(1, 'condition'),
                i(0),
            }
        )
    ),

    s(
        'switch',
        fmt(
            [[
                switch ({}){{
                    case {}:
                        return true;
                        break;
                    default:
                        return false;
                        break;
                }}
            ]],
            {
                i(1, 'key'),
                i(2, 'value'),
            }
        )
    ),

    s(
        'while',
        fmt(
            [[
                while ({}) {{
                    {}
                }}
            ]],
            { i(1, 'condition'), i(0) }
        )
    ),

    s(
        'do-while',
        fmt(
            [[
                do {{
                    {}
                }} while ({});
            ]],
            {
                i(0),
                i(1, 'condition'),
            }
        )
    ),

    s(
        'setInterval',
        fmt(
            [[
                setInterval(() => {{
                    {}
                }}, {});
            ]],
            {
                i(0),
                i(1, '1000'),
            }
        )
    ),

    s(
        'setTimeout',
        fmt(
            [[
                setTimeout(() => {{
                    {}
                }}, {});
            ]],
            {
                i(0),
                i(1, '1000'),
            }
        )
    ),

    s(
        '#region',
        fmt(
            [[
                // #region {}
            ]],
            { i(1, 'name') }
        )
    ),

    s(
        '#regionEnd',
        fmt(
            [[
                // #regionend
            ]],
            {}
        )
    ),

    s(
        'indexOf',
        fmt(
            [[
                {}.indexOf({})
            ]],
            {
                i(1, 'array'),
                i(2, 'element'),
            }
        )
    ),

    s(
        'replace',
        fmt(
            [[
                {}.{}('{}', '{}')
            ]],
            {
                i(1, 'string'),
                c(2, { t('replace'), t('replaceAll') }),
                i(3, 'old'),
                i(4, 'new'),
            }
        )
    ),

    s(
        'var',
        fmt(
            [[
                {} {} = {}
            ]],
            {
                c(1, { t('const'), t('let'), t('var') }),
                i(2, 'name'),
                i(0),
            }
        )
    ),

    s(
        'sanitize',
        fmt(
            [[
            function (str){{
                const map = {{
                    '&': '&amp;',
                    '<': '&lt;',
                    '>': '&gt;',
                    '"': '&quot;',
                    "'": '&#x27;',
                    "/": '&#x2F;',
                }};

                return str.replace(/[&<>"'/]/ig, (match)=>(map[match]));
            }}
        ]],
            {}
        )
    ),

    -- Fluig
    s(
        'setDueDate',
        fmt(
            [[
                var processId = new java.lang.Integer(getValue('WKNumProces'));
                var deadline = new java.text.SimpleDateFormat('dd/MM/yyyy').parse({});

                hAPI.setDueDate(processId, 0, {}, deadline, 0);
            ]],
            {
                i(1, "'dd/MM/yyyy'"),
                i(2, "getValue('WKUser')"),
            }
        )
    ),

    s(
        'getDataset',
        fmt(
            [[
                var constraints = [];
                constraints.push(DatasetFactory.createConstraint('{}', '{}', '{}', ConstraintType.MUST));

                var fields = [];
                {}

                var dataset = DatasetFactory.getDataset('{}', fields, constraints, [{};{}']);

                for (var i = 0; i < dataset.rowsCount; i++) {{
                    log.info(dataset.getValue(i, '{}'));
                }}
            ]],
            {
                i(1),
                i(2),
                same(2),
                c(3, { t("fields.push('');"), t('') }),
                i(4),
                c(5, { t("fields[0] + '"), t("'FIELD") }),
                c(6, { t('asc'), t('desc') }),
                same(1),
            }
        )
    ),

    s(
        'getSubDataset',
        fmt(
            [[
                var constraints = [];
                constraints.push(DatasetFactory.createConstraint('{}', {}, {}, ConstraintType.MUST));

                var fields = [];
                fields.push('metadata#id');
                fields.push('metadata#version');

                var dataset = DatasetFactory.getDataset('{}', fields, constraints, ['metadata#id;asc']);

                for (var i = 0; i < dataset.rowsCount; i++) {{
                    var docId = dataset.getValue(i, 'metadata#id');
                    var docVersion = dataset.getValue(i, 'metadata#version');

                    var subDatasetConstraints = [];
                    subDatasetConstraints.push(DatasetFactory.createConstraint('tablename', '{}', '{}', ConstraintType.MUST));
                    subDatasetConstraints.push(DatasetFactory.createConstraint('metadata#id', docId, docId, ConstraintType.MUST));
                    subDatasetConstraints.push(DatasetFactory.createConstraint('metadata#version', docVersion, docVersion, ConstraintType.MUST));

                    var fields = [];
                    {}

                    var subDataset = DatasetFactory.getDataset('{}', fields, subDatasetConstraints, [{};{}']);

                    for (var j = 0; j < subDataset.rowsCount; j++) {{
                        log.info(subDataset.getValue(j, '{}'));
                    }}
                }}
            ]],
            {
                i(1, 'metadata#active'),
                i(2, 'true'),
                same(2),
                i(3),
                i(4),
                same(4),
                c(5, { t("fields.push('');"), t('') }),
                same(3),
                c(6, { t("fields[0] + '"), t("'FIELD") }),
                c(7, { t('asc'), t('desc') }),
                i(0),
            }
        )
    ),

    s(
        'modal',
        fmt(
            [[
                const {} = FLUIGC.modal({{
                    title: '{}',
                    content: '<p>content</p>',
                    id: '{}',
                    actions: [
                        {{
                            label: '{}',
                            bind: 'data-modal-{}',
                            classType: 'btn-{}',
                            autoClose: {},
                        }},
                    ],
                    function(err, data) {{
                        if (err) {{
                            FLUIGC.toast({{
                                message: `Error: ${{err}}`,
                                type: 'danger',
                            }});
                            throw err;
                        }}

                        // ...{}
                    }},
                }});
            ]],
            {
                i(1, 'modal'),
                i(2),
                i(3),
                i(4, 'Ok'),
                f(function(string)
                    local pattern = '[^%w%s]'
                    local cleaned_string = string[1][1]:gsub(pattern, '')
                    cleaned_string = cleaned_string:gsub('%s', '-')

                    return cleaned_string:lower()
                end, { 4 }),
                i(5, 'default'),
                c(6, { t('true'), t('false') }),
                i(0),
            }
        )
    ),

    s(
        'toast',
        fmt(
            [[
                FLUIGC.toast({{
                    title: '{}',
                    message: '{}',
                    type: '{}',
                }});{}
            ]],
            {
                i(1),
                i(2),
                c(3, { t('warning'), t('danger'), t('info'), t('success') }),
                i(0),
            }
        )
    ),

    s(
        'closeConnections',
        fmt(
            [[
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            ]],
            {}
        )
    ),
}
