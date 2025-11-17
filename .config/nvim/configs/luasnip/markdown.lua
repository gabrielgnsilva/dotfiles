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
  -- region: Code blocks
  s(
    { trig = 'ansible', name = 'Add code block for ansible' },
    fmt('```ansible\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'apache', name = 'Add code block for apache' },
    fmt('```apache\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'bash', name = 'Add code block for bash' },
    fmt('```bash\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'c', name = 'Add code block for c' },
    fmt('```c\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'cmd', name = 'Add code block for cmd' },
    fmt('```cmd\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'cpp', name = 'Add code block for cpp' },
    fmt('```cpp\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'csharp', name = 'Add code block for csharp' },
    fmt('```csharp\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'css', name = 'Add code block for css' },
    fmt('```css\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'csv', name = 'Add code block for csv' },
    fmt('```csv\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'dart', name = 'Add code block for dart' },
    fmt('```dart\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'diff', name = 'Add code block for diff' },
    fmt('```diff\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'dockerfile', name = 'Add code block for dockerfile' },
    fmt('```dockerfile\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'dotenv', name = 'Add code block for dotenv' },
    fmt('```dotenv\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'go', name = 'Add code block for go' },
    fmt('```go\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'graphql', name = 'Add code block for graphql' },
    fmt('```graphql\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'html', name = 'Add code block for html' },
    fmt('```html\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'http', name = 'Add code block for http' },
    fmt('```http\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'ini', name = 'Add code block for ini' },
    fmt('```ini\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'java', name = 'Add code block for java' },
    fmt('```java\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'javascript', name = 'Add code block for javascript' },
    fmt('```javascript\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'json', name = 'Add code block for json' },
    fmt('```json\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'kotlin', name = 'Add code block for kotlin' },
    fmt('```kotlin\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'latex', name = 'Add code block for latex' },
    fmt('```latex\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'less', name = 'Add code block for less' },
    fmt('```less\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'log', name = 'Add code block for log' },
    fmt('```log\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'makefile', name = 'Add code block for makefile' },
    fmt('```makefile\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'markdown', name = 'Add code block for markdown' },
    fmt('```markdown\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'nginx', name = 'Add code block for nginx' },
    fmt('```nginx\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'patch', name = 'Add code block for patch' },
    fmt('```patch\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'perl', name = 'Add code block for perl' },
    fmt('```perl\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'php', name = 'Add code block for php' },
    fmt('```php\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'plaintext', name = 'Add code block for plaintext' },
    fmt('```plaintext\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'powershell', name = 'Add code block for powershell' },
    fmt('```powershell\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'python', name = 'Add code block for python' },
    fmt('```python\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'r', name = 'Add code block for r' },
    fmt('```r\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'ruby', name = 'Add code block for ruby' },
    fmt('```ruby\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'rust', name = 'Add code block for rust' },
    fmt('```rust\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'sass', name = 'Add code block for sass' },
    fmt('```sass\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'scala', name = 'Add code block for scala' },
    fmt('```scala\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'scss', name = 'Add code block for scss' },
    fmt('```scss\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'sh', name = 'Add code block for sh' },
    fmt('```sh\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'shell', name = 'Add code block for shell' },
    fmt('```shell\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'sql', name = 'Add code block for sql' },
    fmt('```sql\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'swift', name = 'Add code block for swift' },
    fmt('```swift\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'terraform', name = 'Add code block for terraform' },
    fmt('```terraform\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'text', name = 'Add code block for text' },
    fmt('```text\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'toml', name = 'Add code block for toml' },
    fmt('```toml\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'typescript', name = 'Add code block for typescript' },
    fmt('```typescript\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'xml', name = 'Add code block for xml' },
    fmt('```xml\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'yaml', name = 'Add code block for yaml' },
    fmt('```yaml\n\n{}```', { i(0) })
  ),
  s(
    { trig = 'zsh', name = 'Add code block for zsh' },
    fmt('```zsh\n\n{}```', { i(0) })
  ),
  -- #regionend
  s(
    { trig = 'link', name = 'Add a clickable link' },
    fmt('[{}]({})', {
      i(0, 'Google'),
      i(1, 'http://google.com/'),
    })
  ),
}
