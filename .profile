# shellcheck shell=bash disable=SC1091

# ENVIRONMENT VARIABLES
export VIMINIT='let $MYVIMRC="$HOME/AppData/Local/nvim/init.lua" | source $MYVIMRC'

# PATH
export PATH="${PATH}":"${HOME}"/AppData/Local/git-bash/.local/bin

# BASHRC
source "${HOME}"/AppData/Local/git-bash/bashrc
