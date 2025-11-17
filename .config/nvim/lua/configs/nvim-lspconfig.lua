local create_autocmd = require('utils').create_autocmd

local M = {}

---@type vim.diagnostic.Opts
M.diagnostics = {
  underline = false,
  update_in_insert = false,
  float = { border = 'rounded', source = 'if_many' },
  -- virtual_text = { spacing = 4, prefix = '', source = 'if_many' },
  virtual_text = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅙',
      [vim.diagnostic.severity.INFO] = '󰋼',
      [vim.diagnostic.severity.HINT] = '󰌵',
      [vim.diagnostic.severity.WARN] = '',
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
      [vim.diagnostic.severity.INFO] = 'InfoMsg',
      [vim.diagnostic.severity.HINT] = 'HintMsg',
      [vim.diagnostic.severity.WARN] = 'WarnMsg',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
      [vim.diagnostic.severity.INFO] = 'InfoMsg',
      [vim.diagnostic.severity.HINT] = 'HintMsg',
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
    },
  },
}

---@type vim.lsp.client.on_attach_cb
M.on_attach = function(client, bufnr)
  require('utils.diagnostics').exclude({
    {
      message = 'Could not parse linter output due to: Expected value but found invalid token at character 1\noutput: Error: Could not find config file.',
      source = 'eslint_d',
      reason = 'Annoying eslint message when no config file is present',
    },
  })

  vim.diagnostic.config(vim.deepcopy(M.diagnostics))

  if client:supports_method('textDocument/inlayHint') then
    if
      vim.api.nvim_buf_is_valid(bufnr)
      and vim.bo[bufnr].buftype == ''
      and not vim.tbl_contains({ 'vue' }, vim.bo[bufnr].filetype)
    then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
  end

  if client:supports_method('textDocument/foldingRange') then
    ---@diagnostic disable-next-line: undefined-field
    if vim.opt.foldexpr:get() == '0' then
      vim.opt.foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end
  end

  if client:supports_method('textDocument/codeLens') then
    vim.lsp.codelens.refresh({ bufnr = bufnr })
    create_autocmd(
      'CodeLensRefresh',
      { 'BufEnter', 'CursorHold', 'InsertLeave' },
      {
        desc = 'Refresh LSP CodeLens',
        buffer = bufnr,
        callback = vim.lsp.codelens.refresh,
      }
    )
  end

  if
    not client:supports_method('textDocument/willSaveWaitUntil')
    and client:supports_method('textDocument/formatting')
  then
    create_autocmd('ConformAutoFormat', { 'BufWritePre' }, {
      desc = 'Auto format current buffer on save',
      buffer = bufnr,
      callback = function()
        require('conform').format({ bufnr = bufnr })
      end,
    })
  end

  require('utils.mappings').load_keymap({
    {
      mode = 'n',
      bindings = {
        {
          key = 'gd',
          cmd = vim.lsp.buf.definition,
          { buffer = bufnr, desc = 'LSP Go to definition' },
        },
        {
          key = 'gD',
          cmd = vim.lsp.buf.declaration,
          { buffer = bufnr, desc = 'LSP Go to declaration' },
        },
        {
          key = 'gi',
          cmd = vim.lsp.buf.implementation,
          { buffer = bufnr, desc = 'LSP Go to implementation' },
        },
        {
          key = 'go',
          cmd = vim.lsp.buf.type_definition,
          { buffer = bufnr, desc = 'LSP Go to type definition' },
        },
        {
          key = 'gr',
          cmd = vim.lsp.buf.references,
          { buffer = bufnr, desc = 'LSP Show references' },
        },
        {
          key = 'H',
          cmd = vim.lsp.buf.hover,
          { buffer = bufnr, desc = 'LSP Show hover information' },
        },
        {
          key = '<leader>rn',
          cmd = vim.lsp.buf.rename,
          { buffer = bufnr, desc = 'LSP Rename symbol' },
        },
        {
          key = '<leader>ca',
          cmd = vim.lsp.buf.code_action,
          { buffer = bufnr, desc = 'LPS Show code actions' },
        },
        {
          key = '<leader>ls',
          cmd = vim.diagnostic.setloclist,
          { buffer = bufnr, desc = 'LSP diagnostic loclist' },
        },
      },
    },
  })

  if client.server_capabilities.signatureHelpProvider then
    require('utils.mappings').load_keymap({
      mode = 'n',
      bindings = {
        {
          key = 'gh',
          cmd = vim.lsp.buf.signature_help,
          { buffer = bufnr, desc = 'LSP Show signature help' },
        },
      },
    })
  end
