#!/usr/bin/env zsh

# ==============================================================================
# ZSHENV
# ------------------------------------------------------------------------------
# This script is executed on every zsh invocation.
#
# Keep this file minimal: it only bootstraps $XDG_CONFIG_HOME so zsh can locate
# ZDOTDIR and the shared shell environment file.
# ==============================================================================

# Bootstrap XDG_CONFIG_HOME so zsh can find the rest of the config.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"

# Move zsh startup files under $XDG_CONFIG_HOME when that directory exists.
[ -d "${XDG_CONFIG_HOME}/zsh" ] && export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# Load the shared shell environment. This defines the full XDG base directory set
# and other shell-agnostic environment variables.
[ -r "${XDG_CONFIG_HOME}/shell/env" ] && . "${XDG_CONFIG_HOME}/shell/env"
