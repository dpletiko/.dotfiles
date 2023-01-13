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
		'nvim-telescope/telescope.nvim', tag = '0.1.0',
		-- or                            , branch = '0.1.x',
		requires = {
			{'nvim-lua/plenary.nvim'},
			{ "nvim-telescope/telescope-live-grep-args.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
		},
		config = function()
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("live_grep_args")
		end
	}

	use { "ellisonleao/gruvbox.nvim" }

	use({'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'})
	use('nvim-treesitter/playground')
	use('theprimeagen/harpoon')
	use('mbbill/undotree')
	use('tpope/vim-fugitive')


	-- Track the engine.
	-- use("SirVer/ultisnips")
	-- Snippets are separated from the engine. Add this if you want them:
	-- use("honza/vim-snippets")

	use("mattn/emmet-vim")
	use("jwalton512/vim-blade")
	use("sheerun/vim-polyglot")

	use("tpope/vim-commentary")

	use("folke/neodev.nvim")

	use {
		'VonHeikemen/lsp-zero.nvim',
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

	use("folke/zen-mode.nvim")
	use("github/copilot.vim")

	use("gruvbox-community/gruvbox")
	use("sainnhe/sonokai")

end)

