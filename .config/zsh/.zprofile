#!/usr/bin/env zsh

# ==============================================================================
# ZPROFILE
# ------------------------------------------------------------------------------
# This script is executed once when a login shell/session starts.
# ==============================================================================

# Source the main shell file if it exists and is readable.
[ -r "${XDG_CONFIG_HOME}/shell/profile" ] && . "${XDG_CONFIG_HOME}/shell/profile"

# ZSH specific profile commands can be added here....
