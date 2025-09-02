local uv = vim.uv
local fs = vim.fs

local Util = {}

-- normalize path: ~ expansion, forward slashes, remove trailing slashes
function Util.norm(path)
  if not path or path == "" then return "" end
  -- expand ~
  path = path:gsub("^~", uv.os_homedir())
  -- replace backslashes with forward slashes (Windows)
  path = path:gsub("\\", "/")
  -- remove trailing slash
  path = path:gsub("/$", "")
  return path
end

-- get real path of a buffer or cwd
function Util.realpath(path)
  if not path or path == "" then return nil end
  path = uv.fs_realpath(path) or path
  return Util.norm(path)
end

-- get buffer path
function Util.bufpath(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then return nil end
  return Util.realpath(name)
end

-- get current working directory normalized
function Util.cwd()
  return Util.realpath(uv.cwd())
end

-- detect root by looking for .git or lsp workspace folder
function Util.get(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()
  local bufpath = Util.bufpath(buf)
  if not bufpath then return Util.cwd() end

  -- try lsp root first
  for _, client in pairs(vim.lsp.get_clients()) do
    if client.attached_buffers[buf] and client.config.root_dir then
      local root = Util.norm(client.config.root_dir)
      if bufpath:find(root, 1, true) == 1 then
        return root
      end
    end
  end

  -- fallback: find .git folder
  local git_root = fs.find(".git", { path = bufpath, upward = true })[1]
  if git_root then
    return Util.norm(fs.dirname(git_root))
  end

  -- fallback to cwd
  return Util.cwd()
end

-- git root shortcut
function Util.git(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local root = Util.get({ buf = buf })
  local git_root = fs.find(".git", { path = root, upward = true })[1]
  return git_root and Util.norm(fs.dirname(git_root)) or root
end

---@param component any
---@param text string
---@param hl_group? string
---@return string
function Util.format(component, text, hl_group)
  text = text:gsub("%%", "%%%%")
  if not hl_group or hl_group == "" then
    return text
  end
  ---@type table<string, string>
  component.hl_cache = component.hl_cache or {}
  local lualine_hl_group = component.hl_cache[hl_group]
  if not lualine_hl_group then
    local utils = require("lualine.utils.utils")
    ---@type string[]
    local gui = vim.tbl_filter(function(x)
      return x
    end, {
      utils.extract_highlight_colors(hl_group, "bold") and "bold",
      utils.extract_highlight_colors(hl_group, "italic") and "italic",
    })

    lualine_hl_group = component:create_hl({
      fg = utils.extract_highlight_colors(hl_group, "fg"),
      gui = #gui > 0 and table.concat(gui, ",") or nil,
    }, "LV_" .. hl_group) --[[@as string]]
    component.hl_cache[hl_group] = lualine_hl_group
  end
  return component:format_hl(lualine_hl_group) .. text .. component:get_default_hl()
end

---@param opts? {relative: "cwd"|"root", modified_hl: string?, directory_hl: string?, filename_hl: string?, modified_sign: string?, readonly_icon: string?, length: number?}
function Util.pretty_path(opts)
  opts = vim.tbl_extend("force", {
    relative = "cwd",
    modified_hl = "MatchParen",
    directory_hl = "",
    filename_hl = "Bold",
    modified_sign = "",
    readonly_icon = " 󰌾 ",
    length = 3,
  }, opts or {})

  return function(self)
    local path = vim.fn.expand("%:p") --[[@as string]]

    if path == "" then
      return ""
    end

    path = Util.norm(path)
    local root = Util.get({ normalize = true })
    local cwd = Util.cwd()

    if opts.relative == "cwd" and path:find(cwd, 1, true) == 1 then
      path = path:sub(#cwd + 2)
    elseif path:find(root, 1, true) == 1 then
      path = path:sub(#root + 2)
    end

    local sep = package.config:sub(1, 1)
    local parts = vim.split(path, "[\\/]")

    if opts.length == 0 then
      parts = parts
    elseif #parts > opts.length then
      parts = { parts[1], "…", unpack(parts, #parts - opts.length + 2, #parts) }
    end

    if opts.modified_hl and vim.bo.modified then
      parts[#parts] = parts[#parts] .. opts.modified_sign
      parts[#parts] = Util.format(self, parts[#parts], opts.modified_hl)
    else
      parts[#parts] = Util.format(self, parts[#parts], opts.filename_hl)
    end

    local dir = ""
    if #parts > 1 then
      dir = table.concat({ unpack(parts, 1, #parts - 1) }, sep)
      dir = Util.format(self, dir .. sep, opts.directory_hl)
    end

    local readonly = ""
    if vim.bo.readonly then
      readonly = Util.format(self, opts.readonly_icon, opts.modified_hl)
    end
    return dir .. parts[#parts] .. readonly
  end
end

return Util
