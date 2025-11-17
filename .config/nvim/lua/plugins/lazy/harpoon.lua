return {
  'ThePrimeagen/harpoon',
  dependencies = { 'folke/snacks.nvim' },
  event = { 'BufNewFile', 'BufReadPost' },
  branch = 'harpoon2',
  opts = {},
  config = function(_, opts)
    local harpoon = require('harpoon')
    local function get_current_file_name()
      return vim.fn.expand('%:t')
    end

    harpoon:setup(opts)

    require('utils.mappings').load_keymap({
      {
        mode = { 'n' },
        bindings = {
          {
            key = '<leader>hh',
            cmd = function()
              require('snacks').picker.pick({
                source = 'Harpoon',
                format = 'text',
                preview = 'none',
                layout = { preset = 'select' },
                win = {
                  input = {
                    keys = { ['dd'] = { 'harpoon_del', mode = { 'n', 'x' } } },
                  },
                  list = {
                    keys = { ['dd'] = { 'harpoon_del', mode = { 'n', 'x' } } },
                  },
                },
                actions = {
                  harpoon_del = function(picker, item)
                    local file = item or picker:selected()
                    harpoon:list():remove({ value = file.text })
                    harpoon:list().items =
                      require('utils').normalize_list(harpoon:list().items)
                    picker:find({ refresh = true })
                  end,
                },
                finder = function()
                  local file_paths = {}
                  for _, item in ipairs(harpoon:list().items) do
                    table.insert(
                      file_paths,
                      { text = item.value, file = item.value }
                    )
                  end
                  return file_paths
                end,
              })
            end,
            desc = 'Harpoon toggle harpoon menu',
          },
          {
            key = '<leader>ah',
            cmd = function()
              harpoon:list():add()
              vim.notify('Harpooned ' .. get_current_file_name())
            end,
            desc = 'Harpoon add file to harpoon',
          },
          {
            key = '<leader>rh',
            cmd = function()
              harpoon:list():remove()
              vim.notify('Unharpooned ' .. get_current_file_name())
            end,
            desc = 'Harpoon remove file to harpoon',
          },
          {
            key = '<leader>nh',
            cmd = function()
              harpoon:list():next()
              vim.notify('Harpooned to ' .. get_current_file_name())
            end,
            desc = 'Harpoon select next harpoon file',
          },
          {
            key = '<leader>ph',
            cmd = function()
              harpoon:list():prev()
              vim.notify('Harpooned to ' .. get_current_file_name())
            end,
            desc = 'Harpoon select prev harpoon file',
          },
        },
      },
    })
  end,
}
