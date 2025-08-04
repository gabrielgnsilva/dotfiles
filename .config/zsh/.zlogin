#!/usr/bin/env zsh

# region: SESSION
[ "$(tty)" = "/dev/tty1" ] && ! pgrep Hyprland > /dev/null && Hyprland
# regionend
