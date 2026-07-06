local M = {}

M._installed = nil ---@type table<string,boolean>?

---@param update boolean?
function M.get_installed(update)
  if update then
    M._installed = {}
    for lang, _ in pairs(require('conform').formatters_by_ft) do
      M._installed[lang] = true
    end
  end
  return M._installed or {}
end

---@param what string|number|nil
---@overload fun(buf?:number):string
---@overload fun(lang:string):string
M.lang = function(what)
  what = what or vim.api.nvim_get_current_buf()
  return type(what) == 'number' and vim.bo[what].filetype or what --[[@as string]]
end

---@param what string|number|nil
---@overload fun(buf?:number):boolean
---@overload fun(ft:string):boolean
---@return boolean
function M.have(what)
  local lang = M.lang(what)
  if lang == nil or M.get_installed()[lang] == nil then
    return false
  end
  return true
end

return M
