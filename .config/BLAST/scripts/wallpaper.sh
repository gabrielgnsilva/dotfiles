#!/usr/bin/env sh

main() {
  if [ "${1}" = '--default' ]; then
    DEFAULT=$(
      grep -i preload "${XDG_CONFIG_HOME}"/hypr/hyprpaper.conf \
        | sed -e 's/^preload.*=[[:space:]]*//'
    )
    hyprctl hyprpaper reload ,"${DEFAULT}"
    exit 0
  fi

  if [ "${1}" = '--cycle' ]; then
    WALLPAPER_DIR="${HOME}/Pictures/Wallpapers/"
    CURRENT_WALL=$(hyprctl hyprpaper listloaded)
    WALLPAPER=$(find "${WALLPAPER_DIR}" -type f ! -name "$(basename "${CURRENT_WALL}")" | shuf -n 1)
    hyprctl hyprpaper reload ,"${WALLPAPER}"
    exit 0
  fi
}

main "${@}"
