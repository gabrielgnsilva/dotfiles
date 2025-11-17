return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'folke/noice.nvim', 'nvim-tree/nvim-web-devicons' },
  opts = function()
    local C = {}
    C.selection = {
      is_visual_mode = function()
        if not vim.fn.mode():find('[Vv]') then
          return false
        end
        return true
      end,
      count = function()
        local starts = vim.fn.line('v')
        local ends = vim.fn.line('.')
        local lines = starts <= ends and ends - starts + 1 or starts - ends + 1
        return string.format('%dL %dC', lines, vim.fn.wordcount().visual_chars)
      end,
    }
    local last_search_time = nil
    local last_search_term = nil
    local search_count_timeout = 300 -- seconds
    C.search = {
      is_searching = function()
        local search_term = vim.fn.getreg('/')
        -- No active pattern
        if search_term == '' then
          return false
        end
        -- New pattern
        if last_search_term ~= search_term then
          last_search_term = search_term
          last_search_time = os.time()
          return true
        end
        if last_search_time == nil then
          last_search_time = os.time()
          return true
        end
        -- Timeout
        if os.time() > (last_search_time + search_count_timeout) then
          return false
        end
        return true
      end,
      count = function()
        local search_info = vim.fn.searchcount({ maxcount = 0 })
        local search_term = vim.fn.getreg('/')
        if search_info.incomplete > 0 then
          return string.format('/%s [SEARCHING]', search_term)
        end
        if search_info.total > 0 then
          return string.format(
            '/%s [%d/%d]',
            search_term,
            search_info.current,
            search_info.total
          )
        end
        return string.format('/%s [NO MATCHES]', search_term)
      end,
    }
    C.markdown = {
      word_count = function()
        return string.format('%d words', vim.fn.wordcount().words)
      end,
      reading_time = function()
        return string.format(
          '%d min',
          math.ceil(vim.fn.wordcount().words / 200.0)
        )
      end,
      is_markdown = function()
        return vim.bo.filetype == 'markdown' or vim.bo.filetype == 'asciidoc'
      end,
    }
    vim.api.nvim_del_mark('M') -- reset on session start
    C.marks = {
      mark_M = function()
        local m = vim.api.nvim_get_mark('M', {})
        local line, file = m[1], vim.fs.basename(m[4])
        if file == '' then
          return ''
        end
        return string.format(' %s:%d', file, line)
      end,
    }

    local noice = require('noice')
    local status = require('lazy.status')

    local O = {
      options = {
        icons_enabled = false,
        theme = 'kanagawa',
        component_separators = '',
        section_separators = '',
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { 'nvim-tree', 'lazy', 'fzf' },
    }

    -- stylua: ignore start
    local section_a = function (component) table.insert(O.sections.lualine_a, component) end
    local section_b = function (component) table.insert(O.sections.lualine_b, component) end
    local section_c = function (component) table.insert(O.sections.lualine_c, component) end
    local section_x = function (component) table.insert(O.sections.lualine_x, component) end
    local section_z = function (component) table.insert(O.sections.lualine_z, component) end
    local section_y = function (component) table.insert(O.sections.lualine_y, component) end
    -- stylua: ignore end

    -- +---------------------------------------------------+
    -- | >A< | B | C                             X | Y | Z |
    -- +---------------------------------------------------+
    section_a({ 'mode' })

    -- +---------------------------------------------------+
    -- | A | >B< | C                             X | Y | Z |
    -- +---------------------------------------------------+
    section_b({
      'filename',
      file_status = true,
      newfile_status = true,
      path = 0,
      symbols = {
        modified = '[M]',
        readonly = '[R]',
        unnamed = '[?]',
        newfile = '[N]',
      },
    })

    -- +---------------------------------------------------+
    -- | A | B | >C<                             X | Y | Z |
    -- +---------------------------------------------------+
    section_c({
      'diagnostics',
      symbols = {
        error = '󰅙 ',
        info = '󰋼 ',
        hint = '󰌵 ',
        warn = ' ',
      },
    })

    -- +---------------------------------------------------+
    -- | A | B | C                             >X< | Y | Z |
    -- +---------------------------------------------------+
    section_x({ status.updates, cond = status.has_updates })
    section_x({ noice.api.status.mode.get, cond = noice.api.status.mode.has })
    section_x({ C.search.count, cond = C.search.is_searching })
    section_x({ C.marks.mark_M })

    -- +---------------------------------------------------+
    -- | A | B | C                             X | >Y< | Z |
    -- +---------------------------------------------------+
    section_y({ 'branch' })

    -- +---------------------------------------------------+
    -- | A | B | C                             X | Y | >Z< |
    -- +---------------------------------------------------+
    section_z({ C.selection.count, cond = C.selection.is_visual_mode })
    section_z({ C.markdown.word_count, cond = C.markdown.is_markdown })
    section_z({ C.markdown.reading_time, cond = C.markdown.is_markdown })
    section_z({ 'location' })
    section_z({ 'progress' })

    return O
  end,
}
