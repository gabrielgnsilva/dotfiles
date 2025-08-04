local function notify(err)
  if err ~= nil then
    vim.notify(
      (err and err:match('([^\n]*)'):match('.-:%s*.-%.%w+:%s*(.*)'))
        or (err and err:match('([^\n]*)'))
        or err,
      'error',
      { title = err:match('^[^:]*') }
    )
  end
end
return {
  'stevearc/conform.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    local conform = require('conform')
    conform.setup({
      notify_on_error = false,
      default_format_opts = {
        timeout_ms = 3000,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
        lsp_format = 'fallback', -- not recommended to change
      },
      formatters_by_ft = {
        c = { 'clang-format' },
        c_sharp = { 'clang-format' },
        cpp = { 'clang-format' },
        css = { 'prettier' },
        htmlangular = { 'prettier' },
        html = function(bufnr)
          if vim.api.nvim_buf_get_name(bufnr):match('%.ftl$') then
            return { 'prettier' }
          else
            return { 'prettier' }
          end
        end,
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        json = { 'prettier' },
        markdown = { 'prettier' },
        scss = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        yaml = { 'yamlfmt' },
        go = { 'gofumpt', 'golines', 'goimports-reviser' },
        lua = { 'stylua' },
        python = { 'black', 'isort' },
        rust = { 'rustfmt' },
        bash = { 'shfmt' },
        zsh = { 'shfmt' },
        sh = { 'shfmt' },
        mysql = { 'sqlfmt' },
        sql = { 'sqlfmt' },
        tex = { 'tex-fmt' },
        bib = { 'bibtex-tidy' },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
        prettier = require('plugins.lazy.configs.conform.formatters.prettier'),
        stylua = require('plugins.lazy.configs.conform.formatters.stylua'),
        shfmt = require('plugins.lazy.configs.conform.formatters.shfmt'),
        sqlfmt = require('plugins.lazy.configs.conform.formatters.sqlfmt'),
      },
    })
    require('core.utils').load_keymaps({
      {
        mode = { 'n', 'v', 'x' },
        bindings = {
          {
            key = '<leader>mp',
            cmd = function()
              conform.format({}, notify)
            end,
            desc = 'Format current buffer',
          },
        },
      },
    })
  end,
}
