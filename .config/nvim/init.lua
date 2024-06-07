require("lazy-config")

-- options
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.foldmethod=indent
vim.opt.foldlevel=99
vim.opt.clipboard = "unnamedplus"	-- yank to system clipboard

-- key mappings
vim.keymap.set({'n', 'v'}, '<Tab>', '>>')	-- tab to indent
vim.keymap.set({'n', 'v'}, '<S-Tab>', '<<')
vim.keymap.set('n', '<space>', 'za')	-- folding with spacebar
vim.keymap.set('n', '<CR>', ':noh<CR><CR>')	-- clear last search highlighting
vim.keymap.set('n', ',i', 'i_<Esc>r')	-- insert a single character
vim.keymap.set('n', ',a', 'a_<Esc>r')	-- insert a single character
vim.keymap.set('i', 'jj', '<Esc>l')	-- 'jj' to exit insert mode

-- colorscheme
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
