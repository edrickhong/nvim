-- install lazy if not there
local fn = vim.fn
local install_path = fn.stdpath('data')..'/lazy/lazy.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', install_path})
end
vim.opt.rtp:prepend(install_path)


return require('lazy').setup({
	'chriskempson/base16-vim'

	,'tpope/vim-surround'

	,'marko-cerovac/material.nvim'
	,'chentoast/marks.nvim'
	,'tversteeg/registers.nvim'
	,'tikhomirov/vim-glsl'

	,'yamatsum/nvim-cursorline'

	,{
		'lukas-reineke/indent-blankline.nvim',
		config = function()
			require('ibl').setup{
			}
		end
	}

	--required by telescope.nvim
	,'nvim-lua/plenary.nvim'

	--required by octo.nvim
	,'kyazdani42/nvim-web-devicons'

	--required by octo.nvim
	,{
		'nvim-telescope/telescope.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' }
	}

	,{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate'
	}

	,'neovim/nvim-lspconfig'

	,'kevinhwang91/promise-async'
	,{
		'kevinhwang91/nvim-ufo',
		dependencies = { 'kevinhwang91/promise-async' }
	}

})

