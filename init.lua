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

require'nvim-treesitter.config'.setup {
  ensure_installed = { "nix", "c", "cpp", "python", "bash", "json", "yaml", "markdown", "lua"},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
	indent = {enable = true},
}

-- Set up nil (Nix language server)
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}



vim.lsp.config('nil_ls', {
  capabilities = capabilities,
  settings = {
    ["nil"] = {
      formatting = {
        command = { "alejandra" }
      }
    }
  }
})
vim.lsp.enable('nil_ls')


vim.lsp.config('clangd', { capabilities = capabilities })
vim.lsp.enable('clangd')

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- go to definition
    vim.keymap.set("n", "gh",  vim.lsp.buf.hover, opts) -- hover info
    vim.keymap.set("n", "gr", vim.lsp.buf.rename, opts) -- rename symbol
  end
})

-- ufo settings
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

require('ufo').setup({
  provider_selector = function(bufnr, filetype, buftype)
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    for _, c in ipairs(clients) do
      if c.server_capabilities and c.server_capabilities.foldingRangeProvider then
        return { 'lsp', 'indent' }
      end
    end
    return { 'treesitter', 'indent' }
  end,
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

-- indentation settings
vim.opt.expandtab = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true
vim.opt.autoindent = true


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

-- map terminal mode escape key
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])

map('n','Q',':q<CR>')

map('n','ZZ',':qa<CR>')


map('n','o','o<Esc>')
map('n','O','O<Esc>')
map('n','<C-CR>','i<CR><Esc>')
map('n','<Space>','i<Space><Esc>')
map('n','<Tab>','i<Tab><Esc>')

vim.keymap.set('n', 'K', function()
  local word = vim.fn.expand('<cword>')

  if vim.fn.winnr('$') == 1 then
    vim.cmd('vsplit')
  end

  vim.cmd('wincmd w')
  vim.cmd('Man ' .. word)
  vim.cmd('wincmd w')
end)

local tb = require('telescope.builtin')

vim.keymap.set('n', 'sf', tb.find_files)
vim.keymap.set('n', 'sg', tb.live_grep)
vim.keymap.set('n', 'sb', tb.buffers)



-- allows insertion of single char
map('n','<C-i>','i_<Esc>r')


-- custom commands
local scratch_buf = nil

vim.api.nvim_create_user_command("Scratch", function()
  if scratch_buf and vim.api.nvim_buf_is_valid(scratch_buf) then
    vim.cmd("buffer " .. scratch_buf)
    return
  end

  vim.cmd("enew")
  scratch_buf = vim.api.nvim_get_current_buf()

  vim.bo.buflisted = true
  vim.bo.swapfile = false
  vim.bo.undofile = false
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "hide"

  vim.api.nvim_buf_set_name(scratch_buf, "[Scratch]")
  vim.bo.modified = false

  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    buffer = scratch_buf,
    callback = function()
      vim.bo.modified = false
    end,
  })
end, {})





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
