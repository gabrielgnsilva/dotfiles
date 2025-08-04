#!/usr/bin/env sh

launch_taskbar() {
  waybar \
    -c "${XDG_CONFIG_HOME}"/waybar/config.jsonc \
    -s "${XDG_CONFIG_HOME}"/waybar/style.css
}

main() {
  if [ "${1}" = '--show' ]; then
    killall waybar
    launch_taskbar
    exit 0
  fi

  if [ "${1}" = '--hide' ]; then
    killall waybar
    exit 0
  fi

  if [ "${1}" = '--toggle' ]; then
    killall waybar || launch_taskbar
    exit 0
  fi

  if [ "${1}" = '--reload-config' ]; then
    killall waybar && sleep 0.2
    launch_taskbar
    exit 0
  fi
}

main "${@}"
