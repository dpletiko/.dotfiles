local M = {}

local cache = {}

function M.get_project_php_version(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local fname = vim.api.nvim_buf_get_name(bufnr)

    if fname == "" then
        return nil
    end

    local dir = vim.fs.dirname(fname)

    -- Just find composer.json going up - it'll be at project root
    local composer_path = vim.fs.find({ "composer.json" }, {
        upward = true,
        path = dir,
        -- stop = vim.fs.dirname(vim.fs.find({ ".git" }, {
        --     upward = true, path = fname
        -- })[1] or vim.loop.os_homedir())
    })[1]

    if not composer_path then
        return nil
    end

    -- Check cache
    local stat = vim.loop.fs_stat(composer_path)
    if not stat then return nil end

    local mtime = stat.mtime.sec
    if cache[composer_path] and cache[composer_path].mtime == mtime then
        return cache[composer_path].version
    end

    -- Read and parse
    local ok, data = pcall(vim.fn.readfile, composer_path)
    if not ok then return nil end

    local success, decoded = pcall(vim.json.decode, table.concat(data, "\n"))
    if not success then return nil end

    local version = decoded.require and decoded.require.php
        or decoded["require-dev"] and decoded["require-dev"].php

    cache[composer_path] = { mtime = mtime, version = version }
    return version
end

-- Extract numeric version from constraint (^8.1 -> 8.1, >=7.4 -> 7.4)
local function extract_version(constraint)
    if not constraint then return nil end
    local major, minor = constraint:match("(%d+)%.(%d+)")
    return major and minor and tonumber(major .. "." .. minor) or nil
end

function M.satisfies_min_version(min_version, bufnr)
    local project_version = M.get_project_php_version(bufnr)
    local project_num = extract_version(project_version)
    local min_num = tonumber(min_version)

    if not project_num or not min_num then
        return false
    end

    return project_num >= min_num
end

return M
