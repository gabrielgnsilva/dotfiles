local wezterm = require('wezterm')
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.window_background_opacity = 0.93
config.force_reverse_video_cursor = true
config.color_scheme = 'kanagawa'
config.color_schemes = {
  ['kanagawa'] = {
    foreground = '#dcd7ba',
    background = '#1f1f28',
    cursor_bg = '#c8c093',
    cursor_fg = '#c8c093',
    cursor_border = '#c8c093',
    selection_fg = '#c8c093',
    selection_bg = '#2d4f67',
    scrollbar_thumb = '#16161d',
    split = '#16161d',
    ansi = {
      '#090618',
      '#c34043',
      '#76946a',
      '#c0a36e',
      '#7e9cd8',
      '#957fb8',
      '#6a9589',
      '#c8c093',
    },
    brights = {
      '#727169',
      '#e82424',
      '#98bb6c',
      '#e6c384',
      '#7fb4ca',
      '#938aa9',
      '#7aa89f',
      '#dcd7ba',
    },
    indexed = { [16] = '#ffa066', [17] = '#ff5d62' },
  },
}

config.window_padding = {
  left = 5,
  right = 1,
  top = 1,
  bottom = 1,
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
config.max_fps = 165
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
