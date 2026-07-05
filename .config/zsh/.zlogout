#!/usr/bin/env zsh

# ==============================================================================
# ZLOGOUT
# ------------------------------------------------------------------------------
# This script is executed when a login shell exits.
# ==============================================================================

# Source the main shell file if it exists and is readable.
[ -r "${XDG_CONFIG_HOME}/shell/logout" ] && . "${XDG_CONFIG_HOME}/shell/logout"

# ZSH specific logout commands can be added here....
