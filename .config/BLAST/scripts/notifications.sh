#!/usr/bin/env sh

main() {
  ICON='disabled'
  TEXT="<span strikethrough='true'>DND</span>"

  if [ "$(makoctl mode)" != 'do-not-disturb' ]; then
    TEXT="DND"
    ICON="enabled"
  fi

  printf '{"alt": "%s", "text": "%s"}\n' "${ICON}" "${TEXT}"
}

main

unset -f main
