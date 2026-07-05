#!/usr/bin/env zsh

# ==============================================================================
# ZSHRC
# ------------------------------------------------------------------------------
# This script is executed whenever an interactive shell starts.
# ==============================================================================

# Source the main shell file if it exists and is readable.
rc_file="${XDG_CONFIG_HOME}/shell/rc"
if [ -f "${rc_file}" ] && [ -r "${rc_file}" ]; then
  source "${rc_file}"
fi
unset -v rc_file

# == HISTORY ===================================================================
SAVEHIST=100000

# == DIRECTORIES ===============================================================
[[ -d "${XDG_CACHE_HOME}/zsh" ]] || mkdir -p "${XDG_CACHE_HOME}/zsh"

# == SHELL OPTIONS =============================================================
[ -t 0 ] && stty stop undef   # Disable ctrl-s to freeze terminal.
setopt autocd                 # Automatically cd into typed directory.
setopt interactive_comments   # Allow comments in interactive shells.
setopt nobeep                 # Disable terminal bell.
setopt noclobber              # Prevent overwrite of files.
setopt numeric_glob_sort      # Sort glob results numerically.
setopt append_history         # Append to history file, don't overwrite it.
setopt hist_expire_dups_first # Expire duplicate entries first when trimming history.
setopt hist_find_no_dups      # Don't display duplicate entries in history search.
setopt hist_ignore_dups       # Don't record duplicate entries.
setopt hist_ignore_space      # Don't record commands that start with a space.
setopt share_history          # Share history across all sessions.

# == PROMPT ====================================================================

# -- Colors --------------------------------------------------------------------
autoload -U colors && colors

# -- Git status ----------------------------------------------------------------
autoload -Uz add-zsh-hook
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git                # Enable Git backend for vcs_info
zstyle ':vcs_info:git:*' formats '%b'          # Show git branch with icon
zstyle ':vcs_info:git:*' actionformats '%b:%a' # Show git branch with icon and action (e.g., rebase, merge)

update_vcs_info() {
  vcs_info

  if [[ -n "$vcs_info_msg_0_" ]]; then
    git_prompt="%F{240}[%f%F{yellow}%Bgit:%f %F{red}${vcs_info_msg_0_}%f%b%F{240}]%f"$'\n'
  else
    git_prompt=""
  fi
}
add-zsh-hook precmd update_vcs_info

# -- Prompt --------------------------------------------------------------------
setopt prompt_subst

PROMPT='
${git_prompt}%B%F{cyan}//%f%F{240}_%f%b '

# == COMPLETION ================================================================
autoload -U compinit

zstyle ":completion:*" menu select
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh"
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion::complete:*' use-cache on

zmodload zsh/complist

compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}"

_comp_options+=(globdots)

# # Keep `git add <TAB>` responsive in the home dotfiles worktree. Zsh's default
# # _git completion asks `git ls-files --others` for untracked files; in $HOME that
# # can scan a huge tree when the current pathspec has no unstaged match.
# _git-add() {
#   _arguments -S -s \
#     '(-n --dry-run)'{-n,--dry-run}'[do not actually add files; only show what would be added]' \
#     '(-v --verbose)'{-v,--verbose}'[show files as they are added]' \
#     '(-f --force)'{-f,--force}'[allow adding otherwise ignored files]' \
#     '(-i --interactive)'{-i,--interactive}'[add contents interactively]' \
#     '(-p --patch)'{-p,--patch}'[select hunks interactively]' \
#     '(-A --all)'{-A,--all}'[add, modify, and remove index entries]' \
#     '(-u --update)'{-u,--update}'[update tracked files]' \
#     '(-N --intent-to-add)'{-N,--intent-to-add}'[record only that the path will be added later]' \
#     '--refresh[refresh stat information in the index]' \
#     '--ignore-errors[continue adding if some files cannot be added]' \
#     '--renormalize[renormalize EOL of tracked files]' \
#     '*:file:_files'
# }

# -- Angular -------------------------------------------------------------------
command -v ng > /dev/null 2>&1 && source <(ng completion script)

# -- Bun -----------------------------------------------------------------------
bun_comp="${HOME}/.bun/_bun"
[ -f "${bun_comp}" ] && [ -r "${bun_comp}" ] && source "${bun_comp}"
unset -v bun_comp

# == KEYBINDINGS ===============================================================

# -- Vi mode -------------------------------------------------------------------
bindkey -v
export KEYTIMEOUT=1

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# -- Cursor shape --------------------------------------------------------------
zle-keymap-select() {
  case "${KEYMAP}" in
    vicmd) echo -ne '\e[1 q' ;;
    viins | main) echo -ne '\e[5 q' ;;
  esac
}

zle-line-init() {
  zle -K viins
  echo -ne "\e[5 q"
}

zle -N zle-keymap-select
zle -N zle-line-init

[ -t 1 ] && printf '\033[5 q'

reset_cursor_shape() {
  echo -ne '\e[5 q'
}
add-zsh-hook preexec reset_cursor_shape

# -- Edit command line -=-------------------------------------------------------
autoload edit-command-line

zle -N edit-command-line

bindkey '^e' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete

# == PLUGINS ===================================================================

# -- Syntax highlighting -------------------------------------------------------
syntax_highlighting_file=/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f "${syntax_highlighting_file}" ] && [ -r "${syntax_highlighting_file}" ] \
  && source "${syntax_highlighting_file}"
unset -v syntax_highlighting_file

custom_syntax_highlighting_file="${ZDOTDIR:-${XDG_CONFIG_HOME}/zsh}/config.d/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[ -f "${custom_syntax_highlighting_file}" ] && [ -r "${custom_syntax_highlighting_file}" ] \
  && source "${custom_syntax_highlighting_file}"
unset -v custom_syntax_highlighting_file

# -- Autosuggestions -----------------------------------------------------------
suggestions_file=/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f "${suggestions_file}" ] && [ -r "${suggestions_file}" ] \
  && source "${suggestions_file}"
unset -v suggestions_file
