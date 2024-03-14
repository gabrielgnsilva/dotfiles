local keymap = vim.keymap

-- General keymaps
keymap.set("n", "<leader>wq", "<cmd>wq<CR>", {desc = "Save and quit"})
keymap.set("n", "<leader>qq", "<cmd>q!<CR>", {desc = "Quit without saving"})
keymap.set("n", "<C-s>", "<cmd>w<CR>", {desc = "Save"})
keymap.set("i", "jj", "<Esc>", {desc = "Escape"})

-- Move lines with visual while preserving selection and autoindenting
keymap.set('v', 'K', ":move '<-2<CR>gv=gv", {desc = "Move line up"})
keymap.set('v', 'J', ":move '>+1<CR>gv=gv", {desc = "Move line down"})

-- Append the line below to the current line while preserving cursor position
keymap.set("n", "J", "mzJ`z", { desc = "Append line below to current line" })

-- Add a new line above or below the current line
keymap.set("n", "<leader>nj", "o<Esc>\"_D", { desc = "Add new line below" })
keymap.set("n", "<leader>nk", "O<Esc>\"_D", { desc = "Add new line above" })

-- Move page up or down while positioning the cursor on the center of the screen
keymap.set("n", "<C-n>", "<C-d>zz", { desc = "Move page down" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move page up" })

-- When searching, center the screen on the current match
keymap.set("n", "n", "nzzzv", { desc = "Move to next match" })
keymap.set("n", "N", "Nzzzv", { desc = "Move to previous match" })

-- When deleting or pasting, don't copy the deleted text to the default register
keymap.set("x", "<leader>p", "\"_dP", { desc = "Paste without copying" })
keymap.set("n", "<leader>d", "\"_d", { desc = "Delete without copying" })
keymap.set("x", "<leader>d", "\"_d", { desc = "Delete without copying" })

-- Disable ex mode
keymap.set("n", "Q", "<nop>", { desc = "Do nothing (disable ex mode)" })

-- Replace word under cursor  
keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })

-- Make current file executable
keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make current file executable" })

-- Source current file
keymap.set("n", "<leader><leader>", ":so<CR>", { desc = "Source current file" })

-- Split window navigation
keymap.set("n", "<leader>sh", "<C-w>h", {desc = "Move to left window"})
keymap.set("n", "<leader>sj", "<C-w>j", {desc = "Move to bottom window"})
keymap.set("n", "<leader>sk", "<C-w>k", {desc = "Move to top window"})
keymap.set("n", "<leader>sl", "<C-w>l", {desc = "Move to right window"})

-- Split window management
keymap.set("n", "<leader>sv", "<C-w>v", {desc = "Split window vertically"})
keymap.set("n", "<leader>ss", "<C-w>s", {desc = "Split window horizontally"})
keymap.set("n", "<leader>se", "<C-w>=", {desc = "Equalize window sizes"})
keymap.set("n", "<leader>cw", ":close<CR>", {desc = "Close window"})

-- Split window resizing
keymap.set("n", "<C-k>", "<C-w>+", { desc = "Increase window height" })
keymap.set("n", "<C-j>", "<C-w>-", {desc = "Decrease window height"})
keymap.set("n", "<C-l>", "<C-w><5", {desc = "Decrease window width"})
keymap.set("n", "<C-h>", "<C-w>>5", {desc = "Increase window width"})


-- Buffer navigation
-- TODO

-- Buffer management
-- TODO

-- Nvim-tree
keymap.set("n", "<C-d>", ":NvimTreeToggle<CR>", {desc = "Toggle Nvim-tree"})

-- Telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", {desc = "Fuzzy find files"})
keymap.set("n", "<leader>u", ":Telescope undo<CR>", {desc = "Fuzzy find undo history"})
keymap.set("n", "<C-g>", ":Telescope git_files<CR>", {desc = "Fuzzy find git files"})
keymap.set("n", "<leader>fs", function()
    require("telescope.builtin").grep_string({
        search = vim.fn.input("Grep > ")
    })
end, {desc = "Fuzzy find string in files"})

-- Git-blame
keymap.set("n", "<leader>gb", ":GitBlameToggle<CR>", {desc = "Toggle git-blame"})

-- Harpoon
keymap.set("n", "<leader>ah", require("harpoon.mark").add_file, {desc = "Add file to harpoon"})
keymap.set("n", "<leader>oh", require("harpoon.ui").toggle_quick_menu, {desc = "Toggle harpoon menu"})

-- Vim commentary
keymap.set("n", "<C-c>", ":Commentary<CR>", {desc = "Comment line"})
keymap.set("v", "<C-c>", ":Commentary<CR>", { desc = "Comment selection" })

-- TreeSJ
keymap.set("n", "<C-i>", ":TSJToggle<CR>", { desc = "Toggle block splitting" })
