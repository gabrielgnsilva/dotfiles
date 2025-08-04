#!/usr/bin/env sh

monitor() {
  dbus-monitor path='/org/freedesktop/Notifications',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged' --profile \
    | while read -r _; do
      PAUSED="$(dunstctl is-paused)"
      ICON='disabled'
      TEXT=''

      if [ "${PAUSED}" = 'false' ]; then
        ICON="enabled"
      else
        ICON="disabled"
        COUNT="$(dunstctl count waiting)"
        if [ "${COUNT}" != '0' ]; then
          TEXT=" ${COUNT}"
        fi
      fi
      printf '{"alt": "%s", "text": "%s"}\n' "${ICON}" "${TEXT}"
    done
}

main() {
  set -euo
  fail="$(mktemp)"
  if { monitor || echo > "${fail}"; } && [ ! -s "${fail}" ]; then
    echo ""
  fi
  rm "${fail}"
}

main

unset -f main monitor
