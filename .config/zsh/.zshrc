#!/usr/bin/env zsh

# My ZSH config

# region: Enable colors and change prompt
autoload -U colors && colors
autoload -Uz vcs_info
setopt prompt_subst
setopt noclobber # Prevent overwrite of files.
setopt autocd    # Automatically cd into typed directory.
stty stop undef  # Disable ctrl-s to freeze terminal.
setopt interactive_comments

zstyle ':vcs_info:git:*' formats '󰊢 %b' # Show git branch with icon
zstyle ':vcs_info:*' enable git         # Enable Git backend for vcs_info

function precmd() {
  vcs_info
}
PS1='%F{yellow}%B${vcs_info_msg_0_}%b%f
${debianChroot:+($debianChroot)}%F{white}%B>_%b%f '
# regionend

# region: Cache dir
[[ -d "${XDG_CACHE_HOME}"/zsh ]] || mkdir -p "${XDG_CACHE_HOME}"/zsh
# regionend

# region: History
HISTSIZE=10000000
SAVEHIST=10000000
export HISTFILE="${XDG_CACHE_HOME}/zsh/history"
setopt inc_append_history
# regionend

# region: Autocomplete
autoload -U compinit
zstyle ":completion:*" menu select
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh/zcompcache"
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion::complete:*' use-cache on
zmodload zsh/complist
compinit -d "${XDG_CACHE_HOME}"/zsh/zcompdump-"${ZSH_VERSION}"
_comp_options+=(globdots) # Include hidden files.

# Angular completion
[ $(command -v ng) ] && source <(ng completion script)
# regionend

# region: VI Mode
bindkey -v
export KEYTIMEOUT=1

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

function zle-keymap-select() {
  case $KEYMAP in
    vicmd) echo -ne '\e[1 q' ;;        # block
    viins | main) echo -ne '\e[5 q' ;; # beam
  esac
}
zle -N zle-keymap-select
zle-line-init() {
  zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
  echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q'                # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q'; } # Use beam shape cursor for each new prompt.

# Edit line in vim with ctrl-e:
autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete
# regionend

# Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME}/shell/aliases" ] && source "${XDG_CONFIG_HOME}/shell/aliases"
[ -f "${XDG_CONFIG_HOME}/shell/shortcuts" ] && source "${XDG_CONFIG_HOME}/shell/shortcuts"

# NVM
[ -s "${NVM_DIR}"/nvm.sh ] && source "${NVM_DIR}"/nvm.sh # This loads nvm

# MAKE LESS MORE FRIENDLY FOR NON-TEXT INPUT FILES, SEE LESSPIPE(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Fetch

# Load zsh-syntax-highlighting and zsh-autosuggestions; **should be last**.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
