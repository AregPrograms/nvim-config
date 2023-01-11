require("packer").startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'voldikss/vim-floaterm'
    use 'rebelot/kanagawa.nvim'
	use {
  		"nvim-neo-tree/neo-tree.nvim",
    		branch = "v2.x",
    		requires = { 
      		    "nvim-lua/plenary.nvim",
      		    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      		    "MunifTanjim/nui.nvim",
    	}
  	}
  	use {
  		'nvim-telescope/telescope.nvim', tag = '0.1.0',
  		requires = { {'nvim-lua/plenary.nvim'} }
	}
end)

function startup()

    -- commands to execute on startup
	local commands = {
        "set tabstop=4",
		"set shiftwidth=4",
		"set expandtab",
		"set number",
		"set cursorline",

		"colo onedark",
		"set termguicolors",

        "call plug#begin()",
        "Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}",
        "Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}",
        "Plug 'nvim-lualine/lualine.nvim'",
        "Plug 'kyazdani42/nvim-web-devicons'",
        "Plug 'dominikduda/vim_current_word'",
        "call plug#end()",

        "let g:floaterm_keymap_toggle = '<F1>'",
        "noremap <Bar> :vsplit<Enter>",
        "noremap <Bslash> :split<Enter>",
        "noremap <C-DOWN> :resize -5<Enter>",
        "noremap <C-UP> :resize +5<Enter>",
        "noremap <C-LEFT> :vertical resize -5<Enter>",
        "noremap <C-RIGHT> :vertical resize +5<Enter>",
        "noremap <C-S> :w<Enter>",

        --"let g:vim_current_word#highlight_twins = 1",
        --"let g:vim_current_word#highlight_current_word = 1",
	}

    -- execute every command in commands
	for _, cmd in ipairs(commands) do
		vim.cmd(cmd)
	end

    vim.g.coq_settings = {
        auto_start = "shut-up"
    }

    require("lualine").setup()
end

startup()
