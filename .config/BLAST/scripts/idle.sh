#!/usr/bin/env sh

enable_idle() {
    if pgrep -x swayidle > /dev/null 2>&1; then
        exit 0
    fi

    exec swayidle -w \
        timeout 1800 'swaylock -f -c 000000' \
        timeout 1805 'niri msg action power-off-monitors' resume 'niri msg action power-on-monitors' \
        before-sleep '$XDG_CONFIG_HOME/BLAST/scripts/volume.sh --toggle-mute; swaylock -f -c 000000'
}

disable_idle() {
    pkill -e swayidle
}

toggle_idle() {
    if pgrep -x swayidle > /dev/null 2>&1; then
        disable_idle > /dev/null 2>&1
    else
        setsid -f "$0" --enable > /dev/null 2>&1
    fi
}

status_idle() {
    if pgrep -x swayidle > /dev/null 2>&1; then
        printf '{"text":"IDLE","class":"deactivated","tooltip":"Currently allowing idle"}\n'
    else
        printf '{"text":"AWAKE","class":"activated","tooltip":"Currently blocking idle"}\n'
    fi
}

main() {
    case "${1}" in
        --enable | -e)
            enable_idle
            ;;
        --disable | -d)
            disable_idle
            ;;
        --toggle | -t)
            toggle_idle
            ;;
        --status | -s)
            status_idle
            ;;
        *)
            echo "Usage: ${0} [--enable|-e] | [--disable|-d] | [--toggle|-t] | [--status|-s]"
            exit 1
            ;;
    esac
}

main "$@"
