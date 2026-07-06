local M = {}

M._installed = nil ---@type table<string,boolean>?
M._queries = {} ---@type table<string,boolean>

---@param update boolean?
function M.get_installed(update)
  if update then
    M._installed, M._queries = {}, {}
    for _, lang in ipairs(require('nvim-treesitter').get_installed('parsers')) do
      M._installed[lang] = true
    end
  end
  return M._installed or {}
end

---@param lang string
---@param query string
function M.have_query(lang, query)
  local key = lang .. ':' .. query
  if M._queries[key] == nil then
    M._queries[key] = vim.treesitter.query.get(lang, query) ~= nil
  end
  return M._queries[key]
end

---@param what string|number|nil
---@overload fun(buf?:number):string|nil
---@overload fun(lang:string):string|nil
M.lang = function(what)
  what = what or vim.api.nvim_get_current_buf()
  what = type(what) == 'number' and vim.bo[what].filetype or what --[[@as string]]
  return vim.treesitter.language.get_lang(what)
end

---@param what string|number|nil
---@param query? string
---@overload fun(buf?:number):boolean
---@overload fun(ft:string):boolean
---@return boolean
function M.have(what, query)
  local lang = M.lang(what)
  if lang == nil or M.get_installed()[lang] == nil then
    return false
  end
  if query and not M.have_query(lang, query) then
    return false
  end
  return true
end

M.start_treesitter = function()
  vim.filetype.add({
    extension = {
      info = 'properties',
      ftl = 'html',
    },
    pattern = {
      ['.*/hypr/.*%.conf'] = 'hyprlang',
      ['.*/sway/.*%.conf'] = 'swayconfig',
      ['.env.*'] = 'dosini',
    },
  })
  vim.treesitter.language.register('html', 'ftl')
  vim.treesitter.language.register('html', 'htmlangular')
  vim.treesitter.language.register('properties', 'info')

  require('utils').create_autocmd('treesitter_start', 'FileType', {
    desc = 'Enables treesitter',
    callback = function(args)
      local lang = M.lang(args.match)
      if not M.have(lang) then
        vim.bo[args.buf].syntax = 'on' -- fallback to syntax highlighting
        return
      end

      vim.treesitter.start(args.buf, lang)

      vim.api.nvim_set_option_value(
        'indentexpr',
        "v:lua.require'nvim-treesitter'.indentexpr()",
        { scope = 'local' }
      )
      vim.api.nvim_set_option_value(
        'foldexpr',
        'v:lua.vim.treesitter.foldexpr()',
        { scope = 'local' }
      )

      if not M.have(lang, 'textobjects') then
        return
      end

      local map = { mode = { 'n', 'x', 'o' }, bindings = {} }
      local moves = vim.tbl_get(
        require('configs.treesitter'),
        'textobjects',
        'move'
      ) or {}
      for method, keymaps in pairs(moves) do
        for key, query in pairs(keymaps) do
          local desc = query:gsub('@', ''):gsub('%..*', '')
          desc = desc:sub(1, 1):upper() .. desc:sub(2)
          desc = (key:sub(1, 1) == '[' and 'Prev ' or 'Next ') .. desc
          desc = desc
            .. (key:sub(2, 2) == key:sub(2, 2):upper() and ' End' or ' Start')
          if not (vim.wo.diff and key:find('[cC]')) then
            table.insert(map.bindings, {
              key = key,
              cmd = function()
                require('nvim-treesitter-textobjects.move')[method](
                  query,
                  'textobjects'
                )
              end,
              desc = desc,
              opts = { buffer = args.buf, silent = true },
            })
          end
        end
      end
      require('utils.mappings').load_keymap({ map })
    end,
  })
end

return M
