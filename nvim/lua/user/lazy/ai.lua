-- Complete Lazy.nvim setup for AI plugins with Ollama support
-- Save this to your nvim config (e.g., ~/.config/nvim/lua/plugins/ai.lua)

local user = os.getenv("USER") or "unknown"
local host = vim.fn.hostname()

return {
    {
        "github/copilot.vim",
        enabled = LOCAL.plugins.copilot ~= false,
        init = function()
            vim.g.copilot_no_tab_map = true
            vim.keymap.set("i", "<S-Tab>", 'copilot#Accept("\\<S-Tab>")', {
                expr = true,
                replace_keycodes = false,
                silent = true,
            })
        end,
    },

    -- ============================================================================
    -- 1. CODECOMPANION.NVIM - Best native Ollama support
    -- ============================================================================
    {
        "olimorris/codecompanion.nvim",
        version = "^18.0.0",
        enabled = LOCAL.plugins.codecompanion ~= false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-telescope/telescope.nvim", -- optional
            "stevearc/dressing.nvim",        -- optional for better UI

            {
                "MeanderingProgrammer/render-markdown.nvim",
                ft = { "markdown", "codecompanion" }
            },

            "ravitemer/mcphub.nvim",
            "ravitemer/codecompanion-history.nvim" -- history extension
        },
        opts = {
            adapters = {
                ---@type CodeCompanion.HTTPAdapter
                http = {
                    ollama = function()
                        ---@type CodeCompanion.HTTPAdapter.Ollama
                        return require("codecompanion.adapters").extend("ollama", {
                            name = "ollama",
                            url = "http://localhost:11434/v1/chat/completions",
                            schema = {
                                ---@type CodeCompanion.Schema
                                -- model = {
                                --     default = "deepseek-coder:6.7b",
                                -- },
                                -- model = {
                                --     order = 1,
                                --     mapping = "parameters",
                                --     type = "enum",
                                --     desc = "ID of the model to use.",
                                --     ---@param self CodeCompanion.HTTPAdapter.Ollama
                                --     default = function(self)
                                --         print(self)
                                --         return self:get_models({ last = true })
                                --     end,
                                --     ---@param self CodeCompanion.HTTPAdapter.Ollama
                                --     choices = function(self)
                                --         return self:get_models()
                                --     end,
                                -- },
                            },
                        })
                    end,
                },
            },
            extensions = {
                history = {
                    enabled = true,              -- defaults to true
                    opts = {
                        keymap = "gh",           -- Keymap to open history from chat buffer
                        save_chat_keymap = "sc", -- Manual save keymap
                        auto_save = true,        -- Auto-save all chats
                        auto_title = true,       -- Auto-generate chat titles
                        picker = "telescope",    --- ("telescope", "snacks", "fzf-lua", or "default")
                        expiration_days = 0,     -- Number of days after which chats are automatically deleted (0 to disable)
                        dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
                    }
                },
                mcphub = {
                    callback = "mcphub.extensions.codecompanion",
                    opts = {
                        -- MCP Tools
                        make_tools = true, -- Make individual tools (@server__tool) available
                        show_server_tools_in_chat = true,
                        add_mcp_prefix_to_tool_names = false,
                        show_result_in_chat = true,
                        -- MCP Resources
                        make_vars = true,           -- Convert MCP resources to #variables
                        -- MCP Prompts
                        make_slash_commands = true, -- Add MCP prompts as /slash commands
                    }
                }
            },
            interactions = {
                chat = {
                    -- adapter = "ollama",
                    adapter = {
                        name = "copilot",
                        model = "claude-opus-4.6",
                    },
                    roles = {
                        ---The header name for the LLM's messages
                        ---@type string|fun(adapter: CodeCompanion.Adapter): string
                        llm = function(adapter)
                            return "CodeCompanion (" .. adapter.formatted_name .. ")"
                        end,

                        ---The header name for your messages
                        ---@type string
                        -- user = "Me",
                        user = user .. '@' .. host,
                    },
                    slash_commands = {
                        ["file"] = {
                            -- Use Telescope as the provider for the /file command
                            opts = {
                                provider = "telescope", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks"
                            },
                        },
                    },
                    tools = {
                        ["grep_search"] = {
                            ---@param adapter CodeCompanion.HTTPAdapter
                            ---@return boolean
                            enabled = function(adapter)
                                return vim.fn.executable("rg") == 1
                            end,
                        },
                    }
                },
                inline = {
                    -- adapter = "ollama",
                    adapter = {
                        name = "copilot",
                        model = "claude-opus-4.6",
                    },
                },
            },
            language = "English",
            display = {
                action_palette = {
                    width = 95,
                    height = 10,
                    prompt = "Prompt ",                  -- Prompt used for interactive LLM calls
                    provider = "telescope",              -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
                    opts = {
                        show_preset_actions = true,      -- Show the preset actions in the action palette?
                        show_preset_prompts = true,      -- Show the preset prompts in the action palette?
                        title = "CodeCompanion actions", -- The title of the action palette
                    },
                },
                chat = {
                    intro_message = "",
                    separator = "─", -- The separator between the different messages in the chat buffer
                    show_context = true, -- Show context (from slash commands and variables) in the chat buffer?
                    show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
                    show_settings = false, -- Show LLM settings at the top of the chat buffer?
                    show_token_count = true, -- Show the token count for each response?
                    show_tools_processing = true, -- Show the loading message when tools are being executed?
                    start_in_insert_mode = false, -- Open the chat buffer in insert mode?
                    window = {
                        layout = "vertical", -- float|vertical|horizontal
                        full_height = true,
                        position = "right", -- left|right|top|bottom (nil will default depending on vim.opt.splitright|vim.opt.splitbelow)
                        border = "single", -- single|double|rounded|solid|shadow
                        relative = "editor", -- editor|win|cursor
                        width = 0.375,
                        height = 0.8
                    },
                },
            },
        },
        keys = {
            { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" },                desc = "Toggle CodeCompanion Chat" },
            { "<leader>ca", "<cmd>CodeCompanionActions<cr>",     mode = { "n", "v" },                desc = "CodeCompanion Actions" },
            { "<leader>ci", "<cmd>CodeCompanion<cr>",            mode = { "n", "v" },                desc = "CodeCompanion Inline" },
            { "<leader>ch", "<cmd>CodeCompanionHistory<cr>",     desc = "CodeCompanion Chat History" },
        },
    },

    -- ============================================================================
    -- 2. AVANTE.NVIM - Cursor-like experience with Ollama
    -- ============================================================================
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
                    model = "claude-opus-4.6",
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
        },
    },

    -- ============================================================================
    -- 3. CHATGPT.NVIM - With Ollama via OpenAI-compatible API
    -- ============================================================================
    {
        "jackMort/ChatGPT.nvim",
        enabled = LOCAL.plugins.chatgpt ~= false,
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "folke/trouble.nvim", -- optional
            "nvim-telescope/telescope.nvim",
        },
        opts = {
            -- model = "gpt-5-mini",
            -- frequency_penalty = 0,
            -- presence_penalty = 0,
            -- max_tokens = 4095,
            -- temperature = 0.2,
            -- top_p = 0.1,
            -- n = 1,

            -- Point to Ollama's OpenAI-compatible endpoint
            api_host_cmd = "echo -n http://localhost:11434",
            api_key_cmd = "echo -n dummy", -- Ollama doesn't need a key
            openai_params = {
                -- model = "deepseek-coder:6.7b",
                model = "deepseek-coder-v2:16b-lite-instruct-q5_K_S",
                frequency_penalty = 0,
                presence_penalty = 0,
                -- max_tokens = 4096,
                max_tokens = 8192,
                temperature = 0.7,
                top_p = 1,
                n = 1,
            },
            openai_edit_params = {
                -- model = "deepseek-coder:6.7b",
                model = "deepseek-coder-v2:16b-lite-instruct-q5_K_S",
                temperature = 0,
                top_p = 1,
                n = 1,
            },
            -- Use chat completions endpoint compatible with Ollama
            chat_url = "http://localhost:11434/v1/chat/completions",
        },
        keys = {
            { "<leader>cg", "<cmd>ChatGPT<CR>",                    desc = "ChatGPT" },
            { "<leader>ce", "<cmd>ChatGPTEditWithInstruction<CR>", mode = { "n", "v" }, desc = "Edit with instruction" },
            { "<leader>cx", "<cmd>ChatGPTRun explain_code<CR>",    mode = { "n", "v" }, desc = "Explain Code" },
            { "<leader>cf", "<cmd>ChatGPTRun fix_bugs<CR>",        mode = { "n", "v" }, desc = "Fix Bugs" },
            { "<leader>co", "<cmd>ChatGPTRun optimize_code<CR>",   mode = { "n", "v" }, desc = "Optimize Code" },
        },
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        enabled = LOCAL.plugins.copilot,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        build = "make tiktoken",
        opts = {
            -- model = 'gpt-4.1',   -- AI model to use
            model = 'claude-opus-4.6', -- AI model to use
            temperature = 0.1,         -- Lower = focused, higher = creative
            window = {
                layout = 'vertical',   -- 'vertical', 'horizontal', 'float', 'replace', or a function that returns the layout
                width = 70,
                height = 20,
                winblend = 10,
                border = 'rounded', -- 'single', 'double', 'rounded', 'solid'
                title = '🤖 AI Assistant',
                zindex = 100,       -- Ensure window stays on top
            },
            headers = {
                user = user .. '@' .. host,
                assistant = '🤖 Copilot',
                tool = '🔧 Tool',
            },
            separator = '━━',
            auto_fold = true,   -- Automatically folds non-assistant messages
            auto_insert = true, -- Enter insert mode when opening a chat
        },
        keys = {
            { "<leader>cc", "<cmd>CopilotChat<CR>",    mode = { "n", "v" }, desc = "Copilot Chat" },
            { "<leader>cs", "<cmd>CopilotChat -s<CR>", mode = { "n", "v" }, desc = "Send Selection to Chat" },
            { "<leader>cf", "<cmd>CopilotChat -f<CR>", mode = { "n", "v" }, desc = "Send File to Chat" },
        },
    },
}
