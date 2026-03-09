return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        lazy = false, -- neo-tree will lazily load itself
        ---@module 'neo-tree'
        ---@type neotree.Config
        opts = {
            filesystem = {
                filtered_items = {
                    visible = true,
                    hide_dotfiles = false,
                    hide_gitignored = false,
                    hide_ignored = false,
                    hide_hidden = false,
                    hide_by_name = {

                    },
                    never_show = {
                        ".git",
                    },
                },
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = true
                },
                hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
                window = {
                    width = 42
                },
            },
            buffers = {
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = true
                },
            },
        },
        keys = {
            { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle NeoTree Explorer" },
        },
    },
    {
        "antosha417/nvim-lsp-file-operations",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-neo-tree/neo-tree.nvim", -- makes sure that this loads after Neo-tree.
        },
        config = function()
            require("lsp-file-operations").setup()
        end,
    },
    {
        "s1n7ax/nvim-window-picker",
        version = "2.*",
        config = function()
            require("window-picker").setup({
                filter_rules = {
                    include_current_win = false,
                    autoselect_one = true,
                    -- filter using buffer options
                    bo = {
                        -- if the file type is one of following, the window will be ignored
                        filetype = { "neo-tree", "neo-tree-popup", "notify" },
                        -- if the buffer type is one of following, the window will be ignored
                        buftype = { "terminal", "quickfix" },
                    },
                },
            })
        end,
    },
    {
        'nvim-mini/mini.bufremove',
        version = false,
        opts = {
            silent = false
        },
        config = function()
            vim.api.nvim_create_user_command("Bd", function(opts)
                -- Delete current buffer, support ! for force
                require("mini.bufremove").delete(0, opts.bang)
            end, {
                bang = true,
                desc = "Smart buffer deletion (could be forced with !)",
            })

            vim.api.nvim_create_user_command("Bw", function(opts)
                -- Wipeout current buffer, support ! for force
                require("mini.bufremove").wipeout(0, opts.bang)
            end, {
                bang = true,
                desc = "Smart buffer wipeout (could be forced with !)",
            })
        end,
    },
}
