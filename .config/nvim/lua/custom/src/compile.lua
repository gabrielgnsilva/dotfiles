local function run_groff(filePath)
  local result = vim.fn.system(
    string.format(
      'groff -ms %s -Tpdf > %s.pdf',
      filePath,
      filePath:gsub('%.%w+$', '')
    )
  )
  return result
end

local function run_with_refer(filePath)
  local result = vim.fn.system(
    string.format(
      'refer -PS -e -p bibliography %s | groff -ms -Tpdf >> %s.pdf',
      filePath,
      filePath:gsub('%.%w+$', '')
    )
  )
  return result
end

local function run_biblatex(filePath)
  local result =
    vim.fn.system(string.format('biber %s', filePath:gsub('%.%w+$', '')))
  return result
end
local function compile_latex(filePath)
  local result = vim.fn.system(string.format('pdflatex %s', filePath))
  return result
end

local function Compile()
  local filePath = vim.api.nvim_buf_get_name(0)


  -- stylua: ignore start
  if filePath and vim.bo.filetype == 'nroff' then
    local bufferContent = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')
    local hasBibliograpy = bufferContent:match("%.%[%s*.-%s*%.%]")
    local result

    if hasBibliograpy then
      result = run_with_refer(filePath)
    else
      result = run_groff(filePath)
    end
    if vim.v.shell_error == 0 then
      vim.notify(string.format('%s compiled successfully with groff!', filePath), vim.log.levels.INFO)
    else
      vim.notify( string.format('Error compiling %s:\n\n%s', filePath, result), vim.log.levels.ERROR)
    end

    return
  end

  if filePath and vim.bo.filetype == 'tex' then
    local result = compile_latex(filePath)
    if vim.v.shell_error == 0 then
      local bufferContent = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')
      local hasReference = bufferContent:match('\\ref{.-}')
      local hasBibliograpy = bufferContent:match('\\printbibliography')
      local hasTableOfContents = bufferContent:match('\\tableofcontents')

      if hasReference then
        result = compile_latex(filePath)
        if vim.v.shell_error ~= 0 then
          vim.notify( string.format('Error compiling %s:\n\n%s', filePath, result), vim.log.levels.ERROR)
          return
        end
      end
      if hasBibliograpy then
        result = run_biblatex(filePath)
        if vim.v.shell_error ~= 0 then
          vim.notify( string.format('Error compiling %s:\n\n%s', filePath, result), vim.log.levels.ERROR)
          return
        end
        result = compile_latex(filePath)
        if vim.v.shell_error ~= 0 then
          vim.notify( string.format('Error compiling %s:\n\n%s', filePath, result), vim.log.levels.ERROR)
          return
        end
      end
      if hasTableOfContents then
        result = compile_latex(filePath)
        if vim.v.shell_error ~= 0 then
          vim.notify( string.format('Error compiling %s:\n\n%s', filePath, result), vim.log.levels.ERROR)
          return
        end
      end
        vim.notify( string.format('%s compiled successfully with pdflatex!', filePath), vim.log.levels.INFO)
    else
      vim.notify( string.format('Error compiling %s:\n\n%s', filePath, result), vim.log.levels.ERROR)
    end
  else
    vim.notify(
      string.format('No compiler configured for %s !', vim.bo.filetype)
    )
  end
  -- stylua: ignore end
end

vim.api.nvim_create_user_command('Compile', Compile, {})
require('utils.mappings').load_keymap({
  {
    mode = { 'n' },
    bindings = {
      {
        key = '<leader>mc',
        cmd = '<cmd>:Compile<cr>',
        desc = 'Compile current file',
      },
    },
  },
})
