#!/usr/bin/env sh
# Change the volume for the current audio session (PipeWire)

main() {
  if [ "${#}" -lt 1 ] && [ "${#}" -gt 1 ]; then
    exit 1
  fi
  if ! printf "%s" "${1}" | grep -qE '^[+-][0-9]+$|^--toggle-mute$'; then
    printf "The input does not match the required pattern (either + or - followed by numbers; or toggle-mute).\n"
    exit 1
  fi

  volume="${1}"
  shift

  if [ "${volume}" = '--toggle-mute' ]; then
    pulsemixer --toggle-mute
    exit 0
  fi

  if printf "%s" "${volume}" | grep -qE '^[+][0-9]+$'; then
    pamixer --increase "${volume#+}"
  fi
  if printf "%s" "${volume}" | grep -qE '^[-][0-9]+$'; then
    pamixer --decrease "${volume#-}"
  fi
  currentvol="$(printf "%s" "$(pamixer --get-volume)")"
  mute="$(printf "%s" "$(pamixer --get-mute)")"
  if [ "${mute}" = "true" ]; then
    # Show the sound muted notification
    notify-send -a "Volume-App" -u low -t 1000 -i audio-volume-muted \
      -h int:value:"${currentvol}" "Volume Muted !"
  else
    # Show the volume notification
    notify-send -a "Volume-App" -u low -t 1000 -i audio-volume-high \
      -h int:value:"${currentvol}" "Volume: ${currentvol}%"
  fi
}

isAlreadyRunning() {
  binName=$(basename "${0}")
  lockFile="${XDG_CACHE_HOME:-${HOME}/.cache}/${binName}.lock"
  exec 9> "${lockFile}"
  if flock -n 9; then
    return 1
  fi
  return 0
}

# Invoke main with args only if not sourced
if ! (return 0 2> /dev/null); then
  if isAlreadyRunning; then
    exit 1
  fi
  main "${@}"
  flock -u 9
fi

unset -f main isAlreadyRunning
