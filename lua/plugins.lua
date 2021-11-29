-- install packer if not there
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
  -- My plugins here
  -- use 'foo1/bar1.nvim'
  -- use 'foo2/bar2.nvim'
  use 'wbthomason/packer.nvim'

  use {
	  'blackCauldron7/surround.nvim',
	  config = function()
		  require('surround').setup{
			  mappings_style = 'surround'
		  }
	  end
  }

  use 'marko-cerovac/material.nvim'
  use 'chentau/marks.nvim'
  use 'gennaro-tedesco/nvim-peekup'
  use 'tikhomirov/vim-glsl'
  use 'rust-lang/rust.vim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)



