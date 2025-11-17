return {
  'windwp/nvim-ts-autotag',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    aliases = { ['ftl'] = 'html' },
  },
}
