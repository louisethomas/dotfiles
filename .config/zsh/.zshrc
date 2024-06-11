# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# source files in .zsh folder
fpath=(~/.config/zsh/.zsh $fpath)

# key bindings
bindkey -v  # vim mode
bindkey "^[[1;5C" forward-word    # ctrl-right to go forward one word
bindkey "^[[1;5D" backward-word   # ctrl-left to go backward one word

# plugins
source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

# To customize prompt, run `p10k configure` or edit $ZDOTDIR/.p10k.zsh
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh

# formatting
zstyle ':completion:*' menu select interactive
zstyle ':completion:*:*:*:*:descriptions' format '%B%F{green} %d %b%f'
zstyle ':completion:*:*:*:*:corrections' format '%B%F{yellow}! %d (errors: %e) !$b%f'
zstyle ':completion:*:messages' format ' %B%F{purple} %d %b%f'
zstyle ':completion:*:warnings' format ' %B%F{red} no matches found %b%f'
zstyle ':completion:*' list-colors 'di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' file-sort date
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

alias ls='ls --color=auto'  # color ls output

# command history
export HISTFILE="$ZDOTDIR/.zhistory"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.

# directory stack
setopt AUTO_PUSHD           # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

# Set up zoxide
eval "$(zoxide init zsh --cmd cd)"

# never beep
setopt NO_BEEP

# track dotfiles with git
alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
dotfiles config status.showUntrackedFiles no

# aliases 
alias n='nvim'
alias vim='nvim'
