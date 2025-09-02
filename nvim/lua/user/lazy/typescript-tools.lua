return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  enabled = false,
  opts = {},
  config = function()
    require("typescript-tools").setup {
      -- on_attach = on_attach,
      --   on_attach = function(client, bufnr)
      --       vim.api.nvim_exec_autocmds('LspAttach', {
      --         buffer = bufnr,
      --         data = { client_id = client.id }
      --       })
      --   end,
      filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"vue",
      },
      settings = {
        single_file_support = false,
        tsserver_plugins = {
            "@vue/language-server",
            "@vue/typescript-plugin",
        },
      },
    }
  end,
}
