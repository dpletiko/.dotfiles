local dap = require('dap')

require('flutter-tools').setup({
  debugger = {
    enabled = true,
    run_via_dap = true,
    exception_breakpoints = {},
    register_configurations = function(_)
      dap.adapters.dart = {
        type = "executable",
        command = "node",
        args = { "/home/dpleti/git/Dart-Code/out/dist/debug.js", "flutter" }
      }
      dap.configurations.dart = {
        {
          type = "dart",
          dartSdkPath = os.getenv('HOME').."/git/flutter/bin/cache/dart-sdk/",
          flutterSdkPath = os.getenv('HOME').."/git/flutter",
        }
      }
      require("dap.ext.vscode").load_launchjs()
      -- require("flutter-tools.lsp").get_lsp_root_dir() .. "/.vscode/launch.json")
    end,
  },
  dev_log = {
    enabled = false,
  },
  lsp = require('lsp-zero').build_options('dartls', {}),
  -- lsp = {
  --   autostart = true,
  --   on_attach = (function(client, bufnr)
  --     print("FLUTTER TOOLS ON ATTACH")
  --     require('lsp-zero').on_attach(client, bufnr)
  --   end),
  -- }
})
