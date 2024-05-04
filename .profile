# shellcheck shell=bash disable=SC1091

# XDG BASE DIRECTORY\N
export XDG_CONFIG_HOME="${HOME}"/.config
export XDG_CACHE_HOME="${HOME}"/.local/cache
export XDG_DATA_HOME="${HOME}"/.local/share
export XDG_STATE_HOME="${HOME}"/.local/state

# ENVIRONMENT VARIABLES
export EDITOR=nvim # Default Editor
export GNUPGHOME="${XDG_DATA_HOME}"/gnupg
export INPUTRC="${XDG_CONFIG_HOME}"/readline/inputrc
export LESSHISTFILE="${XDG_CONFIG_HOME}"/less/lesshst
export WGETRC="${XDG_CONFIG_HOME}"/wget/wgetrc
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/nvim/init.lua" | source $MYVIMRC'
export JAVA_HOME=/usr/local/lib/java/jdk1.8.0_202

# PATH
export PATH="${PATH}":"${HOME}"/.local/bin
export PATH="${PATH}":/opt/eclipse
export PATH=$PATH:$JAVA_HOME/bin

# BASHRC
source "${XDG_CONFIG_HOME}"/bash/bashrc

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
