#!/usr/bin/env sh

BLAST_CACHE_DIR="${XDG_CACHE_HOME}/BLAST"
LAST_WALLPAPER="${BLAST_CACHE_DIR}/wallpaper"

load_wallpaper() {
  printf '%s\n' "${1}" > "${LAST_WALLPAPER}"
  pkill -x swaybg 2> /dev/null || true

  exec swaybg \
    --output DP-1 --image "$1" --mode fill \
    --output DP-2 --image "$1" --mode fill
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
    WALLPAPER_DIR="${HOME}/pictures/wallpapers/"
    WALLPAPER=$(find "${WALLPAPER_DIR}" -type f | shuf -n 1)
    load_wallpaper "${WALLPAPER}"
    exit 0
  fi

  if [ "${1}" = '--set' ]; then
    shift

    if [ ! -f "${1}" ]; then
      printf 'Wallpaper not found: %s\n' "${1}" >&2
      exit 1
    fi

    load_wallpaper "${1}"
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
