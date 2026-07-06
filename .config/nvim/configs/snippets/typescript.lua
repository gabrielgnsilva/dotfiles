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
    'component',
    fmt(
      [[
/** @format */

import {{ ChangeDetectionStrategy, Component }} from '@angular/core';

@Component({{
  selector: 'app-{}',
  host: {{
    class: 'app-{}',
    '[style.display]': '"flex"',
    '[style.flexDirection]': '"column"',
    '[style.flex-grow]': '"1"',
    '[style.minHeight]': '"0"',
    '[style.minWidth]': '"0"',
  }},
  standalone: true,
  imports: [],
  template: `<p>app-{} works!</p>`,
  styles: `
    .app-{} {{
      /* Styles here */
    }},
  `,
  changeDetection: ChangeDetectionStrategy.OnPush,
  providers: [],
  viewProviders: [],
}})
export class App{} {{
  // #region: Injections (DI)
  // ...{}
  // #endregion

  // #region: Bindings (Inputs & Models)
  // ...
  // #endregion

  // #region: Outputs (EventEmitters)
  // ...
  // #endregion

  // #region: Properties (signals, variables, etc.)
  // ...
  // #endregion

  // #region: Derived State (computed)
  // ...
  // #endregion

  // #region: Effects
  //...
  // #endregion

  // #region: View Queries (optional)
  //...
  // #endregion

  // #region: Public Methods (component API)
  // ...
  // #endregion

  // #region: Events Handlers (template events)
  // ...
  // #endregion

  // #region: Private Helpers
  //...
  // #endregion

  // #region: Lifecycle Hooks

  protected ngOnInit(): void {{}}
  protected ngDoCheck(): void {{}}
  protected ngAfterContentInit(): void {{}}
  protected ngAfterViewInit(): void {{}}
  protected ngAfterContentChecked(): void {{}}
  protected ngAfterViewChecked(): void {{}}
  protected ngOnDestroy(): void {{}}
  // #endregion
}}
      ]],
      {
        i(1, 'name'),
        same(1),
        same(1),
        same(1),
        f(function(selector)
          return selector[1][1]
            :gsub('%W+', ' ')
            :gsub('(%s+%w)', function(s)
              return s:sub(2, 2):upper()
            end)
            :gsub('^%l', string.upper)
            :gsub(' ', '')
        end, { 1 }),
        i(0, ''),
      }
    )
  ),
  s(
    'service',
    fmt(
      [[
        import {{ Injectable }} from '@angular/core';

        @Injectable({{ providedIn: 'root' }})
        export class {} {{
          getServiceName(): string {{
            return '{}';
          }}
        }}
      ]],
      {
        i(1, 'SomeService'),
        same(1),
      }
    )
  ),
  s(
    'directive',
    fmt(
      [[
        import {{ Directive }} from '@angular/core';

        @Directive({{
          selector: '[{}]',
          host: {{}},
          standalone: true,
          providers: [],
        }})
        export class ExampleDirective {{
          {}
        }}
      ]],
      {
        i(1, 'example-directive'),
        i(0),
      }
    )
  ),
}
