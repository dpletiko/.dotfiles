return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.8",
    -- branch: "0.1.x",

    dependencies = {
        "nvim-lua/plenary.nvim",

        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
        },

        "nvim-telescope/telescope-dap.nvim",
        "nvim-telescope/telescope-node-modules.nvim",
        "smartpde/telescope-recent-files",
        "nvim-telescope/telescope-file-browser.nvim",

        -- "nvim-telescope/telescope-live-grep-args.nvim",
    },

    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        },
        fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        },
        file_browser = {
            theme = "ivy",
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
            mappings = {
                ["i"] = {
                    -- your custom insert mode mappings
                },
                ["n"] = {
                    -- your custom normal mode mappings
                },
            },
        },
    },

    config = function()
        local telescope = require('telescope')
        local actions = require('telescope.actions')

        telescope.setup({
            defaults = {
                hidden = true,
                -- layout_strategy = "vertical",
                -- layout_config = {
                    -- preview_cutoff = 120,
                    -- prompt_position = "top",
                    -- width = 0.8,
                    -- preview_height = .5,
                -- },
                mappings = {
                    i = {
                        ["<C-Up>"] = actions.cycle_history_prev,
                        ["<C-Down>"] = actions.cycle_history_next
                    }
                },
                -- vimgrep_arguments = {
                --     "rg",
                --     "--color=never",
                --     "--no-heading",
                --     "--with-filename",
                --     "--line-number",
                --     "--column",
                --     "--smart-case",
                --     "--glob=**/node_modules/**", -- Force include node_modules
                --     "--glob=**/vendor/**",       -- Force include vendor
                --     "--glob=/node%_modules/**",  -- Force include node_modules
                --     "--glob=/vendor/**",         -- Force include vendor
                -- },
                -- file_ignore_patterns = {
                --     "^!vendor/",
                --     "^!node_modules/",
                --     "^!node%_modules/",
                -- },
            },
        })

        telescope.load_extension("fzf")
        -- telescope.load_extension("live_grep_args")
        -- telescope.load_extension("dap")
        -- telescope.load_extension("fzy_native")
        telescope.load_extension("flutter")
        telescope.load_extension("dap")
        telescope.load_extension("node_modules")
        telescope.load_extension("recent_files")
        telescope.load_extension("file_browser")
        telescope.load_extension("neoclip")

        -- telescope.extensions.dap.configurations()

        local builtin = require('telescope.builtin')

        vim.keymap.set('n', '<leader>pb', builtin.buffers, {})

        vim.keymap.set('n', '<leader>ph', builtin.help_tags, {})
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

        vim.keymap.set('n', '<leader>pd', builtin.diagnostics, {})
        vim.keymap.set('n', '<leader>pl', builtin.loclist, {})
        vim.keymap.set('n', '<leader>pq', builtin.quickfix, {})

        -- vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<leader>pf', function()
            if vim.o.lines >= 80 then
                return builtin.find_files(
                    require('telescope.themes').get_dropdown({})
                )
            end
            builtin.find_files()
        end)
        vim.keymap.set('n', '<leader>pF', function()
            if vim.o.lines >= 80 then
                return builtin.find_files(
                    require('telescope.themes').get_dropdown({})
                )
            end
            builtin.find_files({
                no_ignore = true,
                hidden = true,
            })
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
            builtin.live_grep()
        end)

        vim.keymap.set("n", "<space>fb", function()
            telescope.extensions.file_browser.file_browser({
                path = vim.fn.expand("%:p:h"),
                select_buffer = true,
            })
        end)
        vim.keymap.set('n', '<leader><leader>', function()
            telescope.extensions.recent_files.pick()
        end, { noremap = true, silent = true })

        vim.keymap.set('n', '<leader>pn', '<cmd>Telescope neoclip<CR>')
    end
}
