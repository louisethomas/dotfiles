set nocompatible              " required
set shell=/bin/bash
filetype on                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()


" " let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
"
" " add all your plugins here 
Plugin 'ycm-core/YouCompleteMe' " Python auto-completer
Plugin 'dense-analysis/ale' "Python linting
Plugin 'skywind3000/asyncrun.vim' " Execute python scripts asynchronously
Plugin 'tpope/vim-commentary' " Commenter
Plugin 'tpope/vim-surround' " Add and remove brackets etc
Plugin 'Yggdroot/indentLine' " Display indentation levels
Plugin 'morhetz/gruvbox' " Gruvbox color scheme 
Plugin 'powerline/powerline' "powerline
"Plugin 'jupyter-vim/jupyter-vim' " 2-way integration between Vim and Jupyter
Plugin 'jpalardy/vim-slime' "for python REPL (read-eval-print-loop)


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

set number 
set wildmenu 
set mouse=a
set incsearch
set hlsearch
set splitbelow

set laststatus=2 "show powerline all the time

" Set colors
set background=dark
syntax enable
colorscheme gruvbox
let python_highlight_all=1

set cursorline
" Default Colors for CursorLine
highlight  CursorLine ctermbg=None ctermfg=None
" Change Color when entering Insert Mode
autocmd InsertEnter * highlight  CursorLine ctermbg=DarkGrey ctermfg=Red
" Revert Color to default when leaving Insert Mode
autocmd InsertLeave * highlight  CursorLine ctermbg=None ctermfg=None

let $PYTHONUNBUFFERED = 1
let g:asyncrun_open = 10

" YouCompleteMe settings
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_global_ycm_extra_conf = "~/.vim/bundle/.ycm_extra_conf.py"

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with spacebar
nnoremap <space> za

" Remap esc to 'jj' for exiting insert mode 
inoremap jj <esc>l

" Clear last search highlighting
nnoremap <CR> :noh<CR><CR>

" Set target for vim-slime
let g:slime_target = "tmux"
let g:slime_paste_file = "$HOME/.slime_paste"
let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.2"}

" Execute python code using =
autocmd FileType python nnoremap <buffer> Z= :w<CR>:AsyncRun -raw python %<CR>

" ALE shortcuts (python linting)
nmap <silent> <leader>aj :ALENext<cr>
nmap <silent> <leader>ak :ALEPrevious<cr>
nmap <silent> <leader>at :ALEToggle<cr>
let g:ale_fixers = {'python':['black']}
let g:ale_fix_on_save = 1

" Set tab to indent
nnoremap <Tab> >> 
nnoremap <S-Tab> << 
vnoremap <Tab> >
vnoremap <S-Tab> <

" Set tabs to 4 spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" For inserting a single character
nnoremap ,i i_<Esc>r
nnoremap ,a a_<Esc>r

" Use F2 to toggle autoindent when pasting 
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode
