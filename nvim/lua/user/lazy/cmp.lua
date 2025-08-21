return {
  "hrsh7th/nvim-cmp",
  version = false, -- last release is way too old
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
  },
  -- Not all LSP servers add brackets when completing a function.
  -- To better deal with this, LazyVim adds a custom option to cmp,
  -- that you can configure. For example:
  --
  -- ```lua
  -- opts = {
  --   auto_brackets = { "python" }
  -- }
  -- ```
  opts = function()
    vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

    -- local cmp_lsp = require("cmp_nvim_lsp")
    -- local capabilities = vim.tbl_deep_extend(
    --     "force",
    --     {},
    --     vim.lsp.protocol.make_client_capabilities(),
    --     cmp_lsp.default_capabilities()
    -- )
    -- capabilities.textDocument.completion.completionItem.snippetSupport = true

    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local defaults = require("cmp.config.default")()
    local auto_select = true
    return {
      auto_brackets = {}, -- configure any filetype to auto add brackets
      completion = {
        completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
      },
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered()
      },
      preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
      mapping = cmp.mapping.preset.insert({
        -- go to next placeholder in the snippet
        ['<C-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            -- elseif has_words_before() then
            --   cmp.complete()
            else
                fallback()
            end
            -- if luasnip.jumpable(1) then
            --   luasnip.jump(1)
            -- else
            --   fallback()
            -- end
        end, {'i', 's'}),

        -- go to previous placeholder in the snippet
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {'i', 's'}),


        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<C-y>'] = cmp.mapping.confirm({
            -- behavior = cmp.ConfirmBehavior.Insert, -- TODO: Verify my config value
            select = true -- Set `select` to `false` to only confirm explicitly selected items.
        }),
        ["<C-e>"] = function(fallback)
          cmp.abort()
          fallback()
        end,
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete({
            reason = cmp.ContextReason.Auto,
        }), {"i", "c"}),
        -- ["<C-Space>"] = cmp.mapping.complete(),
        -- ["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      }),
      sources = cmp.config.sources({
        { name = "supermaven" },
        { name = "nvim_lsp" },
        { name = "lazydev" },
        { name = 'luasnip' }, -- For luasnip users.
        { name = 'emmet_ls' },
        { name = "path" },
      }, {
        { name = "buffer" },
      }),
      -- formatting = {
      --   format = function(entry, item)
      --     local icons = LazyVim.config.icons.kinds
      --     if icons[item.kind] then
      --       item.kind = icons[item.kind] .. item.kind
      --     end

      --     local widths = {
      --       abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
      --       menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
      --     }

      --     for key, width in pairs(widths) do
      --       if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
      --         item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
      --       end
      --     end

      --     return item
      --   end,
      -- },
      experimental = {
        -- only show ghost text when we show ai completions
        ghost_text = vim.g.ai_cmp and {
          hl_group = "CmpGhostText",
        } or false,
      },
      sorting = defaults.sorting,
    }
  end,
  -- main = "lazyvim.util.cmp",
}
