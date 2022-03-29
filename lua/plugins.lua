-- install packer if not there
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

--look for gh cli
local gh_path = '/usr/bin/gh'
if fn.empty(fn.glob(gh_path)) > 0 then
	gh_warning = function ()
		print('WARNING: Required dep. of octo.nvim Github Cli is not installed!')
	end
end

return require('packer').startup(function(use)
  -- My plugins here
  -- use 'foo1/bar1.nvim'
  -- use 'foo2/bar2.nvim'
  use 'wbthomason/packer.nvim'
  use 'chriskempson/base16-vim'

  use 'marko-cerovac/material.nvim'
  use 'chentau/marks.nvim'
  use 'tversteeg/registers.nvim'
  use 'tikhomirov/vim-glsl'
  use 'rust-lang/rust.vim'

  use {
	  'lukas-reineke/indent-blankline.nvim',
	  config = function()
		  require('indent_blankline').setup{
			  show_end_of_line = true,
		  }
	  end
  }

  use {
	  'numToStr/FTerm.nvim',
	  config = function()
		  require('FTerm').setup{
			  border = 'single',
			  dimensions = {
				  height = 0.9,
				  width = 0.9,
			  },
		  }
	  end
  }

  use 'yamatsum/nvim-cursorline'

  use {
	  'lukas-reineke/indent-blankline.nvim',
	  config = function()
		  require('indent_blankline').setup{
			  show_end_of_line = true,
		  }
	  end
  }
  --required by telescope.nvim
  use 'nvim-lua/plenary.nvim'

  --required by octo.nvim
  use 'kyazdani42/nvim-web-devicons'


  --required by octo.nvim
  use {
	  'nvim-telescope/telescope.nvim',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  --NOTE: Requires github cli to work
  --https://cli.github.com/manual/installation
  --https://cli.github.com/manual/gh_auth_login
  use {'pwntester/octo.nvim', config=function()
	  require"octo".setup({
		  default_remote = {"upstream", "origin"}; -- order to try remotes
		  reaction_viewer_hint_icon = "";         -- marker for user reactions
		  user_icon = " ";                        -- user icon
		  timeline_marker = "";                   -- timeline marker
		  timeline_indent = "2";                   -- timeline indentation
		  right_bubble_delimiter = "";            -- Bubble delimiter
		  left_bubble_delimiter = "";             -- Bubble delimiter
		  github_hostname = "";                    -- GitHub Enterprise host
		  snippet_context_lines = 4;               -- number or lines around commented lines
		  file_panel = {
			  size = 10,                             -- changed files panel rows
			  use_icons = true                       -- use web-devicons in file panel
		  },
		  mappings = {
			  issue = {
				  close_issue = "<space>ic",           -- close issue
				  reopen_issue = "<space>io",          -- reopen issue
				  list_issues = "<space>il",           -- list open issues on same repo
				  reload = "<C-r>",                    -- reload issue
				  open_in_browser = "<C-b>",           -- open issue in browser
				  copy_url = "<C-y>",                  -- copy url to system clipboard
				  add_assignee = "<space>aa",          -- add assignee
				  remove_assignee = "<space>ad",       -- remove assignee
				  create_label = "<space>lc",          -- create label
				  add_label = "<space>la",             -- add label
				  remove_label = "<space>ld",          -- remove label
				  goto_issue = "<space>gi",            -- navigate to a local repo issue
				  add_comment = "<space>ca",           -- add comment
				  delete_comment = "<space>cd",        -- delete comment
				  next_comment = "]c",                 -- go to next comment
				  prev_comment = "[c",                 -- go to previous comment
				  react_hooray = "<space>rp",          -- add/remove 🎉 reaction
				  react_heart = "<space>rh",           -- add/remove ❤️ reaction
				  react_eyes = "<space>re",            -- add/remove 👀 reaction
				  react_thumbs_up = "<space>r+",       -- add/remove 👍 reaction
				  react_thumbs_down = "<space>r-",     -- add/remove 👎 reaction
				  react_rocket = "<space>rr",          -- add/remove 🚀 reaction
				  react_laugh = "<space>rl",           -- add/remove 😄 reaction
				  react_confused = "<space>rc",        -- add/remove 😕 reaction
			  },
			  pull_request = {
				  checkout_pr = "<space>po",           -- checkout PR
				  merge_pr = "<space>pm",              -- merge PR
				  list_commits = "<space>pc",          -- list PR commits
				  list_changed_files = "<space>pf",    -- list PR changed files
				  show_pr_diff = "<space>pd",          -- show PR diff
				  add_reviewer = "<space>va",          -- add reviewer
				  remove_reviewer = "<space>vd",       -- remove reviewer request
				  close_issue = "<space>ic",           -- close PR
				  reopen_issue = "<space>io",          -- reopen PR
				  list_issues = "<space>il",           -- list open issues on same repo
				  reload = "<C-r>",                    -- reload PR
				  open_in_browser = "<C-b>",           -- open PR in browser
				  copy_url = "<C-y>",                  -- copy url to system clipboard
				  add_assignee = "<space>aa",          -- add assignee
				  remove_assignee = "<space>ad",       -- remove assignee
				  create_label = "<space>lc",          -- create label
				  add_label = "<space>la",             -- add label
				  remove_label = "<space>ld",          -- remove label
				  goto_issue = "<space>gi",            -- navigate to a local repo issue
				  add_comment = "<space>ca",           -- add comment
				  delete_comment = "<space>cd",        -- delete comment
				  next_comment = "]c",                 -- go to next comment
				  prev_comment = "[c",                 -- go to previous comment
				  react_hooray = "<space>rp",          -- add/remove 🎉 reaction
				  react_heart = "<space>rh",           -- add/remove ❤️ reaction
				  react_eyes = "<space>re",            -- add/remove 👀 reaction
				  react_thumbs_up = "<space>r+",       -- add/remove 👍 reaction
				  react_thumbs_down = "<space>r-",     -- add/remove 👎 reaction
				  react_rocket = "<space>rr",          -- add/remove 🚀 reaction
				  react_laugh = "<space>rl",           -- add/remove 😄 reaction
				  react_confused = "<space>rc",        -- add/remove 😕 reaction
			  },
			  review_thread = {
				  goto_issue = "<space>gi",            -- navigate to a local repo issue
				  add_comment = "<space>ca",           -- add comment
				  add_suggestion = "<space>sa",        -- add suggestion
				  delete_comment = "<space>cd",        -- delete comment
				  next_comment = "]c",                 -- go to next comment
				  prev_comment = "[c",                 -- go to previous comment
				  select_next_entry = "]q",            -- move to previous changed file
				  select_prev_entry = "[q",            -- move to next changed file
				  close_review_tab = "<C-c>",          -- close review tab
				  react_hooray = "<space>rp",          -- add/remove 🎉 reaction
				  react_heart = "<space>rh",           -- add/remove ❤️ reaction
				  react_eyes = "<space>re",            -- add/remove 👀 reaction
				  react_thumbs_up = "<space>r+",       -- add/remove 👍 reaction
				  react_thumbs_down = "<space>r-",     -- add/remove 👎 reaction
				  react_rocket = "<space>rr",          -- add/remove 🚀 reaction
				  react_laugh = "<space>rl",           -- add/remove 😄 reaction
				  react_confused = "<space>rc",        -- add/remove 😕 reaction
			  },
			  submit_win = {
				  approve_review = "<C-a>",            -- approve review
				  comment_review = "<C-m>",            -- comment review
				  request_changes = "<C-r>",           -- request changes review
				  close_review_tab = "<C-c>",          -- close review tab
			  },
			  review_diff = {
				  add_review_comment = "<space>ca",    -- add a new review comment
				  add_review_suggestion = "<space>sa", -- add a new review suggestion
				  focus_files = "<leader>e",           -- move focus to changed file panel
				  toggle_files = "<leader>b",          -- hide/show changed files panel
				  next_thread = "]t",                  -- move to next thread
				  prev_thread = "[t",                  -- move to previous thread
				  select_next_entry = "]q",            -- move to previous changed file
				  select_prev_entry = "[q",            -- move to next changed file
				  close_review_tab = "<C-c>",          -- close review tab
				  toggle_viewed = "<leader><space>",   -- toggle viewer viewed state
			  },
			  file_panel = {
				  next_entry = "j",                    -- move to next changed file
				  prev_entry = "k",                    -- move to previous changed file
				  select_entry = "<cr>",               -- show selected changed file diffs
				  refresh_files = "R",                 -- refresh changed files panel
				  focus_files = "<leader>e",           -- move focus to changed file panel
				  toggle_files = "<leader>b",          -- hide/show changed files panel
				  select_next_entry = "]q",            -- move to previous changed file
				  select_prev_entry = "[q",            -- move to next changed file
				  close_review_tab = "<C-c>",          -- close review tab
				  toggle_viewed = "<leader><space>",   -- toggle viewer viewed state
			  }
		  }
	  })
  end}


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end

  if gh_warning then
	  gh_warning()
  end
end)



