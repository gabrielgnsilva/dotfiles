--[[
  Theme is not lazy loaded because it needs to be loaded before all other
  plugins to ensure that the colors are applied correctly.
]]

local colors = {
  background = '#2D353B',
  foreground = '#D3C6AA',

  gray0 = '#7A8478',
  gray1 = '#859289',
  gray2 = '#9DA9A0',
}

local highlights = {
  FloatBorder = { bg = 'none' },
  FloatTitle = { bg = 'none' },

  Normal = { bg = 'none' },
  NormalFloat = { bg = 'none' },

  LineNr = { bg = 'none', fg = colors.gray0 },

  RelativeLineNr = { bg = 'none', fg = colors.gray0 },

  CursorLineNr = { bg = 'none', fg = colors.gray2 },

  LazyNormal = { bg = colors.background, fg = colors.foreground },

  MasonNormal = { bg = colors.background, fg = colors.foreground },

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

return {
  'sainnhe/everforest',
  priority = 1000,
  config = function()
    vim.o.background = 'dark'
    vim.g.everforest_background = 'medium'
    vim.g.everforest_better_performance = 1

    vim.cmd.colorscheme('everforest')
    for group, opts in pairs(highlights) do
      vim.api.nvim_set_hl(0, group, opts)
    end
  end,
}
