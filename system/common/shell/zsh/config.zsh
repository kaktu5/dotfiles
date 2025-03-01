export HISTFILE=~/.cache/zsh-history
export HISTSIZE=16384
export SAVEHIST=16384
setopt SHARE_HISTORY

bindkey -v
export KEYTIMEOUT=1

export AUTO_NOTIFY_THRESHOLD=30
export AUTO_NOTIFY_TITLE='`%command` finished'
export AUTO_NOTIFY_BODY='Completed in %elapseds (%exit_code)'

autoload -U compinit
zstyle ':completion:*' menu no
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' popup-pad 24 0
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color always $realpath'
zmodload zsh/complist
zsh-defer compinit

function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}

zle -N zle-keymap-select
zle-line-init() {
    zle -K viins
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q'
preexec() { echo -ne '\e[5 q'; }

function nd() { nix develop -c zsh; }
function nr() { nix run "nixpkgs#$1" -- $(shift; echo "$@"); }
function ns() { nix shell $(printf "nixpkgs#%s " "$@"); }