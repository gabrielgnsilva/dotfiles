local M = {}

--- @type table<string, table[]>
M._snippets = {}
M._cache = {}

--- @param ft string
M.has_snippets = function(ft)
  return vim.tbl_contains(vim.tbl_keys(M._snippets), ft)
end

--- @param ft string
M.add_by_ft = function(ft, snippet)
  if not M.has_snippets(ft) then
    M._snippets[ft] = {}
  end
  table.insert(M._snippets[ft], snippet)
end

--- @param snippet table
M.add_global = function(snippet)
  if not M.has_snippets('___ALL') then
    M._snippets['___ALL'] = {}
  end
  table.insert(M._snippets['___ALL'], snippet)
end

M.get_snippets = function()
  return vim.deepcopy(M._snippets)
end

--- @param bufnr? number
M.get_buf_snippets = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype
  local snippets = vim.list_slice(M._snippets['___ALL'] or {})

  if M.has_snippets(ft) then
    vim.list_extend(snippets, M._snippets[ft])
  end

  return snippets
end

M._resolve_body = function(snippet, bufnr)
  if type(snippet.body) == 'function' then
    return snippet.body(bufnr)
  end
  return snippet.body
end

M._load_snippets = function()
  local snippet_files = vim.fn.glob(
    string.format('%s/lua/snippets/**/*.lua', vim.fn.stdpath('config')),
    true,
    true
  )

  for _, file in ipairs(snippet_files) do
    local fn, err = loadfile(file)
    if fn then
      fn()
    else
      vim.notify(
        string.format('Error loading snippet file "%s": %s', file, err),
        vim.log.levels.ERROR
      )
    end
  end
end

M.reload_snippets = function()
  M._snippets = {}
  M._cache = {}
  M._load_snippets()
  vim.notify('Snippets reloaded', vim.log.levels.INFO)
end

M.setup = function()
  M._load_snippets()

  require('cmp').register_source('vim.snippet', {
    complete = function(_, _, callback)
      local bufnr = vim.api.nvim_get_current_buf()
      local completion_items = vim.tbl_map(function(s)
        --- @type lsp.CompletionItem
        return {
          word = s.trigger,
          label = s.trigger,
          kind = vim.lsp.protocol.CompletionItemKind.Snippet,
          insertText = M._resolve_body(s, bufnr),
          insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
          documentation = { kind = 'markdown', value = s.description or '' },
        }
      end, M.get_buf_snippets(bufnr))
      callback(completion_items)
    end,
  })

  vim.keymap.set(
    'n',
    '<leader>rs',
    M.reload_snippets,
    { desc = 'Reload snippets' }
  )
end

return M
