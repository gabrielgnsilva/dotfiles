#!/usr/bin/env sh

lock() {
  swaylock -f -c 000000
}

exitWM() {
  niri msg action quit
}

restartWM() {
  niri msg action load-config-file && sleep 0.2
  "${XDG_CONFIG_HOME}"/BLAST/scripts/wallpaper.sh --restore --fallback default
  "${XDG_CONFIG_HOME}"/BLAST/scripts/taskbar.sh --reload-config
  "${XDG_CONFIG_HOME}"/BLAST/scripts/volume.sh 45 --silent
  "${XDG_CONFIG_HOME}"/BLAST/scripts/notification.sh --reload
}

main() {
  chosen=$(
    printf "󰐦  Power Off\n󰜉  Reboot\n󰍁  Lock\n󰒲  Suspend\n󰗽  Exit WM\n󱂬  Restart WM\n" \
      | rofi -dmenu -i -mesg "Power Menu" -theme-str '@import "exit-menu.rasi"'
  )

  case "${chosen}" in
    "󰐦  Power Off") shutdown --poweroff now ;;
    "󰜉  Reboot") shutdown --reboot now ;;
    "󰍁  Lock") lock ;;
    "󰒲  Suspend") systemctl suspend ;;
    "󰗽  Exit WM") exitWM ;;
    "󱂬  Restart WM") restartWM ;;
    *) exit 1 ;;
  esac
}

pkill rofi || main

unset -f main exitWM restartWM
