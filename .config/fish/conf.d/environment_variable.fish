#!/bin/fish

set -gx EDITOR vim

set PATH $HOME/.emacs.d/bin $PATH

## Chinese language support
set -gx GTK_IM_MODULE fcitx
set -gx QT_IM_MODULE fcitx
set -gx XMODIFIERS @im=fcitx
