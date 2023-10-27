local telescope = require('telescope')
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
-- local Layout = require('telescope.pickers.layout')

telescope.setup{
    defaults = {
        mappings = {
            i = {
                ["<C-Up>"] = actions.cycle_history_prev,
                ["<C-Down>"] = actions.cycle_history_next
            }
        },
        -- layout_config = {
        --   vertical = { width = 0.5 }
        --   -- other layout configuration here
        -- },
    },
    -- pickers = {
    --     find_files = {
    --         theme = "dropdown",
    --     }
    -- },
    -- create_layout = function(picker)
    --     local function create_window(enter, width, height, row, col, title)
    --       local bufnr = vim.api.nvim_create_buf(false, true)
    --       local winid = vim.api.nvim_open_win(bufnr, enter, {
    --         style = "minimal",
    --         relative = "editor",
    --         width = width,
    --         height = height,
    --         row = row,
    --         col = col,
    --         border = "single",
    --         title = title,
    --       })
    --
    --       vim.wo[winid].winhighlight = "Normal:Normal"
    --
    --       return Layout.Window {
    --         bufnr = bufnr,
    --         winid = winid,
    --       }
    --     end
    --
    --     local function destory_window(window)
    --       if window then
    --         if vim.api.nvim_win_is_valid(window.winid) then
    --           vim.api.nvim_win_close(window.winid, true)
    --         end
    --         if vim.api.nvim_buf_is_valid(window.bufnr) then
    --           vim.api.nvim_buf_delete(window.bufnr, { force = true })
    --         end
    --       end
    --     end
    --
    --     local layout = Layout {
    --       picker = picker,
    --       mount = function(self)
    --         self.results = create_window(false, 40, 20, 0, 0, "Results")
    --         self.preview = create_window(false, 40, 23, 0, 42, "Preview")
    --         self.prompt = create_window(true, 40, 1, 22, 0, "Prompt")
    --       end,
    --       unmount = function(self)
    --         destory_window(self.results)
    --         destory_window(self.preview)
    --         destory_window(self.prompt)
    --       end,
    --       update = function(self) end,
    --     }
    --
    --     return layout
    --   end,
}

vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
vim.keymap.set('n', '<leader>ph', builtin.help_tags, {})
vim.keymap.set('n', '<leader>pd', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>pl', builtin.loclist, {})
vim.keymap.set('n', '<leader>pq', builtin.quickfix, {})

vim.keymap.set('n', '<leader>pf', function()
    if vim.o.lines > 80 then
        return builtin.find_files(
            require('telescope.themes').get_dropdown({})
        )
    end

    builtin.find_files()
end)
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

