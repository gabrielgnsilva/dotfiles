local M = {}

M.search_count = function()
    local sinfo = vim.fn.searchcount({ maxcount = 0 })

    if sinfo.incomplete > 0 then
        return '[?/?]'
    end

    if sinfo.total > 0 then
        return string.format('[%s/%s]', sinfo.current, sinfo.total)
    end

    return '[-/-]'
end

M.lint_status = function()
    local linters = require('lint').get_running()
    if #linters == 0 then
        return '󰦕'
    end
    return '󱉶 ' .. table.concat(linters, ', ')
end

return M
