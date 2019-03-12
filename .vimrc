set nocompatible              " required
set shell=/bin/bash
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=/home/louise/.vim/bundle/Vundle.vim
call vundle#begin()


" " let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
"
" " add all your plugins here 
Plugin 'Valloric/YouCompleteMe' " Python auto-completer
Plugin 'w0rp/ale' " Python syntax checker
Plugin 'nvie/vim-flake8' 
Plugin 'vim-scripts/indentpython.vim'
Plugin 'skywind3000/asyncrun.vim' " Execute python scripts asynchronously
Plugin 'tomtom/tcomment_vim' " Commenter  
Plugin 'Yggdroot/indentLine' " Display indentation levels
Plugin 'altercation/vim-colors-solarized' " Colour scheme
Plugin 'morhetz/gruvbox' " Gruvbox color scheme 

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

syntax enable
set background=dark
colorscheme gruvbox


let $PYTHONUNBUFFERED = 1
let g:asyncrun_open = 10
