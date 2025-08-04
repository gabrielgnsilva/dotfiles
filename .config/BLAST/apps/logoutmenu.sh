#!/usr/bin/env sh

exitWM() {
  hyprctl dispatch exit
}

restartWM() {
  hyprctl reload && sleep 0.2
  hyprctl hyprpaper reload , "${XDG_CONFIG_HOME}"/BLAST/wallpaper.jpg && sleep 0.2
  "${XDG_CONFIG_HOME}"/BLAST/scripts/waybar.sh
}

main() {
  chosen=$(
    printf "󰐦  Power Off\n󰜉  Reboot\n󰍁  Lock\n󰒲  Suspend\n󰗽  Exit WM\n󱂬  Restart WM\n" \
      | rofi -dmenu -i -mesg "Power Menu" -theme-str '@import "exit-menu.rasi"'
  )

  case "${chosen}" in
    "󰐦  Power Off") poweroff ;;
    "󰜉  Reboot") reboot ;;
    "󰍁  Lock") slock ;;
    "󰒲  Suspend") systemctl suspend ;;
    "󰗽  Exit WM") exitWM ;;
    "󱂬  Restart WM") restartWM ;;
    *) exit 1 ;;
  esac
}

pkill rofi || main

unset -f main exitWM restartWM
