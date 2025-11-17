#!/usr/bin/env sh

notification() {

  appName="Calendar"

  today=$(date '+%-d')

  month=$(cal "${1}" | head -n1)

  days=$(cal "${1}" | tail -n7)

  if [ "${1}" = "+0 months" ]; then
    # Apply sed command to modify the output
    days=$(echo "${days}" | sed --null-data "s|${today}|<span underline='single' underline_color='#ff5458'><b>${today}</b></span>|1")
  fi

  description="\n<i>       ~ calendar</i> 󰸗 "

  notify-send -a "${appName}" -u low "${month}" "${days}${description}"
}

userAction() {
  echo "${diff}" > "${scriptTempFile}"
  if [ "${diff}" -ge 0 ]; then
    notification "+${diff} months"
  else
    notification "$((-diff)) months ago"
  fi
}

scriptTempFile="/tmp/$(id -u)_CALENDAR_NOTIFICATION.MONTH"
touch "${scriptTempFile}"

diff=$(cat "${scriptTempFile}")

case "${1}" in
  "curr") diff=0 ;;
  "next") diff=$((diff + 1)) ;;
  "prev") diff=$((diff - 1)) ;;
  *) diff=0 ;;
esac

userAction
