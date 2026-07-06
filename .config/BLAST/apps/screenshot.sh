#!/usr/bin/env sh

[ -f ~/.config/user-dirs.dirs ] && . "${HOME}/.config/user-dirs.dirs"
OUTPUT_DIR="${XDG_PICTURES_DIR:-${HOME}/pictures}/screenshots"

if [ ! -d "${OUTPUT_DIR}" ]; then
  notify-send "Screenshot directory does not exist: ${OUTPUT_DIR}" -u critical -t 3000
  exit 1
fi

draw_box() {
  pkill slurp || grim -g "$(slurp -d)" - \
    | satty --filename - \
      --output-filename "${OUTPUT_DIR}/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png" \
      --early-exit \
      --actions-on-enter save-to-clipboard \
      --save-after-copy \
      --copy-command 'wl-copy'
}

snap_screen() {
  grim -o "$(niri msg --json focused-output | jq -r .name)" - \
    | satty --filename - \
      --output-filename "${OUTPUT_DIR}/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png" \
      --early-exit \
      --actions-on-enter save-to-clipboard \
      --save-after-copy \
      --copy-command 'wl-copy'
}

main() {
  area="${1}" # -a|--area or -s|--screen

  case "${area}" in
    -a | --area)
      draw_box
      ;;
    -s | --screen)
      snap_screen
      ;;
    *)
      echo "Usage: $0 [-a|--area] | [-s|--screen]"
      exit 1
      ;;
  esac
}

main "$@"
