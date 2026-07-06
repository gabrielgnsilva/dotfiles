#!/usr/bin/env sh

BLAST_CACHE_DIR="${XDG_CACHE_HOME}"/BLAST

[ ! -d "${BLAST_CACHE_DIR}" ] && mkdir -p "${BLAST_CACHE_DIR}"
[ ! -d "${BLAST_CACHE_DIR}/netbird" ] && mkdir -p "${BLAST_CACHE_DIR}/netbird"
[ ! -f "${BLAST_CACHE_DIR}/netbird/saved" ] && touch "${BLAST_CACHE_DIR}/netbird/saved"
[ ! -f "${BLAST_CACHE_DIR}/netbird/latest" ] && touch "${BLAST_CACHE_DIR}/netbird/latest"

tmp="${BLAST_CACHE_DIR}/netbird"

_notify() {
  notify-send --app-name "Netbird" --urgency normal --expire-time 5000 --icon=network-vpn "${1}"
}

_cmd() {
  netbird "${@}"
}

_prefix_protocol() {
  url="${1}"
  if ! printf '%s\n' "${url}" | grep -E '^(https?://)' > /dev/null; then
    url="https://${url}"
  fi
  printf '%s' "${url}"
}

save_as_latest() {
  printf '%s' "$(_prefix_protocol "${1}")" > "${tmp}/latest"
}

save_to_list() {
  printf '%s\n' "$(_prefix_protocol "${1}")" >> "${tmp}/saved"
}

prompt_for_url() {
  management_url=$(
    rofi -dmenu -i \
      -mesg "Enter the management URL:" \
      -theme-str '@import "prompt.rasi"'
  )
  if [ -z "${management_url}" ]; then
    printf "No management URL provided.\n"
    exit 1
  fi

  management_url=$(_prefix_protocol "${management_url}")
  if ! printf '%s\n' "$(cat "${tmp}"/saved)" | grep -Fxq "${management_url}"; then
    save_to_list "${management_url}"
  fi
  save_as_latest "${management_url}"
}

prompt_to_select_from_saved() {
  management_url=$(
    printf '%s\n' "$(cat "${tmp}/saved")" \
      | rofi -dmenu -i \
        -mesg "Select Management URL:" \
        -theme-str '@import "list-select"'
  )
  if [ -z "${management_url}" ]; then
    printf "No management URL selected.\n"
    exit 1
  fi
  printf '%s' "${management_url}" > "${tmp}/latest"
}

toggle() {
  if _cmd status | grep -q "Management: Connected"; then
    disconnect
  else
    connect
  fi
}

connect() {
  management_url=$(cat "${tmp}/latest")
  if [ -z "${management_url}" ]; then
    printf "No management URL found.\n"
    exit 1
  fi

  _cmd up --management-url "${management_url}" || {
    printf "Failed to connect to VPN\n"
    exit 1
  }

  _notify "Connected to VPN"
}

disconnect() {
  _cmd down || {
    printf "Failed to disconnect from VPN\n"
    exit 1
  }

  _notify "Disconnected from VPN"
}

waybar_status() {
  TEXT="<span strikethrough='true'>VPN</span>"
  ICON="OFF"

  if _cmd status | grep -q "Management: Connected"; then
    TEXT="VPN"
    ICON="ON"
  fi

  printf '{"alt": "%s", "text": "%s"}\n' "${ICON}" "${TEXT}"
}

waybar_choose_action() {
  action=$(
    printf "Connect\nDisconnect\nChoose from saved\nConnect new" \
      | rofi \
        -dmenu -i \
        -mesg "Select an action:" \
        -theme-str '@import "list-select"'
  )
  case "${action}" in
    Connect) connect ;;
    Disconnect) disconnect ;;
    "Choose from saved") prompt_to_select_from_saved && connect ;;
    "Connect new") prompt_for_url && connect ;;
    *) printf "No valid action selected.\n" ;;
  esac
}

case "${1}" in
  --status) waybar_status ;;
  --choose) waybar_choose_action ;;
  --restore) connect ;;
  --toggle) toggle ;;
  --connect)
    prompt_to_select_from_saved
    connect
    ;;
  --connect-new)
    prompt_for_url
    connect
    ;;
  --disconnect) disconnect ;;
  *) printf "Usage: %s [--restore | --connect | --disconnect | --connect-new]" "${0}" ;;
esac
