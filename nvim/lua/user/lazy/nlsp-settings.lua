return {
    "tamago324/nlsp-settings.nvim",
    enabled = false,
    dependencies = {
        "neovim/nvim-lspconfig",
        "mason-org/mason.nvim",
        "mason-org/mason-lspconfig.nvim"
    },
    opts = {
        config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
        local_settings_dir = ".vscode",
        local_settings_root_markers_fallback = { '.git' },
        append_default_schemas = true,
        loader = 'json'
    }
}
