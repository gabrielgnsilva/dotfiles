#!/usr/bin/env sh

notify() {
    notify-send -a "Internet-Kill-Switch" -u low -t 1500 "$1" "$2"
}

require_nmcli() {
    if ! command -v nmcli > /dev/null 2>&1; then
        notify "Internet" "nmcli não encontrado"
        exit 1
    fi
}

status() {
    nmcli networking
}

off() {
    nmcli networking off
}

on() {
    nmcli networking on
}

toggle() {
    if [ "$(status)" = "enabled" ]; then
        off
    else
        on
    fi
}

main() {
    require_nmcli

    case "${1}" in
        --off) off ;;
        --on) on ;;
        --toggle) toggle ;;
        --status) status ;;
        *)
            printf "Usage: %s [--off|--on|--toggle|--status]\n" "$(basename "${0}")" >&2
            exit 1
            ;;
    esac
}

main "${@}"
