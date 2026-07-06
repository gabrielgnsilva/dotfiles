local s = require('utils.snippets')

local add = function(trigger, body, description)
  s.add_by_ft('typescript', {
    trigger = trigger,
    body = body,
    description = description,
  })
end

add(
  'component',
  [=[/** @format */

import { ChangeDetectionStrategy, Component } from '@angular/core';

@Component({
  selector: 'app-${1:name}',
  host: {
    class: 'app-$1',
    '[style.display]': '"flex"',
    '[style.flexDirection]': '"column"',
    '[style.flex-grow]': '"1"',
    '[style.minHeight]': '"0"',
    '[style.minWidth]': '"0"',
  },
  standalone: true,
  imports: [],
  template: `<p>app-$1 works!</p>`,
  styles: `
    .app-$1 {
      /* Styles here */
    }
  `,
  changeDetection: ChangeDetectionStrategy.OnPush,
  providers: [],
  viewProviders: [],
})
export class ${2:AppName} {
  // #region: Injections (DI)
  // ...
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

  protected ngOnInit(): void {}
  protected ngDoCheck(): void {}
  protected ngAfterContentInit(): void {}
  protected ngAfterViewInit(): void {}
  protected ngAfterContentChecked(): void {}
  protected ngAfterViewChecked(): void {}
  protected ngOnDestroy(): void {}
  // #endregion
}
$0]=],
  'Angular standalone component (OnPush)'
)

add(
  'service',
  [=[import { Injectable } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class ${1:SomeService} {
  getServiceName(): string {
    return '${2:serviceName}';
  }
}
$0]=],
  'Angular service'
)

add(
  'directive',
  [=[import { Directive } from '@angular/core';

@Directive({
  selector: '[${1:example-directive}]',
  host: {},
  standalone: true,
  providers: [],
})
export class ${2:ExampleDirective} {
  ${0}
}]=],
  'Angular directive'
)
