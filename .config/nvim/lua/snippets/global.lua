local s = require('utils.snippets')
local utils = require('utils')

local section_width = function()
  local textwidth = vim.bo.textwidth
  if textwidth > 0 then
    return textwidth
  end

  for column in vim.wo.colorcolumn:gmatch('[^,]+') do
    local absolute = tonumber(column:match('^%d+$'))
    if absolute then
      return math.max(1, absolute - 1)
    end
  end

  return vim.o.columns
end

local section_body = function()
  local start = utils.commentStart()
  local end_ = utils.commentEnd()
  local marker_width = math.max(0, section_width() - #start - #end_)
  local marker = start .. string.rep('=', marker_width) .. end_

  return table.concat({
    marker,
    start .. '${1:FILE TITLE}' .. end_,
    start .. string.rep('-', marker_width) .. end_,
    start .. '${2:description}' .. end_,
    marker,
  }, '\n')
end

local separator_body = function(prefix, placeholder, fill)
  local start = utils.commentStart()
  local end_ = utils.commentEnd()
  local marker_width = math.max(
    0,
    section_width() - #start - #prefix - #placeholder - 1 - #end_
  )

  return table.concat({
    start .. prefix .. '${1:' .. placeholder .. '} ' .. string.rep(fill, marker_width) .. end_,
  }, '\n')
end

s.add_global({
  trigger = 'shebang',
  body = [[#!/usr/bin/env ${1|bash,python3,node|}
]],
  description = 'Shebang line',
})

s.add_global({
  trigger = 'title',
  body = section_body,
  description = 'File title separator',
})

s.add_global({
  trigger = 'section',
  body = function()
    return separator_body('== ', 'SECTION NAME', '=')
  end,
  description = 'Section separator',
})

s.add_global({
  trigger = 'subsection',
  body = function()
    return separator_body('-- ', 'subsection name', '-')
  end,
  description = 'Subsection separator',
})

s.add_global({
  trigger = 'block',
  body = function()
    return separator_body('.. ', 'block name', '.')
  end,
  description = 'Small block separator',
})
