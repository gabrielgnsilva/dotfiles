#!/usr/bin/env sh

if [ "${1}" = "launch" ]; then
  shift
  program="${1}"
  shift
  wezterm start -- "${program}" "${1}"
elif [ "${1}" = "cwd" ]; then
  shift
  wezterm start --cwd "${1}"
else
  wezterm "${@}"
fi
