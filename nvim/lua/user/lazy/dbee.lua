return {
  "kndndrj/nvim-dbee",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  build = function()
    -- Install tries to automatically detect the install method.
    -- if it fails, try calling it with one of these parameters:
    --    "curl", "wget", "bitsadmin", "go"
    require("dbee").install()
  end,
  config = function()
    require("dbee").setup({
        sources = {
            require("dbee.sources").MemorySource:new({
                {
                    id = "pg_11",
                    name = "pg_11",
                    type = "postgres",
                    url = "postgres://postgres:postgres@localhost:5432/?sslmode=disable",
                }, {
                    id = "pg_13",
                    name = "pg_13",
                    type = "postgres",
                    url = "postgres://postgres:postgres@localhost:5433/?sslmode=disable",
                },
            }),
        },
    })

    vim.keymap.set("n", "<leader>dt", function() require("dbee").toggle() end)

  end,
}
