### Shell variables ###

export PATH="$PATH:$HOME/.local/bin:$HOME/go/bin"

ZSH=$HOME/.config/zsh 
ZSH_COMP_DIR=$HOME/.cache/zsh/completions
FPATH="$FPATH:$ZSH_COMP_DIR"

# History settings
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=$HISTSIZE

# Use nvim if available
if command -v nvim &> /dev/null; then
  export EDITOR="nvim"
fi

# Load brew PATH and FPATH (completions) if it's installed 
if [[ -f "/opt/homebrew/bin/brew" ]] then 
  eval "$(/opt/homebrew/bin/brew shellenv)"
  FPATH="$FPATH:$(brew --prefix)/share/zsh/site-functions"
fi


### Shell options ###

setopt hist_ignore_dups
setopt auto_cd


### Completion ###

# Make sure comp folder exists
mkdir -p $ZSH_COMP_DIR

zstyle ':completion:*' completer _complete _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' format "Completing %d"
zstyle ':completion:*' menu select=0
zstyle ':completion:*' group-name '' # Ommits empty comp groups 
zstyle ':completion:*' list-prompt '%SPaging (%p)%s'
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' '' '+r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' max-errors 1
zstyle ':completion:*' select-prompt '%SScrolling (%l)%s'
autoload -Uz compinit
compinit


### Key bindings ###

bindkey -e
bindkey "^[[1;2C" forward-word # Shift Left
bindkey "^[[1;6C" end-of-line # Ctrl Shift Left
bindkey "^[[1;2D" backward-word # Shift Right
bindkey "^[[1;6D" beginning-of-line # Ctrl Shift Right

# Search by prefix
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
# raw (rmkx) vs applicaiton (smkx) mode difference. Sometimes it gets stuck in one or another.
# oh-my-zsh sets them in zle-line-init and zle-line-finish. Too much hassle.
bindkey -s "^[0A" "^[[A"
bindkey "^[[A" up-line-or-beginning-search


autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey -s "^[0B" "^[[B"
bindkey "^[[B" down-line-or-beginning-search


### Plugins ###

source $ZSH/config/*
source $ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH/plugins/sudo/sudo.zsh
source $ZSH/plugins/kubectl-completion/kubectl-completion.zsh


### Aliases ###

alias sudi="sudo -i"
alias git-dotfile="/usr/bin/git --git-dir=$HOME/.dotfile-repo/ --work-tree=$HOME"

# Kubernetes
alias k="kubectl"
alias kns="kubens"
alias kctx="kubectx"


### Run oh-my-posh ###

OMP_SRC=$ZSH/posh.yaml
if [ $(tput colors) -lt 256 ]; then
       OMP_SRC=$ZSH/posh.simple.yaml
fi
eval "$(oh-my-posh init zsh -c $OMP_SRC)"
