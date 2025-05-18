return {
  'nvim-telescope/telescope.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'debugloop/telescope-undo.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    { 'nvim-tree/nvim-web-devicons' },
  },
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local undo_actions = require('telescope-undo.actions')
    local theme = require('telescope.themes').get_ivy()
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local make_entry = require('telescope.make_entry')
    local conf = require('telescope.config').values
    local builtin = require('telescope.builtin')
    local extensions = require('telescope').extensions

    local open_with_trouble = require('trouble.sources.telescope').open

    local opts = {
      defaults = vim.tbl_extend('force', theme, {
        preview = {
          filesize_limit = 0.1, -- MB
        },
        vimgrep_arguments = {
          'rg',
          '-L',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
        },
        path_display = { 'smart' },
        prompt_prefix = '   ',
        selection_caret = '  ',
        entry_prefix = '  ',
        initial_mode = 'insert',
        selection_strategy = 'reset',
        file_ignore_patterns = {
          '.git',
          '.github',
          'node_modules',
          'undodir',
        },
        mappings = {
          i = {
            ['qq'] = actions.close,
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-h>'] = actions.select_default,
            ['<c-t>'] = open_with_trouble,
          },
          n = { ['<c-t>'] = open_with_trouble },
        },
      }),
      extensions = {
        'fzf',
        undo = {
          mappings = {
            i = {
              ['<cr>'] = function(bufnr)
                return undo_actions.restore(bufnr)
              end,
            },
            n = {
              ['y'] = function(bufnr)
                return undo_actions.restore(bufnr)
              end,
            },
          },
        },
        'noice',
      },
    }

    telescope.setup(opts)
    for _, extension in ipairs(opts.extensions) do
      telescope.load_extension(extension)
    end

    local multi_grep = function(options)
      options = options or {}
      options.cwd = options.cwd or vim.uv.cwd()
      local finder = finders.new_async_job({
        command_generator = function(prompt)
          if not prompt or prompt == '' then
            return nil
          end

          local pieces = vim.split(prompt, '  ')
          local args = { 'rg' }
          if pieces[1] then
            table.insert(args, '-e')
            table.insert(args, pieces[1])
          end
          if pieces[2] then
            table.insert(args, '-g')
            table.insert(args, pieces[2])
          end

          return vim.tbl_flatten({
            args,
            {
              '--color=never',
              '--no-heading',
              '--with-filename',
              '--line-number',
              '--column',
              '--smart-case',
            },
          })
        end,
        entry_maker = make_entry.gen_from_vimgrep(options),
        cwd = options.cwd,
      })

      pickers
        .new(options, {
          debounce = 100,
          prompt_title = 'Multi Grep',
          finder = finder,
          previewer = conf.grep_previewer(options),
          sorter = require('telescope.sorters').empty(),
        })
        :find()
    end
    local find_files = function()
      builtin.find_files({ cwd = vim.fn.stdpath('config') })
    end

    require('core.utils').load_keymaps({
      {
        mode = { 'n' },
        bindings = {
          {
            key = '<leader>fh',
            cmd = builtin.help_tags,
            desc = 'Telescope fuzzy find help tag',
          },
          {
            key = '<leader>fd',
            cmd = builtin.diagnostics,
            desc = 'Telescope fuzzy find files on cwd',
          },
          {
            key = '<leader>fb',
            cmd = builtin.buffers,
            desc = 'Telescope fuzzy find curenltly open buffers',
          },
          {
            key = '<leader>ff',
            cmd = builtin.find_files,
            desc = 'Telescope fuzzy find files on cwd',
          },
          {
            key = '<leader>fg',
            cmd = builtin.git_files,
            desc = 'Telescope fuzzy find git files on cwd',
          },
          {
            key = '<leader>fr',
            cmd = builtin.oldfiles,
            desc = 'Telescope fuzzy find recend files',
          },
          {
            key = '<leader>fu',
            cmd = extensions.undo.undo,
            desc = 'Telescope fuzzy find undo history on cwd',
          },
          {
            key = '<leader>fs',
            cmd = multi_grep,
            desc = 'Telescope fuzzy find string on worktree',
          },
          {
            key = '<leader>f/',
            cmd = builtin.current_buffer_fuzzy_find,
            desc = 'Telescope fuzzy find string on current buffer',
          },
          {
            key = '<leader>fn',
            cmd = find_files,
            desc = 'Telescope fuzzy find neovim config files',
          },
        },
      },
    })
  end,
}
