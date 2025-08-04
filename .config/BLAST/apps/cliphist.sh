#!/usr/bin/env sh

main() {
  case "${1}" in
    "delete") cliphist list | rofi -dmenu -i -theme-str '@import "list-view.rasi"' | cliphist delete ;;
    "wipe")
      chosen="$(printf "Clear\nCancel" | rofi -dmenu -i -mesg "Clear clip history?" -theme-str '@import "list-select.rasi"')"
      [ "${chosen}" = "Clear" ] && cliphist wipe
      ;;
    *)
      cliphist list | rofi -dmenu -i -theme-str '@import "list-view.rasi"' | cliphist decode | wl-copy
      ;;
  esac
}

pkill rofi || main "$@"

unset -f main
