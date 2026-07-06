#!/usr/bin/env sh

open_term() {
  exec ghostty --title="Terminal" "${@}"
}

if [ "${1}" = "launch" ]; then
  shift
  program="${1}"
  shift
  open_term -e "${program}" "${1}"
elif [ "${1}" = "cwd" ]; then
  shift
  open_term --working-directory="${1}"
else
  open_term "${@}"
fi
