#!/usr/bin/env sh

set_mode() {
    makoctl mode -s "${1}"
}

get_mode() {
    makoctl mode
}

toggle_mode() {
    if [ "$(get_mode)" != 'do-not-disturb' ]; then
        set_mode "do-not-disturb"
    else
        set_mode "default"
    fi
}

dismiss_all() {
    makoctl dismiss -a
}

test() {
    notify-send --app-name "MESSAGE TEST" "Title" "Normal Message" -u normal
    notify-send --app-name "MESSAGE TEST" "Title" "Low Message" -u low
    notify-send --app-name "MESSAGE TEST" "Title" "Critical Message" -u critical
}

reload() {
    makoctl reload
}

main() {
    case "${1}" in
        --status) get_mode ;;
        --toggle) toggle_mode ;;
        --dismiss-all) dismiss_all ;;
        --reload) reload ;;
        --test) test ;;
        *) echo "Usage: ${0} [--status|--toggle|--dismiss-all|--reload|--test]" ;;
    esac
}

main "${@}"
