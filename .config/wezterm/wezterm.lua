local wezterm = require('wezterm')
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.window_background_opacity = 0.90
config.color_scheme = 'rose-pine'
config.color_schemes = {
  ['rose-pine'] = {
    background = '#1f1d2e',
    cursor_bg = '#524f67',
    cursor_fg = '#e0def4',
    cursor_border = '#524f67',
  },
}

config.window_padding = {
  left = 5,
  right = 5,
  top = 0,
  bottom = 0,
}

config.font = wezterm.font('JetBrains Mono')
config.font_size = 16.0
config.line_height = 1.0

config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 500

config.enable_wayland = false
config.warn_about_missing_glyphs = false
config.enable_scroll_bar = true
config.enable_tab_bar = false
config.term = 'xterm-256color'
config.max_fps = 120
config.animation_fps = 1
config.front_end = 'OpenGL'
config.webgpu_power_preference = 'HighPerformance'
config.prefer_egl = true

config.disable_default_key_bindings = true
config.keys = {
  {
    key = 'V',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.PasteFrom('Clipboard'),
  },
  {
    key = 'V',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.PasteFrom('PrimarySelection'),
  },
  {
    key = '|',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitPane({
      direction = 'Right',
      size = { Percent = 50 },
    }),
  },
  {
    key = '_',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitPane({
      direction = 'Down',
      size = { Percent = 50 },
    }),
  },
  {
    key = 'Tab',
    mods = 'CTRL',
    action = wezterm.action.ActivatePaneDirection('Next'),
  },
  {
    key = 'Tab',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection('Prev'),
  },
  {
    key = 'Q',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CloseCurrentPane({ confirm = false }),
  },

  {
    key = '-',
    mods = 'CTRL',
    action = wezterm.action.DecreaseFontSize,
  },
  {
    key = '=',
    mods = 'CTRL',
    action = wezterm.action.IncreaseFontSize,
  },
  {
    key = '0',
    mods = 'CTRL',
    action = wezterm.action.ResetFontSize,
  },
}

config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action.CopyTo('Clipboard'),
  },
}

return config