end

---@type vim.lsp.client.on_init_cb
M.on_init = function(client, _)
  local settings = M.servers[client.name]
  if type(settings) ~= 'table' then
    settings = {}
  end

  if client:supports_method('textDocument/semanticTokens') then
    client.server_capabilities.semanticTokensProvider = nil
  end

  -- Override server capabilities
  ---@diagnostic disable-next-line: undefined-field
  if settings.override_capabilities then
    ---@diagnostic disable-next-line: undefined-field
    for k, v in pairs(settings.override_capabilities) do
      client.server_capabilities[k] = v
    end
  end
end

---@type lsp.ClientCapabilities
M.capabilities = vim.tbl_deep_extend(
  'force',
  vim.lsp.protocol.make_client_capabilities(),
  require('cmp_nvim_lsp').default_capabilities(),
  { workspace = { fileOperations = { didRename = true, willRename = true } } }
)
M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { 'markdown', 'plaintext' },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = { 'documentation', 'detail', 'additionalTextEdits' },
  },
}

---@type table<string, vim.lsp.Config | boolean>
M.servers = {
  ['*'] = {
    capabilities = vim.deepcopy(M.capabilities),
    on_init = M.on_init,
    root_markers = { '.git', 'package.json' },
  },
  angularls = true,
  bashls = true,
  clangd = {
    init_options = {
      clangdFileStatus = true,
    },
    filetypes = { 'c' },
  },
  cssls = true,
  emmet_ls = {
    filetypes = {
      'css',
      'eruby',
      'html',
      'htmlangular',
      'javascript',
      'javascript.jsx',
      'javascriptreact',
      'less',
      'pug',
      'sass',
      'scss',
      'svelte',
      'typescript',
      'typescript.tsx',
      'typescriptreact',
      'vue',
    },
  },
  gopls = {
    settings = {
      gopls = {
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  },
  graphql = true,
  html = true,
  jdtls = false,
  jsonls = {
    override_capabilities = { documentFormattingProvider = false },
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
      },
    },
  },
  lemminx = true,
  lua_ls = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = {
      '.git',
      '.luacheckrc',
      '.luarc.json',
      '.luarc.jsonc',
      '.stylua.toml',
      'lazy-lock.json',
      'selene.toml',
      'selene.yml',
      'stylua.toml',
    },
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        completion = { callSnippet = 'Replace' },
        diagnostics = { globals = { 'vim' } },
        workspace = {
          library = {
            vim.fn.expand('$VIMRUNTIME/lua'),
            vim.fn.expand('$VIMRUNTIME/lua/vim/lsp'),
            vim.fn.stdpath('data') .. '/lazy/lazy.nvim/lua/lazy',
            vim.fn.stdpath('data') .. '/lazy/cmp-nvim-lsp/lua/cmp_nvim_lsp',
            '${3rd}/luv/library',
          },
          maxPreload = 100000,
          preloadFileSize = 1000,
        },
      },
    },
  },
  pyright = true,
  ruff = true,
  rust_analyzer = true,
  sqls = true,
  svelte = true,
  tailwindcss = {
    filetypes = {
      'css',
      'html',
      'htmlangular',
      'javascript',
      'javascript.jsx',
      'javascriptreact',
      'scss',
      'svelte',
      'typescript',
      'typescript.tsx',
      'typescriptreact',
      'vue',
    },
  },
  vtsls = {
    override_capabilities = { documentFormattingProvider = false },
    settings = {
      complete_function_calls = true,
      vtsls = {
        enableMoveToFileCodeAction = true,
        autoUseWorkspaceTsdk = true,
        experimental = {
          maxInlayHintLength = 30,
          completion = { enableServerSideFuzzyMatch = true },
        },
      },
      javascript = {
        updateImportsOnFileMove = { enabled = 'always' },
        suggest = { completeFunctionCalls = true },
      },
      typescript = {
        updateImportsOnFileMove = { enabled = 'always' },
        suggest = { completeFunctionCalls = true },
      },
    },
  },
  yamlls = {
    settings = {
      yaml = {
        schemaStore = { enable = false, url = '' },
        schemas = require('schemastore').yaml.schemas(),
      },
    },
  },
}

return M
