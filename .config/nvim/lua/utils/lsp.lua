local M = {}

M._deferred = nil

function M.supports_method(action, bufnr)
  for _, lsp_client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if lsp_client:supports_method(action) then
      return true
    end
  end
  return false
end

function M.resolve_config(config)
  if type(config) == 'function' then
    return config()
  end
  return config or {}
end

function M.enable(server, spec)
  if spec == true then
    vim.lsp.enable(server)
    return
  end

  if spec == false then
    return
  end

  if type(spec) == 'table' and spec.defer == true then
    M._deferred = M._deferred or {}
    M._deferred[server] = false

    require('utils').create_autocmd(
      string.format('lsp_defer_%s', server),
      'FileType',
      {
        pattern = spec.filetypes or {},
        callback = function(args)
          if M._deferred[server] == true then
            return
          end
          M._deferred[server] = true
          local config = M.resolve_config(spec.config)
          if type(config) == 'table' and next(config) ~= nil then
            vim.lsp.config(server, config)
          end
          vim.lsp.enable(server)
        end,
      }
    )
    return
  end

  local config = M.resolve_config(spec.config)
  if type(config) == 'table' and next(config) ~= nil then
    vim.lsp.config(server, config)
  end
  if server ~= '*' and config ~= false then
    vim.lsp.enable(server)
  end
end

return M
