local U = {}

---@param name string
---@param event string|string[]
---@param opts? vim.api.keyset.create_autocmd
U.create_autocmd = function(name, event, opts)
  opts = opts or {}
  event = type(event) == 'table' and event or { event }

  local bufnr = nil
  if opts.buffer == 0 then
    bufnr = vim.api.nvim_get_current_buf()
  elseif opts.buffer ~= nil then
    bufnr = opts.buffer
  end

  local group_name = bufnr
      and string.format('UserGroup_%s_buf_%d', name, bufnr)
    or string.format('UserGroup_%s', name)
  local group = vim.api.nvim_create_augroup(group_name, { clear = false })

  vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
  vim.api.nvim_create_autocmd(
    event,
    vim.tbl_deep_extend('force', opts, {
      group = group,
      buffer = bufnr,
      -- callback = function(args)
      --   vim.notify(string.format('%s was called back', name))
      --   opts.callback(args)
      -- end,
    })
  )
end

U.split = function(inputstr, sep)
  if sep == nil then
    sep = '%s'
  end
  local t = {}
  for str in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
    table.insert(t, str)
  end
  return t
end

U.normalize_list = function(t)
  local list = {}
  for _, v in pairs(t) do
    if v ~= nil then
      table.insert(list, v)
    end
  end
  return list
end

U.getCommentString = function()
  local comment_syntax = vim.api.nvim_get_option_value('commentstring', {
    buf = 0,
  })
  if comment_syntax == '' then
    return { '#', '%s', nil }
  else
    local syntax = U.split(comment_syntax, '%s')
    if #syntax == 3 then
      return { syntax[1], '%s', syntax[3] }
    else
      return { syntax[1], '%s', nil }
    end
  end
end
U.commentString = function(string)
  local syntax = U.getCommentString()
  if syntax[3] ~= nil then
    return table.concat(syntax, ' '):format(string)
  end
  return table.concat({ syntax[1], syntax[2] }, ' '):format(string)
end
U.commentStart = function(autospace)
  local syntax = U.getCommentString()
  if syntax[1] == '%s' then
    return ''
  end
  if autospace == false then
    return syntax[1]
  end
  return syntax[1] .. ' '
end
U.commentEnd = function(autospace)
  local syntax = U.getCommentString()
  if syntax[3] == nil then
    return ''
  end
  if autospace == false then
    return syntax[3]
  end
  return ' ' .. syntax[3]
end
-- #regionend

return U
