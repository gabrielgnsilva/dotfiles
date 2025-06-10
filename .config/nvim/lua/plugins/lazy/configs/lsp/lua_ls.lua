return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
    'lazy-lock.json',
    '.git',
  },
  settings = {
    ['lua_ls'] = {
      completion = { callSnippet = 'Replace' },
      diagnostics = { globals = { 'vim' } },
      workspace = {
        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        [vim.fn.stdpath('data') .. '/lazy/lazy.nvim/lua/lazy'] = true,
      },
      maxPreload = 100000,
      preloadFileSize = 1000,
    },
  },
}
