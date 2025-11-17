return {
  'rebelot/kanagawa.nvim',
  name = 'kanagawa',
  priority = 1000,
  opts = {
    transparent = true,
    overrides = function(colors)
      local theme = colors.theme
      return {
        FloatBorder = { bg = 'none' },
        FloatTitle = { bg = 'none' },
        Normal = { bg = 'none' },
        NormalFloat = { bg = 'none' },
        LineNr = { bg = 'none' },
        RelativeLineNr = { bg = 'none', fg = '#50A0C0' },

        LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
        MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

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
    require('kanagawa').setup(opts)
    vim.cmd([[colorscheme kanagawa]])
  end,
}
