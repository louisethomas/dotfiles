#!/bin/bash
mkdir -p $HOME/.vim/pack
cd $HOME/.vim/pack
git init

# appearance 
git submodule add https://github.com/morhetz/gruvbox appearance/start/gruvbox

git submodule add https://github.com/Yggdroot/indentLine appearance/start/indent
vim -u NONE -c "helptags appearance/start/indent/doc" -c q


# plugins
git submodule add https://github.com/tpope/vim-commentary plugins/start/commentary
vim -u NONE -c "helptags plugins/start/commentary/doc" -c q

git submodule add https://github.com/tpope/vim-surround plugins/start/surround
vim -u NONE -c "helptags plugins/start/surround/doc" -c q

git submodule add https://github.com/skywind3000/asyncrun.vim plugins/opt/asyncrun
vim -u NONE -c "helptags plugins/opt/asyncrun/doc" -c q

git submodule add https://github.com/jupyter-vim/jupyter-vim plugins/opt/jupyter-vim
vim -u NONE -c "helptags plugins/opt/jupyter-vim/doc" -c q


# syntax 
git submodule add https://github.com/dense-analysis/ale syntax/start/ale
vim -u NONE -c "helptags syntax/start/ale/doc" -c q

git submodule add https://github.com/ycm-core/YouCompleteMe syntax/start/ycm
vim -u NONE -c "helptags syntax/start/ycm/doc" -c q
git submodule update --init --recursive
read -p "Would you like to install YouCompleteMe? [y/n] " ycmanswer
if [[ $ycmanswer = y ]] ; then
    ./syntax/start/ycm/install.py --all
fi

# to update
git submodule update --remote --merge
# git commit
