#!/usr/bin/env zsh

# ==============================================================================
# ZLOGIN
# ------------------------------------------------------------------------------
# This script is executed after profile and rc, only for login shells.
# ==============================================================================

# Source the main shell file if it exists and is readable.
[ -r "${XDG_CONFIG_HOME}/shell/login" ] && . "${XDG_CONFIG_HOME}/shell/login"

# ZSH specific login commands can be added here....
