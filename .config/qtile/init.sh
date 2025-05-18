#!/usr/bin/env bash

# region: Environment variables
export XINITRC="${XDG_CONFIG_HOME}"/X11/xinitrc

export XAUTHORITY="${XDG_RUNTIME_DIR}"/Xauthority
export XCOMPOSEFILE="${XDG_CONFIG_HOME}"/X11/xcompose
export XCOMPOSECACHE="${XDG_CACHE_HOME}"/X11/xcompose

export XDG_CURRENT_DESKTOP=Qtile
export XDG_SESSION_DESKTOP=Qtile
export XDG_SESSION_TYPE=wayland

export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_AUTO_SCREEN_SCALE_FACTOR=1

# Cursor themes
export XCURSOR_PATH=${XCURSOR_PATH}:/usr/share/icons
export XCURSOR_PATH=${XCURSOR_PATH}:~/.local/share/icons
export XCURSOR_SIZE=24

# regionend

startx "${XINITRC}" qtile &> /dev/null
