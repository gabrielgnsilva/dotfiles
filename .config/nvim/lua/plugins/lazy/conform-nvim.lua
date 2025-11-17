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
      json = { 'jq' },
      jsonc = { 'prettier' },
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
      prettier = {
        prepend_args = function()
          local cwd = vim.fn.getcwd()
          local root = vim.fs.find(
            { '.git', 'package.json', '/' },
            { path = cwd, upward = true }
          )[1]
          local dir = cwd
          while dir and dir ~= root do
            for _, fname in ipairs({
              '.prettierrc',
              '.prettierrc.json',
              '.prettierrc.yml',
              '.prettierrc.yaml',
              '.prettierrc.js',
              'prettier.config.js',
            }) do
              if
                vim.fn.filereadable(string.format('%s/%s', dir, fname)) == 1
              then
                return { '--config', string.format('%s/%s', dir, fname) }
              end
            end
            dir = vim.fn.fnamemodify(dir, ':h')
          end
          return {
            '--config',
            string.format('%s/prettierrc.json', rcfiles_path),
          }
        end,
      },
      stylua = {
        prepend_args = {
          '--config-path',
          string.format('%s/stylua.toml', rcfiles_path),
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
      sqlfmt = {
        prepend_args = { '--line-length', '79' },
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
                cmd = function()
                  require('conform').format({}, function(err)
                    if err ~= nil then
                      vim.notify(
                        (
                          err
                          and err
                            :match('([^\n]*)')
                            :match('.-:%s*.-%.%w+:%s*(.*)')
                        )
                          or (err and err:match('([^\n]*)'))
                          or err,
                        vim.log.levels.ERROR,
                        { title = err:match('^[^:]*') }
                      )
                    end
                  end)
                end,
                { buffer = args.buf, desc = 'Format current buffer' },
              },
            },
          },
        })
      end,
    })
  end,
}
