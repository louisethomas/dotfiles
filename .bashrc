#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
[[ -z "$TMUX" ]] && exec tmux #start tmux when using bash

alias ls='ls --color=auto'

PROMPT_COMMAND='status="[$?]"; if [[ $status == "[0]" ]]; then status=; fi'
PS1='[\u@\h \W]$status\$ '

set -o vi
cd ~ #start in home folder
