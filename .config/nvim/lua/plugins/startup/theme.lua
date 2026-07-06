--[[
  Theme is not lazy loaded because it needs to be loaded before all other
  plugins to ensure that the colors are applied correctly.
]]

return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  opts = {
    transparent_background = false,
    color_overrides = {
      mocha = {
        base = '#0a0b14',
        mantle = '#0a0b14',
        crust = '#151722',
      },
    },
    custom_highlights = function(colors)
      return {
        FloatBorder = { bg = 'none' },
        FloatTitle = { bg = 'none' },
        Normal = { bg = 'none' },
        NormalFloat = { bg = 'none' },
        LineNr = { bg = 'none', fg = colors.surface2 },
        RelativeLineNr = { bg = 'none', fg = colors.surface2 },

        LazyNormal = { bg = colors.base, fg = colors.subtext1 },
        MasonNormal = { bg = colors.base, fg = colors.subtext1 },

        NoiceCmdlineIcon = { link = 'FloatBorder' },
        NoiceCmdlineIconCmdLine = { link = 'FloatBorder' },
        NoiceCmdlineIconFilter = { link = 'FloatBorder' },
        NoiceCmdlineIconHelp = { link = 'FloatBorder' },
        NoiceCmdlineIconInput = { link = 'FloatBorder' },
        NoiceCmdlineIconLua = { link = 'FloatBorder' },
        NoiceCmdlineIconRename = { link = 'FloatBorder' },
        NoiceCmdlineIconSearch = { link = 'FloatBorder' },
        NoiceCmdlineIconSubstitute = { link = 'FloatBorder' },
        NoiceCmdlinePopupBorder = { link = 'FloatBorder' },
        NoiceCmdlinePopupBorderCmdLine = { link = 'FloatBorder' },
        NoiceCmdlinePopupBorderFilter = { link = 'FloatBorder' },
        NoiceCmdlinePopupBorderHelp = { link = 'FloatBorder' },
        NoiceCmdlinePopupBorderInput = { link = 'FloatBorder' },
        NoiceCmdlinePopupBorderLua = { link = 'FloatBorder' },
        NoiceCmdlinePopupBorderRename = { link = 'FloatBorder' },
        NoiceCmdlinePopupBorderSearch = { link = 'FloatBorder' },
        NoiceCmdlinePopupBorderSubstitute = { link = 'FloatBorder' },
        NoiceConfirmBorder = { link = 'FloatBorder' },
      }
    end,
  },

  config = function(_, opts)
    require('catppuccin').setup(opts)
    vim.cmd([[colorscheme catppuccin-mocha]])
  end,
}
