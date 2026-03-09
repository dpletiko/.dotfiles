return {
    "nvim-telescope/telescope.nvim",

    version = "*",

    -- tag = "0.1.8",
    -- branch: "0.1.x",

    dependencies = {
        "nvim-lua/plenary.nvim",

        {
            'nvim-telescope/telescope-fzf-native.nvim',
            -- build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
            -- build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install'
            build = 'make'
        },

        "MunifTanjim/nui.nvim",

        "nvim-telescope/telescope-dap.nvim",
        "nvim-telescope/telescope-node-modules.nvim",
        "smartpde/telescope-recent-files",
        "nvim-telescope/telescope-file-browser.nvim",

        'nvim-telescope/telescope-ui-select.nvim',

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
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
            mappings = {
                ["i"] = {
                    -- your custom insert mode mappings
                },
                ["n"] = {
                    -- your custom normal mode mappings
                },
            },
        },
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {
                -- even more opts
            },
        },
    },

    config = function()
        local telescope = require('telescope')
        local telescopeConfig = require("telescope.config")
        local builtin = require('telescope.builtin')

        local actions = require('telescope.actions')
        local layout = require('telescope.actions.layout')
        local previewers = require("telescope.previewers")
        local themes = require("telescope.themes")

        -- Clone the default Telescope configuration
        local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

        -- I want to search in hidden/dot files.
        table.insert(vimgrep_arguments, "--hidden")
        -- I don't want to search in the `.git` directory.
        table.insert(vimgrep_arguments, "--glob")
        table.insert(vimgrep_arguments, "!**/.git/*")

        -- local Layout = require("nui.layout")
        -- local Popup = require("nui.popup")

        -- local TSLayout = require("telescope.pickers.layout")

        -- local function make_popup(options)
        --     local popup = Popup(options)
        --     function popup.border:change_title(title)
        --         popup.border.set_text(popup.border, "top", title)
        --     end
        --     return TSLayout.Window(popup)
        -- end

        local find_files = function(no_ignore, hidden)
            local opts = {
                no_ignore = no_ignore or false,
                hidden = hidden or true,
            }
            if vim.o.lines >= 80 then
                opts = themes.get_dropdown(opts)
            end
            builtin.find_files(opts)
        end

        local is_inside_work_tree = {}
        local function project_files(no_ignore, hidden)
            local opts = {
                no_ignore = no_ignore or false,
                hidden = hidden or true,
            } -- define here if you want to define something

            local cwd = vim.fn.getcwd()
            if is_inside_work_tree[cwd] == nil then
                vim.fn.system("git rev-parse --is-inside-work-tree")
                is_inside_work_tree[cwd] = vim.v.shell_error == 0
            end

            if vim.o.lines >= 80 then
                opts = require('telescope.themes').get_dropdown(opts)
            end

            if is_inside_work_tree[cwd] then
                builtin.git_files(opts)
            else
                builtin.find_files(opts)
            end
        end

        local image_cache = {}
        local function render_image(filepath, max_width, callback)
            local key = filepath .. "|w" .. max_width

            if image_cache[key] then
                callback(image_cache[key])
                return
            end

            vim.fn.jobstart({
                "chafa",
                "--size", tostring(max_width) .. "x", -- x lets chafa pick height automatically
                filepath
            }, {
                    stdout_buffered = true,
                    on_stdout = function(_, data, _)
                        if not data then return end
                        local output = table.concat(data, "\r\n")
                        image_cache[key] = output
                        callback(output)
                    end
                })
        end

        telescope.setup({
            defaults = {
                buffer_previewer_maker = function(filepath, bufnr, opts)
                    local ext = vim.fn.fnamemodify(filepath, ":e"):lower()
                    local is_image = vim.tbl_contains({ "png", "jpg", "jpeg", "webp", "svg" }, ext)

                    if is_image then
                        local term = vim.api.nvim_open_term(bufnr, {})

                        -- Schedule to wait until buffer is displayed
                        vim.schedule(function()
                            local winid = vim.fn.bufwinid(bufnr)
                            if winid == -1 then
                                -- fallback to default width if window not ready yet
                                winid = 0
                            end

                            local width = vim.api.nvim_win_get_width(winid) - 2
                            if width < 10 then width = 40 end -- sanity min width

                            render_image(filepath, width, function(output)
                                vim.api.nvim_chan_send(term, output)
                            end)
                        end)
                    else
                        previewers.buffer_previewer_maker(filepath, bufnr, opts)
                    end
                end,

                -- `hidden = true` is not supported in text grep commands.
                vimgrep_arguments = vimgrep_arguments,

                layout_strategy = "flex",
                -- layout_config = {
                --     horizontal = {
                --         size = {
                --             width = "90%",
                --             height = "60%",
                --         },
                --     },
                --     vertical = {
                --         size = {
                --             width = "90%",
                --             height = "90%",
                --         },
                --     },
                -- },

                -- create_layout = function(picker)
                --     local border = {
                --         results = {
                --             top_left = "┌",
                --             top = "─",
                --             top_right = "┬",
                --             right = "│",
                --             bottom_right = "",
                --             bottom = "",
                --             bottom_left = "",
                --             left = "│",
                --         },
                --         results_patch = {
                --             minimal = {
                --                 top_left = "┌",
                --                 top_right = "┐",
                --             },
                --             horizontal = {
                --                 top_left = "┌",
                --                 top_right = "┬",
                --             },
                --             vertical = {
                --                 top_left = "├",
                --                 top_right = "┤",
                --             },
                --         },
                --         prompt = {
                --             top_left = "├",
                --             top = "─",
                --             top_right = "┤",
                --             right = "│",
                --             bottom_right = "┘",
                --             bottom = "─",
                --             bottom_left = "└",
                --             left = "│",
                --         },
                --         prompt_patch = {
                --             minimal = {
                --                 bottom_right = "┘",
                --             },
                --             horizontal = {
                --                 bottom_right = "┴",
                --             },
                --             vertical = {
                --                 bottom_right = "┘",
                --             },
                --         },
                --         preview = {
                --             top_left = "┌",
                --             top = "─",
                --             top_right = "┐",
                --             right = "│",
                --             bottom_right = "┘",
                --             bottom = "─",
                --             bottom_left = "└",
                --             left = "│",
                --         },
                --         preview_patch = {
                --             minimal = {},
                --             horizontal = {
                --                 bottom = "─",
                --                 bottom_left = "",
                --                 bottom_right = "┘",
                --                 left = "",
                --                 top_left = "",
                --             },
                --             vertical = {
                --                 bottom = "",
                --                 bottom_left = "",
                --                 bottom_right = "",
                --                 left = "│",
                --                 top_left = "┌",
                --             },
                --         },
                --     }

                --     local results = make_popup({
                --         focusable = false,
                --         border = {
                --             style = border.results,
                --             text = {
                --                 top = picker.results_title,
                --                 top_align = "center",
                --             },
                --         },
                --         win_options = {
                --             winhighlight = "Normal:Normal",
                --         },
                --     })

                --     local prompt = make_popup({
                --         enter = true,
                --         border = {
                --             style = border.prompt,
                --             text = {
                --                 top = picker.prompt_title,
                --                 top_align = "center",
                --             },
                --         },
                --         win_options = {
                --             winhighlight = "Normal:Normal",
                --         },
                --     })

                --     local preview = make_popup({
                --         focusable = false,
                --         border = {
                --             style = border.preview,
                --             text = {
                --                 top = picker.preview_title,
                --                 top_align = "center",
                --             },
                --         },
                --     })

                --     local box_by_kind = {
                --         vertical = Layout.Box({
                --             Layout.Box(preview, { grow = 1 }),
                --             Layout.Box(results, { grow = 1 }),
                --             Layout.Box(prompt, { size = 3 }),
                --         }, { dir = "col" }),
                --         horizontal = Layout.Box({
                --             Layout.Box({
                --                 Layout.Box(results, { grow = 1 }),
                --                 Layout.Box(prompt, { size = 3 }),
                --             }, { dir = "col", size = "50%" }),
                --             Layout.Box(preview, { size = "50%" }),
                --         }, { dir = "row" }),
                --         minimal = Layout.Box({
                --             Layout.Box(results, { grow = 1 }),
                --             Layout.Box(prompt, { size = 3 }),
                --         }, { dir = "col" }),
                --     }

                --     local function get_box()
                --         local strategy = picker.layout_strategy
                --         if strategy == "vertical" or strategy == "horizontal" then
                --             return box_by_kind[strategy], strategy
                --         end

                --         local height, width = vim.o.lines, vim.o.columns
                --         local box_kind = "horizontal"
                --         if width < 100 then
                --             box_kind = "vertical"
                --             if height < 40 then
                --                 box_kind = "minimal"
                --             end
                --         end
                --         return box_by_kind[box_kind], box_kind
                --     end

                --     local function prepare_layout_parts(layout, box_type)
                --         layout.results = results
                --         results.border:set_style(border.results_patch[box_type])

                --         layout.prompt = prompt
                --         prompt.border:set_style(border.prompt_patch[box_type])

                --         if box_type == "minimal" then
                --             layout.preview = nil
                --         else
                --             layout.preview = preview
                --             preview.border:set_style(border.preview_patch[box_type])
                --         end
                --     end

                --     local function get_layout_size(box_kind)
                --         return picker.layout_config[box_kind == "minimal" and "vertical" or box_kind].size
                --     end

                --     local box, box_kind = get_box()
                --     local layout = Layout({
                --         relative = "editor",
                --         position = "50%",
                --         size = get_layout_size(box_kind),
                --     }, box)

                --     layout.picker = picker
                --     prepare_layout_parts(layout, box_kind)

                --     local layout_update = layout.update
                --     function layout:update()
                --         local box, box_kind = get_box()
                --         prepare_layout_parts(layout, box_kind)
                --         layout_update(self, { size = get_layout_size(box_kind) }, box)
                --     end

                --     return TSLayout(layout)
                -- end,

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
                        ["<C-Down>"] = actions.cycle_history_next,

                        ["<C-s>"] = actions.cycle_previewers_next,
                        ["<C-a>"] = actions.cycle_previewers_prev,

                        ["<M-p>"] = layout.toggle_preview,
                    },
                    n = {
                        ["<M-p>"] = layout.toggle_preview,

                        ["cd"] = function(prompt_bufnr)
                            local selection = require("telescope.actions.state").get_selected_entry()
                            local dir = vim.fn.fnamemodify(selection.path, ":p:h")
                            require("telescope.actions").close(prompt_bufnr)
                            -- Depending on what you want put `cd`, `lcd`, `tcd`
                            vim.cmd(string.format("silent lcd %s", dir))
                        end,
                    },
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
            pickers = {
                find_files = {
                    -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
                    find_command = {
                        "rg",
                        "--files",
                        "--hidden",
                        "--glob", "!.env",
                        "--glob", "!**/.git/*"
                    },
                },
            }
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
        -- telescope.load_extension("ui-select")

        -- telescope.extensions.dap.configurations()

        vim.keymap.set('n', '<leader>pb', builtin.buffers, { desc = 'Telescope buffers' })

        -- vim.keymap.set('n', '<leader>ph', builtin.help_tags, {})
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, { desc = 'Telescope help tags' })

        vim.keymap.set('n', '<leader>pd', builtin.diagnostics, { desc = 'Telescope diagnostics' })
        vim.keymap.set('n', '<leader>pl', builtin.loclist, { desc = 'Telescope loclist' })
        vim.keymap.set('n', '<leader>pq', builtin.quickfix, { desc = 'Telescope quickfix' })

        vim.keymap.set('n', '<leader>pf', find_files, { desc = 'Telescope find files' })
        vim.keymap.set('n', '<leader>pF', function()
            find_files(true, true)
        end, { desc = 'Telescope find files (no ignore)' })

        vim.keymap.set('n', '<C-p>', project_files, { desc = 'Telescope git files' })

        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end, { desc = 'Telescope grep' })

        vim.keymap.set('n', '<leader>pw', function()
            builtin.grep_string({ search = vim.fn.expand("<cword>") })
        end, { desc = 'Telescope grep word' })

        vim.keymap.set('n', '<leader>pW', function()
            builtin.grep_string({ search = vim.fn.expand("<cWORD>") })
        end, { desc = 'Telescope grep WORD (non-whitespace)' })

        vim.keymap.set('n', '<leader>pg', function()
            builtin.live_grep()
        end, { desc = 'Telescope live grep' })

        vim.keymap.set("n", "<space>fb", function()
            telescope.extensions.file_browser.file_browser({
                path = vim.fn.expand("%:p:h"),
                select_buffer = true,
            })
        end, { desc = 'Telescope file browser' })

        vim.keymap.set('n', '<leader><leader>', function()
            telescope.extensions.recent_files.pick()
        end, { noremap = true, silent = true, desc = 'Telescope recent files' })

        vim.keymap.set('n', '<leader>pn', '<cmd>Telescope neoclip<CR>', { desc = 'Telescope neoclip' })
    end
}
