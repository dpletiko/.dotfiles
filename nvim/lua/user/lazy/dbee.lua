local function read_env(path)
    local vars = {}
    local file = io.open(path, "r")
    if not file then return vars end
    for line in file:lines() do
        local key, value = line:match("([^=]+)=([^\n\r#]+)")
        if key and value then
            vars[key] = value
        end
    end
    file:close()
    return vars
end

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
                        id = "pg_13",
                        name = "pg_13",
                        type = "postgres",
                        url = "postgres://postgres:postgres@localhost:5433/?sslmode=disable",
                    }, {
                    id = "pg_17",
                    name = "pg_17",
                    type = "postgres",
                    url = "postgres://postgres:postgres@localhost:5432/?sslmode=disable",
                }, {
                    id = "postgis",
                    name = "postgis",
                    type = "postgres",
                    url = "postgres://postgres:postgres@localhost:5434/?sslmode=disable",
                },
                }),

                require("dbee.sources").EnvSource:new("DBEE_CONNECTIONS"),
            },
        })

        vim.keymap.set("n", "<leader>dt", function() require("dbee").toggle() end)

        local env = read_env(vim.fn.getcwd() .. "/.env")

        if env and next(env) then
            if env.DB_CONNECTION == "mysql" then
                vim.fn.setenv(
                    "DBEE_CONNECTIONS",
                    string.format(
                        '[{"name":"%s","url":"%s","type":"mysql"}]',
                        env.APP_NAME or "ENV: Project",
                        string.format("%s:%s@tcp(%s:%s)/%s",
                            env.DB_USERNAME or "",
                            env.DB_PASSWORD or "",
                            env.DB_HOST or "127.0.0.1",
                            env.DB_PORT or "3306",
                            env.DB_DATABASE or ""
                        )
                    )
                )
            elseif env.DB_CONNECTION == "pgsql" or env.DB_CONNECTION == "postgres" then
                vim.fn.setenv(
                    "DBEE_CONNECTIONS",
                    string.format(
                        '[{"name":%s,"url":"%s","type":"postgres"}]',
                        env.APP_NAME or "ENV: Project",
                        string.format("postgres://%s:%s@%s:%s/%s?sslmode=disable",
                            env.DB_USERNAME or "",
                            env.DB_PASSWORD or "",
                            env.DB_HOST or "127.0.0.1",
                            env.DB_PORT or "5432",
                            env.DB_DATABASE or ""
                        )
                    )
                )
            elseif env.DB_CONNECTION == "sqlite" then
                vim.fn.setenv(
                    "DBEE_CONNECTIONS",
                    string.format(
                        '[{"name":"%s","url":"%s","type":"sqlite"}]',
                        env.APP_NAME or "ENV: Project",
                        "sqlite://" .. (env.DB_DATABASE or "")
                    )
                )
            end

            -- print(vim.fn.getenv("DBEE_CONNECTIONS"))


            -- automatically activate on start
            -- small delay to ensure lazy-loaded plugins are ready
            -- make sure dbee is fully loaded first
            -- vim.defer_fn(function()
            --     require('dbee').activate("Laravel DB")
            -- end, 50)
        end
    end,
}
