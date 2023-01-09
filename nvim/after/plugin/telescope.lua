local telescope = require('telescope')
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')

telescope.setup{
    defaults = {
        mappings = {
            i = {
                ["<C-Up>"] = actions.cycle_history_prev,
                ["<C-Down>"] = actions.cycle_history_next
            }
        }
    }
}

vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
vim.keymap.set('n', '<leader>ph', builtin.help_tags, {})
vim.keymap.set('n', '<leader>pd', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>pl', builtin.loclist, {})
vim.keymap.set('n', '<leader>pq', builtin.quickfix, {})

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep For > ") })
end)
vim.keymap.set('n', '<leader>pw', function()
	builtin.grep_string({ search = vim.fn.expand("<cword>") })
end)
vim.keymap.set('n', '<leader>pg', function()
	telescope.extensions.live_grep_args.live_grep_args()
end)

