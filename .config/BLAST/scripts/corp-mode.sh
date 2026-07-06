#!/usr/bin/env sh

WORK_DIR="${CORP_WORK_DIR:-${HOME}/work}"
WALLPAPER_SCRIPT="${XDG_CONFIG_HOME:-${HOME}/.config}/BLAST/scripts/wallpaper.sh"

company_wallpaper() {
  COMPANY_DIR="${WORK_DIR}/${1}"

  [ -f "${COMPANY_DIR}/_wallpaper.png" ] && printf '%s\n' "${COMPANY_DIR}/_wallpaper.png" && return 0
  [ -f "${COMPANY_DIR}/_wallpaper.jpg" ] && printf '%s\n' "${COMPANY_DIR}/_wallpaper.jpg" && return 0

  return 1
}

list_companies() {
  [ ! -d "${WORK_DIR}" ] && return 0

  for COMPANY_DIR in "${WORK_DIR}/*"; do
    [ -d "${COMPANY_DIR}" ] || continue
    COMPANY="${COMPANY_DIR##*/}"
    company_wallpaper "${COMPANY}" > /dev/null && printf '%s\n' "${COMPANY}"
  done
}

select_company() {
  COMPANIES="$(list_companies)"

  if [ -z "${COMPANIES}" ]; then
    notify-send --app-name 'Corp Mode' 'No corp wallpapers found' \
      "Add _wallpaper.png or _wallpaper.jpg to a folder under ${WORK_DIR}." 2> /dev/null || true
    exit 1
  fi

  printf '%s\n' "${COMPANIES}" \
    | rofi -dmenu -i -no-custom -p 'Corp mode' -mesg 'Select company' -theme-str '@import "list-select.rasi"'
}

main() {
  COMPANY="$(select_company)"
  [ -z "${COMPANY}" ] && exit 0

  if ! WALLPAPER="$(company_wallpaper "${COMPANY}")"; then
    printf 'Corp wallpaper not found for company: %s\n' "${COMPANY}" >&2
    exit 1
  fi

  "${WALLPAPER_SCRIPT}" --set "${WALLPAPER}"
}

main "${@}"
