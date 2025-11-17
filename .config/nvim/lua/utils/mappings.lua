local M = {}

---@param map string|function|table
---@param opts? vim.keymap.set.Opts
M.load_keymap = function(map, opts)
  local O
  if type(map) == 'table' then
    O = map
  elseif type(map) == 'function' then
    O = map()
  else
    O = require('mappings')[map]
    if type(O) == 'function' then
      O = O(map, opts)
    end
  end

  for _, row in ipairs(O) do
    for _, binding in pairs(row.bindings) do
      local keys = type(binding.key) == 'string' and { binding.key }
        or binding.key
      for _, key in ipairs(keys) do
        local options =
          vim.tbl_extend('force', { desc = binding.desc }, binding.opts or {})
        vim.keymap.set(
          row.mode,
          key,
          binding.cmd,
          vim.tbl_extend('force', opts or {}, options)
        )
      end
    end
  end
end

return M
