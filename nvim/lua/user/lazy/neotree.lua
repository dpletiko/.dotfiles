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
                -- hijack_netrw_behavior = "open_current", -- netrw disabled, opening a directory opens neo-tree
                hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
                -- hijack_netrw_behavior = "disabled", -- netrw disabled, opening a directory opens neo-tree
                commands = {
                    avante_add_files = function(state)
                        local node = state.tree:get_node()
                        local filepath = node:get_id()
                        local relative_path = require('avante.utils').relative_path(filepath)

                        local sidebar = require('avante').get()

                        local open = sidebar:is_open()
                        -- ensure avante sidebar is open
                        if not open then
                            require('avante.api').ask()
                            sidebar = require('avante').get()
                        end

                        sidebar.file_selector:add_selected_file(relative_path)

                        -- remove neo tree buffer
                        if not open then
                            sidebar.file_selector:remove_selected_file('neo-tree filesystem [1]')
                        end
                    end,
                },
                window = {
                    width = 42,
                    mappings = {
                        ['oa'] = 'avante_add_files',
                    },
                },
            },
            buffers = {
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = true
                },
            },
        },
        init = function()
            -- vim.api.nvim_create_autocmd('BufEnter', {
            --   group    = vim.api.nvim_create_augroup('RemoteFileInit', {clear = true}),
            --   callback = function()
            --     local f = vim.fn.expand('%:p')
            --     for _, v in ipairs{'dav', 'fetch', 'ftp', 'http', 'rcp', 'rsync', 'scp', 'sftp'} do
            --       local p = v .. '://'
            --       if f:sub(1, #p) == p then
            --         vim.cmd[[
            --           unlet g:loaded_netrw
            --           unlet g:loaded_netrwPlugin
            --           runtime! plugin/netrwPlugin.vim
            --           silent Explore %
            --         ]]
            --         break
            --       end
            --     end
            --     vim.api.nvim_clear_autocmds{group = 'RemoteFileInit'}
            --   end
            -- })
            -- vim.api.nvim_create_autocmd('BufEnter', {
            --   group = vim.api.nvim_create_augroup('NeoTreeInit', {clear = true}),
            --   callback = function()
            --     local f = vim.fn.expand('%:p')
            --     if vim.fn.isdirectory(f) ~= 0 then
            --       vim.cmd('Neotree current dir=' .. f)
            --       vim.api.nvim_clear_autocmds{group = 'NeoTreeInit'}
            --     end
            --   end
            -- })
        end,
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
