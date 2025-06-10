return {
  'ThePrimeagen/harpoon',
  event = { 'BufNewFile', 'BufReadPost' },
  dependencies = { 'nvim-lua/plenary.nvim' },
  branch = 'harpoon2',
  config = function()
    local harpoon = require('harpoon')
    harpoon:setup()

    local toggle_telescope = function()
      local harpoon_files = harpoon:list()
      local conf = require('telescope.config').values
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end
      require('telescope.pickers')
        .new({}, {
          prompt_title = 'Harpoon',
          finder = require('telescope.finders').new_table({
            results = file_paths,
          }),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
        })
        :find()
    end

    local function get_current_file_name()
      return vim.fn.expand('%:t')
    end

    local function toggle_list()
      toggle_telescope(harpoon:list())
    end
    local function add_to_list()
      harpoon:list():add()
      vim.notify('Harpooned ' .. get_current_file_name())
    end
    local function remove_from_list()
      harpoon:list():remove()
      vim.notify('Unharpooned ' .. get_current_file_name())
    end
    local function next_in_list()
      harpoon:list():next()
      vim.notify('Harpooned to ' .. get_current_file_name())
    end
    local function prev_in_list()
      harpoon:list():prev()
      vim.notify('Harpooned to ' .. get_current_file_name())
    end

    require('core.utils').load_keymaps({
      {
        mode = { 'n' },
        bindings = {
          {
            key = '<leader><leader>h',
            cmd = toggle_list,
            desc = 'Harpoon toggle harpoon menu',
          },
          {
            key = '<leader>ah',
            cmd = add_to_list,
            desc = 'Harpoon add file to harpoon',
          },
          {
            key = '<leader>rh',
            cmd = remove_from_list,
            desc = 'Harpoon remove file to harpoon',
          },
          {
            key = '<leader>nh',
            cmd = next_in_list,
            desc = 'Harpoon select next harpoon file',
          },
          {
            key = '<leader>ph',
            cmd = prev_in_list,
            desc = 'Harpoon select prev harpoon file',
          },
        },
      },
    })
  end,
}
