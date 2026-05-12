return {
	"nvim-flutter/flutter-tools.nvim",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"stevearc/dressing.nvim", -- optional for vim.ui.select
	},
	-- config = true,
	config = function()
		local dap = require("dap")

		require("flutter-tools").setup({
			ui = {
				-- the border type to use for all floating windows, the same options/formats
				-- used for ":h nvim_open_win" e.g. "single" | "shadow" | {<table-of-eight-chars>}
				border = "rounded",
				-- This determines whether notifications are show with `vim.notify` or with the plugin's custom UI
				-- please note that this option is eventually going to be deprecated and users will need to
				-- depend on plugins like `nvim-notify` instead.
				-- notification_style = 'native' | 'plugin'
				notification_style = "native",
			},
			decorations = {
				statusline = {
					-- set to true to be able use the 'flutter_tools_decorations.app_version' in your statusline
					-- this will show the current version of the flutter app from the pubspec.yaml file
					app_version = false,
					-- set to true to be able use the 'flutter_tools_decorations.device' in your statusline
					-- this will show the currently running device if an application was started with a specific
					-- device
					device = false,
					-- set to true to be able use the 'flutter_tools_decorations.project_config' in your statusline
					-- this will show the currently selected project configuration
					project_config = false,
				},
			},
			debugger = { -- integrate with nvim dap + install dart code debugger
				enabled = false,
				-- if empty dap will not stop on any exceptions, otherwise it will stop on those specified
				-- see |:help dap.set_exception_breakpoints()| for more info
				exception_breakpoints = {},
				-- Whether to call toString() on objects in debug views like hovers and the
				-- variables list.
				-- Invoking toString() has a performance cost and may introduce side-effects,
				-- although users may expect this functionality. null is treated like false.
				evaluate_to_string_in_debug_views = true,
				register_configurations = function(paths)
					-- require("dap").configurations.dart = {
					--   <put here config that you would find in .vscode/launch.json>
					-- }

					-- Dart CLI adapter (recommended)
					dap.adapters.dart = {
						type = "executable",
						command = "fvm dart", -- if you're using fvm, you'll need to provide the full path to dart (dart.exe for windows users), or you could prepend the fvm command
						args = { "debug_adapter" },
						-- windows users will need to set 'detached' to false
						options = {
							detached = false,
						},
					}
					dap.adapters.flutter = {
						type = "executable",
						command = "fvm flutter", -- if you're using fvm, you'll need to provide the full path to flutter (flutter.bat for windows users), or you could prepend the fvm command
						args = { "debug_adapter" },
						-- windows users will need to set 'detached' to false
						options = {
							detached = false,
						},
					}

					dap.configurations.dart = {
						{
							type = "dart",
							request = "launch",
							name = "Launch dart",
							dartSdkPath = os.getenv('HOME') .. "/fvm/default/bin/dart", -- ensure this is correct
                            flutterSdkPath = os.getenv('HOME') .. "/fvm/default/bin/flutter", -- ensure this is correct
							-- dartSdkPath = "/opt/flutter/bin/cache/dart-sdk/bin/dart", -- ensure this is correct
							-- flutterSdkPath = "/opt/flutter/bin/flutter", -- ensure this is correct
							program = "${workspaceFolder}/lib/main.dart", -- ensure this is correct
							cwd = "${workspaceFolder}",
						},
						{
							type = "flutter",
							request = "launch",
							name = "Launch flutter",
							dartSdkPath = os.getenv('HOME') .. "/fvm/default/bin/dart", -- ensure this is correct
                            flutterSdkPath = os.getenv('HOME') .. "/fvm/default/bin/flutter", -- ensure this is correct
							-- dartSdkPath = "/opt/flutter/bin/cache/dart-sdk/bin/dart", -- ensure this is correct
							-- flutterSdkPath = "/opt/flutter/bin/flutter", -- ensure this is correct
							program = "${workspaceFolder}/lib/main.dart", -- ensure this is correct
							cwd = "${workspaceFolder}",
						},
					}
				end,
			},
			flutter_path = os.getenv("HOME") .. "/fvm/default", -- <-- this takes priority over the lookup
			flutter_lookup_cmd = nil, -- example "dirname $(which flutter)" or "asdf where flutter"
			root_patterns = { ".git", "pubspec.yaml" }, -- patterns to find the root of your flutter project
			fvm = true, -- takes priority over path, uses <workspace>/.fvm/flutter_sdk if enabled
			default_run_args = nil, -- Default options for run command (i.e `{ flutter = "--no-version-check" }`). Configured separately for `dart run` and `flutter run`.
			widget_guides = {
				enabled = false,
			},
			closing_tags = {
				highlight = "ErrorMsg", -- highlight for the closing tag
				prefix = ">", -- character to use for close tag e.g. > Widget
				priority = 10, -- priority of virtual text in current line
				-- consider to configure this when there is a possibility of multiple virtual text items in one line
				-- see `priority` option in |:help nvim_buf_set_extmark| for more info
				enabled = true, -- set to false to disable
			},
			dev_log = {
				enabled = true,
				filter = nil, -- optional callback to filter the log
				-- takes a log_line as string argument; returns a boolean or nil;
				-- the log_line is only added to the output if the function returns true
				notify_errors = false, -- if there is an error whilst running then notify the user
				open_cmd = "15split", -- command to use to open the log buffer
				focus_on_open = true, -- focus on the newly opened log window
			},
			dev_tools = {
				autostart = false, -- autostart devtools server if not detected
				auto_open_browser = false, -- Automatically opens devtools in the browser
			},
			outline = {
				open_cmd = "30vnew", -- command to use to open the outline buffer
				auto_open = false, -- if true this will open the outline automatically when it is first populated
			},
			lsp = {
				-- on_attach = my_custom_on_attach,
				-- capabilities = my_custom_capabilities, -- e.g. lsp_status capabilities
				--- OR you can specify a function to deactivate or change or control how the config is created
				capabilities = function(config)
					config.specificThingIDontWant = false
					return config
				end,
				-- see the link below for details on each option:
				-- https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/tool/lsp_spec/README.md#client-workspace-configuration
				settings = {
					showTodos = true,
					completeFunctionCalls = true,
					analysisExcludedFolders = { "<path-to-flutter-sdk-packages>" },
					renameFilesWithClasses = "prompt", -- "always"
					enableSnippets = true,
					updateImportsOnRename = true, -- Whether to update imports and other directives when files are renamed. Required for `FlutterRename` command.
				},
			},
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(ev)
				vim.lsp.document_color.enable(false, { bufnr = ev.buf })
			end,
		})
	end,
}

