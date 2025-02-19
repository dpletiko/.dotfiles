return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.8",
    -- branch: "0.1.x",

    dependencies = {
        "nvim-lua/plenary.nvim",
        -- { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        -- "nvim-telescope/telescope-live-grep-args.nvim",
        -- { "nvim-telescope/telescope-dap.nvim" }
    },

    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    },

    config = function()
        local telescope = require('telescope')
        local actions = require('telescope.actions')

        telescope.setup({
            defaults = {
                mappings = {
                    i = {
                        ["<C-Up>"] = actions.cycle_history_prev,
                        ["<C-Down>"] = actions.cycle_history_next
                    }
                }
            }
        })

        -- telescope.load_extension("fzf")
        -- telescope.load_extension("live_grep_args")
        -- telescope.load_extension("dap")
        telescope.load_extension("flutter")

        local builtin = require('telescope.builtin')

        vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
        
        vim.keymap.set('n', '<leader>ph', builtin.help_tags, {})
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

        vim.keymap.set('n', '<leader>pd', builtin.diagnostics, {})
        vim.keymap.set('n', '<leader>pl', builtin.loclist, {})
        vim.keymap.set('n', '<leader>pq', builtin.quickfix, {})
        
        -- vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
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
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        
        vim.keymap.set('n', '<leader>pw', function()
            builtin.grep_string({ search = vim.fn.expand("<cword>") })
        end)
        vim.keymap.set('n', '<leader>pW', function()
            builtin.grep_string({ search = vim.fn.expand("<cWORD>") })
        end)

        vim.keymap.set('n', '<leader>pg', function()
            telescope.extensions.live_grep_args.live_grep_args()
        end)
    end
}