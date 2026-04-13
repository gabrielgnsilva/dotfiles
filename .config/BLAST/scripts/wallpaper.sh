#!/usr/bin/env sh

BLAST_CACHE_DIR="${XDG_CACHE_HOME}"/BLAST
LAST_WALLPAPER="${BLAST_CACHE_DIR}"/wallpaper

load_wallpaper() {
  swaybg \
    --output DP-1 --image "$1" --mode fill \
    --output DP-2 --image "$1" --mode fill
  printf '%s' "${1}" | tee "${LAST_WALLPAPER}"
}

main() {
  [ ! -d "${BLAST_CACHE_DIR}" ] && mkdir "${BLAST_CACHE_DIR}" -p
  [ ! -f "${LAST_WALLPAPER}" ] && touch "${LAST_WALLPAPER}"

  if [ "${1}" = '--default' ]; then
    DEFAULT="${XDG_CONFIG_HOME}/BLAST/wallpaper.png"
    load_wallpaper "${DEFAULT}"
    exit 0
  fi

  if [ "${1}" = '--cycle' ]; then
    WALLPAPER_DIR="${HOME}/Pictures/Wallpapers/"
    WALLPAPER=$(find "${WALLPAPER_DIR}" -type f | shuf -n 1)
    load_wallpaper "${WALLPAPER}"
    exit 0
  fi

  if [ "${1}" = '--restore' ]; then
    WALLPAPER=$(cat "${LAST_WALLPAPER}")
    FALLBACK=default
    shift

    if [ "${1}" = '--fallback' ]; then
      shift
      FALLBACK=${1}
    fi

    if [ ! -f "${WALLPAPER}" ]; then
      main "--${FALLBACK}"
    else
      load_wallpaper "${WALLPAPER}"
    fi
    exit 0
  fi
}

main "${@}"
