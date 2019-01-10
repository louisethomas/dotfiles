#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

PROMPT_COMMAND='status="[$?]"; if [[ $status == "[0]" ]]; then status=; fi'
PS1='[\u@\h \W]$status\$ '
