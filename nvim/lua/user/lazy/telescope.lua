return {
	"nvim-telescope/telescope.nvim",

	version = "*",

	-- tag = "0.1.8",
	-- branch: "0.1.x",

	dependencies = {
		"nvim-lua/plenary.nvim",

		{
			"nvim-telescope/telescope-fzf-native.nvim",
			-- build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
			-- build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install'
			build = "make",
		},

		"MunifTanjim/nui.nvim",

		"nvim-telescope/telescope-dap.nvim",
		"nvim-telescope/telescope-node-modules.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
		"nvim-telescope/telescope-ui-select.nvim",

		"nvim-telescope/telescope-live-grep-args.nvim",
		-- "smartpde/telescope-recent-files",
	},

	extensions = {
		fzy_native = {
			override_generic_sorter = false,
			override_file_sorter = true,
		},
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
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
		recent_files = {
			only_cwd = true,
		},
		["ui-select"] = {
			require("telescope.themes").get_dropdown({
				-- even more opts
			}),
		},
	},

	config = function()
		local telescope = require("telescope")
		local telescopeConfig = require("telescope.config")
		local builtin = require("telescope.builtin")

		local actions = require("telescope.actions")
		local layout = require("telescope.actions.layout")
		local previewers = require("telescope.previewers")
		local themes = require("telescope.themes")

		local layout_strategies = require("telescope.pickers.layout_strategies")
		local lga_actions = require("telescope-live-grep-args.actions")

		layout_strategies.dynamic = function(self, max_columns, max_lines, layout_config)
			print(max_columns, max_lines)

			if max_columns < max_lines * 3 then
				self.__flex_strategy = "vertical"
				self.layout_config.flip_columns = nil
				self.layout_config.flip_lines = nil
				return layout_strategies.vertical(self, max_columns, max_lines, layout_config)
			else
				self.__flex_strategy = "horizontal"
				self.layout_config.flip_columns = nil
				self.layout_config.flip_lines = nil
				return layout_strategies.horizontal(self, max_columns, max_lines, layout_config)
			end
		end

		-- Clone the default Telescope configuration
		local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

		-- I want to search in hidden/dot files.
		table.insert(vimgrep_arguments, "--hidden")
		-- I don't want to search in the `.git` directory.
		table.insert(vimgrep_arguments, "--glob")
		table.insert(vimgrep_arguments, "!**/.git/*")
		table.insert(vimgrep_arguments, "--multiline")

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
				hidden = hidden ~= false,
			}
			if vim.o.lines >= 80 then
				-- opts = themes.get_dropdown(opts)
			end
			builtin.find_files(opts)
		end

		local is_inside_work_tree = {}
		local function project_files(no_ignore, hidden)
			local opts = {
				no_ignore = no_ignore or false,
				hidden = hidden ~= false,
			} -- define here if you want to define something

			local cwd = vim.fn.getcwd()
			if is_inside_work_tree[cwd] == nil then
				vim.fn.system("git rev-parse --is-inside-work-tree")
				is_inside_work_tree[cwd] = vim.v.shell_error == 0
			end

			if vim.o.lines >= 80 then
				opts = require("telescope.themes").get_dropdown(opts)
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
				"--size",
				tostring(max_width) .. "x", -- x lets chafa pick height automatically
				filepath,
			}, {
				stdout_buffered = true,
				on_stdout = function(_, data, _)
					if not data then
						return
					end
					local output = table.concat(data, "\r\n")
					image_cache[key] = output
					callback(output)
				end,
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
							if width < 10 then
								width = 40
							end -- sanity min width

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

				-- layout_strategy = "flex",
				layout_strategy = "dynamic",
				layout_config = {
					-- flex = {
					-- 	flip_columns = 120,
					-- 	flip_lines = 30,
					-- },
					horizontal = {
						preview_width = 0.55,
					},
					vertical = {
						preview_height = 0.5,
					},
				},

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

						["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
					},
					n = {
						["<M-p>"] = layout.toggle_preview,

						["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,

						-- ["cd"] = function(prompt_bufnr)
						--     local selection = require("telescope.actions.state").get_selected_entry()
						--     local dir = vim.fn.fnamemodify(selection.path, ":p:h")
						--     require("telescope.actions").close(prompt_bufnr)
						--     -- Depending on what you want put `cd`, `lcd`, `tcd`
						--     vim.cmd(string.format("silent lcd %s", dir))
						-- end,
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
						"--glob",
						"!.env",
						"--glob",
						"!**/.git/*",
					},
				},
			},
			extensions = {
				live_grep_args = {
					auto_quoting = true, -- enable/disable auto-quoting
					-- define mappings, e.g.
					mappings = { -- extend mappings
						i = {
							["<C-k>"] = lga_actions.quote_prompt(),
							["<C-j>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
							-- freeze the current list and start a fuzzy search in the frozen list
							["<C-space>"] = lga_actions.to_fuzzy_refine,
						},
					},
					-- ... also accepts theme settings, for example:
					-- theme = "dropdown", -- use dropdown theme
					-- theme = { }, -- use own theme spec
					-- layout_config = { mirror=true }, -- mirror preview pane
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("live_grep_args")
		-- telescope.load_extension("dap")
		-- telescope.load_extension("fzy_native")
		telescope.load_extension("flutter")
		telescope.load_extension("dap")
		telescope.load_extension("node_modules")
		-- telescope.load_extension("recent_files")
		telescope.load_extension("file_browser")
		-- telescope.load_extension("ui-select")

		-- telescope.extensions.dap.configurations()

		vim.keymap.set("n", "<leader>pb", builtin.buffers, { desc = "Telescope buffers" })

		-- vim.keymap.set('n', '<leader>ph', builtin.help_tags, {})
		vim.keymap.set("n", "<leader>vh", builtin.help_tags, { desc = "Telescope help tags" })

		vim.keymap.set("n", "<leader>pd", builtin.diagnostics, { desc = "Telescope diagnostics" })
		vim.keymap.set("n", "<leader>pl", builtin.loclist, { desc = "Telescope loclist" })
		vim.keymap.set("n", "<leader>pq", builtin.quickfix, { desc = "Telescope quickfix" })

		vim.keymap.set("n", "<leader>pf", find_files, { desc = "Telescope find files" })
		vim.keymap.set("n", "<leader>pF", function()
			find_files(true, true)
		end, { desc = "Telescope find files (no ignore)" })

		vim.keymap.set("n", "<C-S-p>", project_files, { desc = "Telescope git files" })

		vim.keymap.set("n", "<leader>ps", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end, { desc = "Telescope grep" })

		vim.keymap.set("n", "<leader>pw", function()
			builtin.grep_string({ search = vim.fn.expand("<cword>") })
		end, { desc = "Telescope grep word" })

		vim.keymap.set("n", "<leader>pW", function()
			builtin.grep_string({ search = vim.fn.expand("<cWORD>") })
		end, { desc = "Telescope grep WORD (non-whitespace)" })

		vim.keymap.set("n", "<leader>pg", function()
			-- builtin.live_grep()
			require("telescope").extensions.live_grep_args.live_grep_args()
		end, { desc = "Telescope live grep" })
		vim.keymap.set("n", "<leader>pG", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")

		vim.keymap.set("n", "<space>fb", function()
			telescope.extensions.file_browser.file_browser({
				path = vim.fn.expand("%:p:h"),
				select_buffer = true,
			})
		end, { desc = "Telescope file browser" })

		vim.keymap.set("n", "<leader><leader>", function()
			builtin.oldfiles({
				cwd = vim.fn.getcwd(),
				only_cwd = true,
			})
			-- telescope.extensions.recent_files.pick()
		end, { desc = "Telescope recent files" })

		vim.keymap.set("n", "<leader>pn", "<cmd>Telescope neoclip<CR>", { desc = "Telescope neoclip" })
	end,
}
