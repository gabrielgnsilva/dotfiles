local rcfiles_path =
  string.format('%s/configs/conform', vim.fn.stdpath('config'))

return {
  'stevearc/conform.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    notify_on_error = false,
    default_format_opts = {
      timeout_ms = 3000,
      async = false, -- not recommended to change
      quiet = false, -- not recommended to change
      lsp_format = 'fallback', -- not recommended to change
    },
    formatters_by_ft = {
      bash = { 'shfmt' },
      bib = { 'bibtex-tidy' },
      c = { 'clang-format' },
      c_sharp = { 'clang-format' },
      cpp = { 'clang-format' },
      css = { 'prettier' },
      go = { 'gofumpt', 'golines', 'goimports-reviser' },
      html = { 'prettier' },
      htmlangular = { 'prettier' },
      javascript = { 'prettier' },
      javascriptreact = { 'prettier' },
      json = { 'jq' },
      jsonc = { 'prettier' },
      lua = { 'stylua' },
      markdown = { 'prettier' },
      mysql = { 'sqlfmt' },
      python = { 'black', 'isort' },
      rust = { 'rustfmt' },
      scss = { 'prettier' },
      sh = { 'shfmt' },
      sql = { 'sqlfmt' },
      tex = { 'tex-fmt' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      xml = { 'tidy' },
      yaml = { 'yamlfmt' },
      zsh = { 'shfmt' },
    },
    formatters = {
      injected = { options = { ignore_errors = true } },
      prettier = {
        prepend_args = {
          '--config',
          string.format('%s/prettierrc.json', rcfiles_path),
        },
      },
      shfmt = {
        prepend_args = {
          '--indent',
          '4',
          '--binary-next-line',
          '--case-indent',
          '--space-redirects',
        },
      },
      sqlfmt = { prepend_args = { '--line-length', '79' } },
      stylua = {
        prepend_args = {
          '--config-path',
          string.format('%s/stylua.toml', rcfiles_path),
        },
      },
      tidy = {
        prepend_args = {
          '-xml',
          '-indent',
          '-wrap',
          '79',
          '-quiet',
          '-asxml',
          '-utf8',
        },
      },
    },
  },
  config = function(_, opts)
    local CF = require('utils.conform-nvim')

    require('conform').setup(opts)
    CF.get_installed(true) -- Caches all installed langs

    require('utils').create_autocmd('conform', 'FileType', {
      desc = 'Enables conform',
      callback = function(args)
        local lang = CF.lang(args.match)

        if not CF.have(lang) then
          return
        end

        vim.api.nvim_set_option_value(
          'formatexpr',
          "v:lua.require'conform'.formatexpr()",
          { scope = 'local' }
        )

        require('utils.mappings').load_keymap({
          {
            mode = { 'n', 'v', 'x' },
            bindings = {
              {
                key = '<leader>mp',
                cmd = require('utils').format,
                desc = 'Format current buffer',
                opts = { buffer = args.buf },
              },
            },
          },
        })
      end,
    })
  end,
}
