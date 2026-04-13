#!/usr/bin/env sh

launch_taskbar() {
  waybar \
    -c "${XDG_CONFIG_HOME}"/waybar/config.d/minimal/config.jsonc \
    -s "${XDG_CONFIG_HOME}"/waybar/config.d/minimal/style.css
}

main() {
  if [ "${1}" = '--show' ]; then
    ! pgrep waybar > /dev/null && launch_taskbar
    exit 0
  fi

  if [ "${1}" = '--hide' ]; then
    killall waybar
    exit 0
  fi

  if [ "${1}" = '--toggle' ]; then
    killall -SIGUSR1 waybar
    exit 0
  fi

  if [ "${1}" = '--reload-config' ]; then
    killall waybar && sleep 0.2
    launch_taskbar
    exit 0
  fi
}

main "${@}"
