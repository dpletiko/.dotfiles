return {
    {
        "github/copilot.vim",
        enabled = LOCAL.plugins.copilot ~= false,
        init = function()
            vim.g.copilot_no_tab_map = true

            vim.keymap.set("i", "<S-Tab>", 'copilot#Accept("\\<CR>")', {
                expr = true,
                replace_keycodes = false,
                silent = true,
            })

            -- vim.keymap.set("i", "<C-Space>", 'copilot#Accept("\\<CR>")', {
            --     expr = true,
            --     replace_keycodes = false,
            --     silent = true,
            -- })

            vim.keymap.set("i", "<C-L>", '<Plug>(copilot-accept-word)')
        end,
    },
    {
        "yetone/avante.nvim",
        enabled = LOCAL.plugins.avante ~= false,
        event = "VeryLazy",
        version = false, -- Never set this value to "*"! Never!
        build = vim.fn.has("win32") ~= 0
            and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
            or "make",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
            "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
            "stevearc/dressing.nvim",        -- for input provider dressing
            "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
            "zbirenbaum/copilot.lua",        -- for copilot-specific keybindings
            {
                "MeanderingProgrammer/render-markdown.nvim",
                opts = {
                    file_types = { "markdown", "Avante", "avante", "avante-chat" },
                },
                ft = { "markdown", "Avante", "avante", "avante-chat" },
            },
            -- Optional image support
            {
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        use_absolute_path = true,
                    },
                },
            },
        },
        opts = {
            -- provider = "ollama",
            provider = "copilot",
            providers = {
                ollama_6b = {
                    ["local"]          = true,
                    provider           = "ollama",
                    __inherited_from   = "ollama", -- inherit from the built-in Ollama provider
                    endpoint           = "http://127.0.0.1:11434",
                    timeout            = 30000,
                    model              = "deepseek-coder:6.7b",
                    extra_request_body = {
                        temperature = 0.7,
                        max_tokens = 4096,
                    },
                },
                ollama_16b = {
                    ["local"]          = true,
                    provider           = "ollama",
                    __inherited_from   = "ollama", -- inherit from the built-in Ollama provider
                    endpoint           = "http://127.0.0.1:11434",
                    timeout            = 30000,
                    model              = "deepseek-coder-v2:16b-lite-instruct-q5_K_S",
                    extra_request_body = {
                        temperature = 0.7,
                        max_tokens = 8192,
                        n = 1,
                    },
                },
                ollama = {
                    endpoint           = "http://127.0.0.1:11434",
                    model              = "deepseek-coder-v2:16b-lite-instruct-q5_K_S",
                    disable_tools      = true,
                    extra_request_body = {
                        temperature = 0.7,
                        max_tokens = 8192,
                        n = 1,
                    },
                },
                copilot = {
                    -- model = "claude-opus-4.6",
                    model = "gpt-5.4",
                    use_response_api = true,
                    extra_request_body = {
                        -- max_tokens = 20480,
                        max_completion_tokens = 20480,
                    },
                },
            },
            behaviour = {
                auto_suggestions = false,
                auto_set_highlight_group = true,
                auto_set_keymaps = true,
                auto_apply_diff_after_generation = false,
                support_paste_from_clipboard = false,
            },
            windows = {
                position = "right",
                wrap = true,
                width = 30,
                sidebar_header = {
                    enabled = true,   -- true, false to enable/disable the header
                    align = "center", -- left, center, right for title
                    rounded = true,
                },
            },
            -- mappings = {
            --     ask = "<leader>ua", -- ask
            --     edit = "<leader>ue", -- edit
            --     refresh = "<leader>ur", -- refresh
            -- },
            selector = {
                exclude_auto_select = { "NvimTree", "NeoTree" },
            },
        },
        keys = {
            {
                "<leader>a+",
                function()
                    local tree_ext = require("avante.extensions.nvim_tree")
                    tree_ext.add_file()
                end,
                desc = "Select file in NvimTree",
                ft = "NvimTree",
            },
            {
                "<leader>a-",
                function()
                    local tree_ext = require("avante.extensions.nvim_tree")
                    tree_ext.remove_file()
                end,
                desc = "Deselect file in NvimTree",
                ft = "NvimTree",
            },
            { "<leader>ac", "<cmd>AvanteClear<cr>", mode = { "n" }, desc = "Clear Avante Chat History" },
            { "<leader>af", "<cmd>AvanteFocus<cr>", mode = { "n" }, desc = "Switch Avante Chat Focus" },
            { "<leader>ah", "<cmd>AvanteHistory<cr>", mode = { "n" }, desc = "Toggle Avante History" },
            { "<leader>an", "<cmd>AvanteChatNew<cr>", mode = { "n" }, desc = "Start New Avante Chat" },
        },
    },
}
