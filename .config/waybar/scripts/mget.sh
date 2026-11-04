#!/usr/bin/env bash
set -euo pipefail

select_mode() {
  printf '%s\n' 'Audio' 'Video' \
    | rofi -dmenu -i -p 'Download' -theme-str '@import "list-select"'
}

mode="$(select_mode 2>/dev/null || true)"

case "$mode" in
  Audio) mget_mode="--audio" ;;
  Video) mget_mode="--video" ;;
  *) exit 0 ;;
esac

url="$(rofi -dmenu -p 'URL' -theme-str '@import "prompt"' 2>/dev/null || true)"
[[ -n "$url" ]] || exit 0

if ! mget "$mget_mode" --notify-when-done "$url"; then
  notify-send --app-name "mGet" --urgency critical \
    "Download failed" "Could not download the provided URL."
  exit 1
fi
