vim.cmd.packadd('packer.nvim')

local packer = require("packer")

-- Have packer use a popup window
packer.init({
		display = {
			open_fn = function()
				return require('packer.util').float({ border = 'single' })
			end
		}
	}
)

return packer.startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.2',
		-- or                            , branch = '0.1.x',
		requires = {
			{'nvim-lua/plenary.nvim'},
			{ "nvim-telescope/telescope-live-grep-args.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
			-- { "nvim-telescope/telescope-dap.nvim" }
		},
		config = function()
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("live_grep_args")
			-- require("telescope").load_extension("dap")
			require("telescope").load_extension("flutter")
		end
	}

	use { "ellisonleao/gruvbox.nvim" }

	use({'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'})
	use('nvim-treesitter/playground')
	use('theprimeagen/harpoon')
	use('mbbill/undotree')
	use('tpope/vim-fugitive')
	use('tpope/vim-surround')


	-- Track the engine.
	-- use("SirVer/ultisnips")
	-- Snippets are separated from the engine. Add this if you want them:
	-- use("honza/vim-snippets")

	-- use("mattn/emmet-vim")
	use("jwalton512/vim-blade")
	use("sheerun/vim-polyglot")

	-- use("tpope/vim-commentary")
	use {
		'JoosepAlviste/nvim-ts-context-commentstring',
		config = function()
			require('ts_context_commentstring').setup {
			  enable_autocmd = false,
			}
		end,
	}
	use {
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup {
				toggler = {
					line = 'gcc',     -- Line-comment toggle key
					block = 'gbc',    -- Block-comment toggle key
				},
				opleader = {
					line = 'gc',      -- Operator-pending line-comment toggle key
					block = 'gb',     -- Operator-pending block-comment toggle key
				},
				mappings = {
					basic = true,     -- Basic keymaps like `gcc` and `gbc`
					extra = true,    -- Extra mappings like `gco`, `gcO`, `gcA`
				},
				pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
				-- pre_hook = function()
				--   return vim.bo.commentstring
				-- end,
			}
		end,
		-- requires = {
		-- 	'JoosepAlviste/nvim-ts-context-commentstring',
		-- }
	}

	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		requires = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},
			{'williamboman/mason.nvim'},
			{'williamboman/mason-lspconfig.nvim'},

			-- Autocompletion
			{'hrsh7th/nvim-cmp'},
			{'hrsh7th/cmp-buffer'},
			{'hrsh7th/cmp-path'},
			{'saadparwaiz1/cmp_luasnip'},
			{'hrsh7th/cmp-nvim-lsp'},
			{'hrsh7th/cmp-nvim-lua'},

			-- Snippets
			{'L3MON4D3/LuaSnip'},
			{'rafamadriz/friendly-snippets'},

			-- addons
			{'tamago324/nlsp-settings.nvim'}
		}
	}


	use("folke/neodev.nvim")
	-- use('mfussenegger/nvim-dap')
	use {
		"rcarriga/nvim-dap-ui",
		requires = {
			{"mfussenegger/nvim-dap"},
			{"nvim-neotest/nvim-nio"},
		}
	}

	use {
		'akinsho/flutter-tools.nvim',
		requires = {
			'nvim-lua/plenary.nvim',
			'stevearc/dressing.nvim', -- optional for vim.ui.select
		}
	}

	use("folke/zen-mode.nvim")
	-- use("github/copilot.vim")

	-- use("gruvbox-community/gruvbox")
	use("sainnhe/sonokai")

	use('mortepau/codicons.nvim')
end)

