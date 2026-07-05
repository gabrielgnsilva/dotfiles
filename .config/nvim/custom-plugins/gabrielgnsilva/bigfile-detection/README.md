# bigfile-detection.nvim

Simple Neovim plugin to detect heavy buffers and disable expensive features.

## Features

- Detects large files by size
- Detects files with very long lines
- Supports integration with `Snacks.bigfile`
- Can disable selected heavy features based on the detection reason
- Provides restore and toggle commands

## Plugin structure

- `plugin/bigfile-detection.lua` registers user commands
- `lua/bigfile_detection/init.lua` exposes setup, commands, and runtime hooks
- `lua/bigfile_detection/config.lua` owns defaults, merging, and validation
- `lua/bigfile_detection/detector.lua` owns file-size and long-line detection

## Requirements

- Neovim 0.10+

## Installation

### lazy.nvim

```lua
{
  'gabrielgnsilva/bigfile-detection.nvim',
  main = 'bigfile_detection',
  opts = {},
}
```

## Commands

- `:BigfileDisable`
- `:BigfileEnable`
- `:BigfileToggle`
- `:BigfileRestore`

## Default behavior

- `large_file`
  - disables treesitter by default
- `long_lines`
  - disables heavier editor features more aggressively
- `snacks_bigfile`
  - mirrors `Snacks.bigfile` when enabled

## Notes

- Setup validates threshold and notification values early.
- Filetype restoration depends on the current buffer path being resolvable.
- LSP restart on restore requires `:LspStart` to exist.

## Testing

From the plugin directory:

```bash
make test
```

## Release process

See [RELEASE.md](./RELEASE.md) for the release checklist and tag strategy.
