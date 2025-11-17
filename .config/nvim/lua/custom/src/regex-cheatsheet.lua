local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function create_text_window(opts)
  opts = opts or {}

  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local win_config = {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
  }

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf })
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })
  vim.api.nvim_set_option_value('modifiable', true, { buf = buf })
  vim.api.nvim_set_option_value('filetype', 'markdown', { buf = buf }) -- opcional

  if opts.lines then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, opts.lines)
  end

  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

vim.api.nvim_create_user_command('RegexCheatsheet', function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    local content = [[
# 🧠 Regex Cheatsheet

## 🎯 Regex Modes

- `\v` – **Very Magic** (enables modern-like regex syntax)
- `\m` – Magic (default)
- `\M` – Nomagic
- `\V` – Very Nomagic

**It's recommended to use `\v` for fewer escapes. Example:**

## 🔤 Basic Metacharacters

| Pattern   | Meaning                        |
| --------- | ------------------------------ |
| `.`       | Any character (except newline) |
| `^`       | Start of line                  |
| `$`       | End of line                    |
| `[...]`   | Any character listed           |
| `[^...]`  | Any character **not** listed   |
| `\|`      | Logical OR (pipe)              |
| `\(` `\)` | Grouping                       |

## 🔁 Quantifiers

| Pattern  | Meaning                     |
| -------- | --------------------------- |
| `*`      | 0 or more                   |
| `\+`     | 1 or more                   |
| `\=`     | 0 or 1                      |
| `\{n}`   | Exactly n repetitions       |
| `\{n,}`  | n or more repetitions       |
| `\{n,m}` | Between n and m repetitions |

## 🔢 Character Classes

| Pattern | Meaning                              |
| ------- | ------------------------------------ |
| `\d`    | Digit (0-9)                          |
| `\D`    | Non-digit                            |
| `\s`    | Whitespace (space, tab, etc.)        |
| `\S`    | Non-whitespace                       |
| `\w`    | Word character (letters, digits, \_) |
| `\W`    | Non-word character                   |

## 🎯 Anchors & Boundaries

| Pattern | Meaning             |
| ------- | ------------------- |
| `\b`    | Word boundary       |
| `\B`    | Not a word boundary |
| `^`     | Beginning of a line |
| `$`     | End of a line       |
| `\<`    | Start of a word     |
| `\>`    | End of a word       |

## ⚡ Useful Examples

```vim
/\v\d{3}.\d{3}.\d{3}-\d{2}
" => Matches Brazilian CPF format ###.###.###-##

/\vhttps?:\/\/[^\s]+
" => Matches simple URLs (http or https)

/\vfoo|bar|baz
" => Matches if any of these words appear

/\v(\d+)\s+itens?
" => Matches a number followed by "item" or "items"
```]]

    state.floating = create_text_window({
      lines = vim.split(content, '\n'),
    })
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end, {})

require('utils.mappings').load_keymap({
  {
    mode = { 'n' },
    bindings = {
      {
        key = '<leader><leader>/',
        cmd = '<cmd>:RegexCheatsheet<cr>',
        desc = 'Open regex cheatsheet',
      },
    },
  },
})
