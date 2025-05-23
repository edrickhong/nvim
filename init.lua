vim.opt.list = true
vim.opt.listchars:append("eol:↴")
-- plugins
require('plugins')


--TODO move this to plugins
require('marks').setup {
	-- whether to map keybinds or not. default true
	default_mappings = true,
	-- which builtin marks to show. default {}
	builtin_marks = { ".", "<", ">", "^" },
	-- whether movements cycle back to the beginning/end of buffer. default true
	cyclic = true,
	-- whether the shada file is updated after modifying uppercase marks. default false
	force_write_shada = false,
	-- how often (in ms) to redraw signs/recompute mark positions. 
	-- higher values will have better performance but may cause visual lag, 
	-- while lower values may cause performance penalties. default 150.
	refresh_interval = 250,
	-- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
	-- marks, and bookmarks.
	-- can be either a table with all/none of the keys, or a single number, in which case
	-- the priority applies to all marks.
	-- default 10.
	sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
	-- disables mark tracking for specific filetypes. default {}
	excluded_filetypes = {},
	-- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
	-- sign/virttext. Bookmarks can be used to group together positions and quickly move
	-- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
	-- default virt_text is "".
	bookmark_0 = {
		sign = "⚑",
		virt_text = "hello world"
	},
	mappings = {}
}

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "nix", "c", "cpp"},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

-- Set up nil (Nix language server)
require('lspconfig').nil_ls.setup {
  settings = {
    ["nil"] = {
      formatting = {
        command = { "alejandra" }
      }
    }
  }
}
require('lspconfig').clangd.setup {}


vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K",  vim.lsp.buf.hover, opts)
    -- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  end
})



--plugin setting
vim.g.cursorline_timeout = 5

-- color scheme
vim.opt.termguicolors = true
vim.cmd('colorscheme base16-default-dark')

-- my settings
vim.opt.number = true
vim.opt.relativenumber = true


vim.opt.autoread = true
vim.opt.ruler = true
vim.opt.showmatch = true
vim.opt.smarttab = true


vim.opt.wildmenu = true
vim.opt.ttyfast  = true
vim.opt.showmode = true
vim.opt.showcmd = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true





vim.opt.errorbells = false
vim.opt.compatible = false
vim.opt.visualbell = false

vim.opt.writebackup = false
vim.opt.backup = false
vim.opt.wb = false
vim.opt.swapfile = false

vim.opt.path = vim.opt.path + '**'

vim.opt.foldenable = false
vim.opt.foldmethod = 'manual'


vim.opt.autochdir = true

vim.g.netrw_dirhistmax = 0

vim.opt.syntax = 'enable'
vim.cmd('filetype plugin indent on')

vim.cmd('vsplit')


local function map(mode,lhs,rhs,opts)
	local options = {noremap = true}
	if opts then
		options = opts
	end
	vim.api.nvim_set_keymap(mode,lhs,rhs,options)
end -- replace ex mode with quit window

-- map fterm
map('n','<f2>','<CMD>lua require("FTerm").toggle()<CR>')

map('n','Q',':q<CR>')

map('n','ZZ',':qa<CR>')


map('n','o','o<Esc>')
map('n','O','O<Esc>')
map('n','<C-CR>','i<CR><Esc>')
map('n','<Space>','i<Space><Esc>')
map('n','<Tab>','i<Tab><Esc>')

-- allows insertion of single char
map('n','<C-i>','i_<Esc>r')


-- linux building
w_dir = vim.fn.getcwd()

local function isMake(ftype)
	return ftype == 'c' or ftype == 'cpp' or ftype == 'glsl'
end

c_build_cmd = 'make -j12 -B -C ' .. w_dir .. '/build/'
if vim.loop.os_uname().sysname == 'Windows_NT'  then
	c_build_cmd =  'msbuild ' .. w_dir .. '/build/ALL_BUILD.vcxproj /m:12'
end

function Build()
	ftype = vim.bo.filetype

	if isMake(ftype) then
		vim.bo.makeprg = c_build_cmd
		--vim.bo.makeprg = 'make -j12 -C ' .. w_dir .. '/build/'
		vim.cmd('wa')
		vim.cmd('make!')
		vim.cmd('copen')
	else
		print('Build Error:File type not handled!')
	end
end

map('n','<f1>',':wa | lua Build()<CR>')


function dump(o)
	if type(o) == 'table' then
		local s = '{ '
		for k,v in pairs(o) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			s = s .. '['..k..'] = ' .. dump(v) .. ','
		end
		return s .. '} '
	else
		return tostring(o)
	end
end



function OpenQuickFixList()
	vim.cmd[[
	let list = getqflist()
	let hasvalid = 0

	for item in list
		let i = item.valid
		let hasvalid = hasvalid + i
	endfor

	if hasvalid
		wincmd o
		set splitright
		vert cwindow
		wincmd =
	endif
	]]
end

function ReloadConfig()
	local hls_status = vim.v.hlsearch
	for name,_ in pairs(package.loaded) do
		if name:match('^cnull') then
			package.loaded[name] = nil
		end
	end
	dofile(vim.env.MYVIMRC)
	if hls_status == 0 then
		vim.opt.hlsearch = false
	end
end


function nvim_create_augroups(definitions)
	for group_name, definition in pairs(definitions) do
		vim.api.nvim_command('augroup '..group_name)
		vim.api.nvim_command('autocmd!')
		for _, def in ipairs(definition) do
			-- if type(def) == 'table' and type(def[#def]) == 'function' then
			-- 	def[#def] = lua_callback(def[#def])
			-- end
			local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
			vim.api.nvim_command(command)
		end
		vim.api.nvim_command('augroup END')
	end
end

-- autocmds
-- TODO: I think this is old. update these ig
nvim_create_augroups({
	reload_config = {
		{'BufWritePre', '$MYVIMRC', 'lua ReloadConfig()'},
	},

	resize_window = {
		{'VimResized','*',':wincmd ='},
	},

	toggle_search_highlight = {
		{'InsertEnter','*','setlocal nohlsearch'},
	},

	quickfix = {
		{'QuickFixCmdPost','[^l]*','lua OpenQuickFixList()'},
	},

	install_suckless = {
		{'BufWritePost','config.h,config.def.h','!make && make install'}
	},
})
