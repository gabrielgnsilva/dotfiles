#!/usr/bin/env sh

TEXT="<span strikethrough='true'>DND</span>"
ICON="OFF"

if [ "$("${XDG_CONFIG_HOME}"/BLAST/scripts/notification.sh --status)" = 'do-not-disturb' ]; then
  TEXT="DND"
  ICON="ON"
fi

printf '{"alt": "%s", "text": "%s"}\n' "${ICON}" "${TEXT}"
