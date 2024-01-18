# shellcheck shell=bash disable=SC1091

# PATH
export PATH="${PATH}":"${HOME}"/.local/bin

# ENVIRONMENT VARIABLES
export XDG_CONFIG_HOME="${HOME}"/.config
export INPUTRC="${XDG_CONFIG_HOME}"/readline/inputrc
export LESSHISTFILE="${XDG_CONFIG_HOME}"/less/lesshst
export WGETRC="${XDG_CONFIG_HOME}"/wget/wgetrc
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/nvim/init.lua" | source $MYVIMRC'

# BASHRC
source "${XDG_CONFIG_HOME}"/bash/bashrc
