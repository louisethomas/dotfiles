set nocompatible              " required
set shell=/bin/bash
filetype on                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/dotfiles/.vim/bundle/Vundle.vim
call vundle#begin()


" " let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
"
" " add all your plugins here 
Plugin 'ycm-core/YouCompleteMe' " Python auto-completer
Plugin 'vim-scripts/indentpython.vim'
Plugin 'skywind3000/asyncrun.vim' " Execute python scripts asynchronously
Plugin 'tomtom/tcomment_vim' " Commenter  
Plugin 'Yggdroot/indentLine' " Display indentation levels
Plugin 'morhetz/gruvbox' " Gruvbox color scheme 
Plugin 'scrooloose/nerdtree' " File tree
Plugin 'powerline/powerline' "powerline
Plugin 'Mizuchi/vim-ranger' " Ranger file manager
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
let g:gruvbox_bold = 1
let g:gruvbox_italic = 1
let g:gruvbox_italicize_strings=1
colorscheme gruvbox
syntax enable
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

" close auto-complete window 
let g:ycm_autoclose_preview_window_after_completion=1

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with spacebar
nnoremap <space> za

" Remap esc to 'ii' for exiting insert mode 
inoremap ii <esc>l

" Clear last search highlighting
nnoremap <CR> :noh<CR><CR>

" Set target for vim-slime
let g:slime_target = "vimterminal"

" Execute python code using =
autocmd FileType python nnoremap <buffer> = :w<CR>:!pipenv run python %<CR>

" Set tab to indent
nnoremap <Tab> >> 
nnoremap <S-Tab> << 
vnoremap <Tab> >
vnoremap <S-Tab> <
