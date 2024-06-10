require("lazy-config")

-- options
vim.opt.syntax = 'on'	-- enable syntax highlighting
vim.opt.number = true	-- enable line numbers
vim.opt.cursorline = true	-- highlight cursor line
vim.opt.wrap = true		-- enable line wrapping
vim.opt.spell = true	-- enable spell checking
vim.opt.expandtab = true	-- use spaces instead of tabs
vim.opt.tabstop = 4			-- tab = 4 spaces
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true	-- enable auto-indentation
vim.opt.smartindent = true	-- enable smart auto-indentation
vim.opt.mouse = 'a'		-- enable mouse support
vim.opt.foldenable = true	-- enable code folding
vim.opt.foldmethod='indent'
vim.opt.foldlevel=99
vim.opt.clipboard = "unnamedplus"	-- yank to system clipboard
vim.opt.incsearch = true	-- start searching as you type
vim.opt.hlsearch = true		-- highlight searches
vim.opt.smartcase = true	-- only case-sensitive if uppercase used

-- backups
vim.opt.undofile = true     -- enable persistent undo
vim.opt.backup = true       -- enable backups
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"    -- set folder for undo files
vim.opt.backupdir = vim.fn.stdpath("data") .. "/backup"    -- set folder for backup files
require("clean_old_files").clean_old_backups_and_undos()    -- remove files older than 1 week

-- key mappings
vim.keymap.set({'n', 'v'}, '<Tab>', '>>')	-- tab to indent
vim.keymap.set({'n', 'v'}, '<S-Tab>', '<<')
vim.keymap.set('n', '<space>', 'za')	-- folding with space bar
vim.keymap.set('n', '<CR>', ':noh<CR><CR>')	-- clear last search highlighting
vim.keymap.set('n', ',i', 'i_<Esc>r')	-- insert a single character
vim.keymap.set('n', ',a', 'a_<Esc>r')	-- insert a single character
vim.keymap.set('i', 'jj', '<Esc>l')	-- 'jj' to exit insert mode

-- color scheme
require('kanagawa').setup({
    ...,
    colors = {
        theme = {
            all = {
                ui = {
                    bg_gutter = "none"
                }
            }
        }
    },
    ...
})
vim.cmd("colorscheme kanagawa-wave")
--vim.cmd("colorscheme kanagawa-dragon")
--vim.cmd("colorscheme kanagawa-lotus")

