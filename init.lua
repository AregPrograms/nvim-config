require("packer").startup(function(use)
	use 'wbthomason/packer.nvim'                        -- 📦 package manager
	use 'voldikss/vim-floaterm'                         -- 💻 terminal
    use 'rebelot/kanagawa.nvim'
	use {
  		"nvim-neo-tree/neo-tree.nvim",                  -- 🌳 file tree
    		branch = "v2.x",
    		requires = { 
      		    "nvim-lua/plenary.nvim",
      		    "nvim-tree/nvim-web-devicons",
      		    "MunifTanjim/nui.nvim",
    	}
  	}
  	use {
  		'nvim-telescope/telescope.nvim', tag = '0.1.0', -- 🔍 fuzzy finder
  		requires = { {'nvim-lua/plenary.nvim'} }
	}
    use {
        'nvim-treesitter/nvim-treesitter',              -- 🔤 syntax highlighting
        run = ':TSUpdate'
    }
    use 'rcarriga/nvim-notify'

end)

function startup()

    -- commands to execute on startup
	local commands = {
        
        -- set to 4 spaces 

        "set tabstop=4",
		"set shiftwidth=4",
		"set expandtab",

		"set number",
        "set nowrap",
		"set cursorline",

		"colo kanagawa",
		"set termguicolors",

        -- 🔌 plugins

        "call plug#begin()",
        "Plug 'nvim-lualine/lualine.nvim'",                 -- status bar
        "Plug 'kyazdani42/nvim-web-devicons'",
        "Plug 'dominikduda/vim_current_word'",
        "Plug 'nvim-treesitter/nvim-treesitter'",
        "Plug 'mattn/emmet-vim'",                           -- emmet for webdev
        "Plug 'neoclide/coc.nvim', {'branch': 'release'}",  -- intellisense
        "Plug 'xiyaowong/transparent.nvim'",                -- transparent background
        "call plug#end()",

        -- ⌨️   keybinds

        "let g:floaterm_keymap_toggle = '<F1>'",                -- toggle floaterm
        "noremap <C-F> :lua require('telescope.builtin').grep_string({ search = vim.fn.input('GREP > ') })<Enter>",
        "noremap <Bar> :vsplit<Enter>",                         -- split vertically
        "noremap <Bslash> :split<Enter>",                       -- split horizontally
        "noremap <C-DOWN> :resize -5<Enter>",
        "noremap <C-UP> :resize +5<Enter>",
        "noremap <C-LEFT> :vertical resize -5<Enter>",
        "noremap <C-RIGHT> :vertical resize +5<Enter>",
        "noremap <C-S> :w<Enter>",                              -- save
        "noremap <C-Q> :q!<Enter>",                             -- quit
        "noremap <C-I> :CocCommand prettier.formatFile<Enter>"  -- format file

        --"let g:vim_current_word#highlight_twins = 1",
        --"let g:vim_current_word#highlight_current_word = 1",
	}

    local popup = require("plenary.popup")

    -- execute every command in commands
	for _, cmd in ipairs(commands) do
		vim.cmd(cmd)
	end

    require("lualine").setup()

    require("neo-tree").setup {
        filesystem = {
            filtered_items = {
                visible = true,
                hide_dotfiles = false,
                hide_gitignored = false,
            }
        }
    }

    require'nvim-treesitter.configs'.setup {
      -- A list of parser names, or "all" (the four listed parsers should always be installed)
        ensure_installed = { "c", "python", "javascript", "lua", "c++" },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,

        ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
        -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

        highlight = {
            enable = true,

            -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
            -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
            -- the name of the parser)

            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            --additional_vim_regex_highlighting = false,
        },
    }

    --vim.keymap.set("n", "<C-N>", function()
    --    local filename = vim.fn.input("Enter Filename >>> ");
    --    local file = io.open(filename, "w")

    --    io.close(file)

    --    vim.cmd(":e " .. filename)
    --end)

    vim.keymap.set("n", "<C-n>", function() 
        local buf = vim.api.nvim_create_buf(false, false)

        vim.api.nvim_buf_attach(buf, false, {
            on_lines = function(_, _, _, first_line, last_line)
                local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
                
                if #lines == 2 then
                    local file = io.open(lines[1], "w")
                    io.close(file)

                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>:q!<Enter>", true, true, true), "n", true)
                    local timer = vim.loop.new_timer()

                    timer:start(100, 0, vim.schedule_wrap(function()
                        vim.api.nvim_buf_delete(buf, { force = true })
                        vim.cmd(":e " .. lines[1])
                    end))
                end
            end
        })
        vim.api.nvim_buf_set_option(buf, "modifiable", true)

        popup.create(buf, {
            title = "Create File",
            border = {1, 1, 1, 1},
            padding = {1, 2, 1, 2},
            minwidth = 20
        })
    end)
end

startup()

local keyset = vim.keymap.set
-- Autocomplete
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
