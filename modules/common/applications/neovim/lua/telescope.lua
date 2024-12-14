local telescope = require("telescope")
telescope.setup()
vim.api.nvim_set_keymap("n", "<C-Space>", "<cmd>lua require('telescope.builtin').find_files()<cr>", { noremap = false })
