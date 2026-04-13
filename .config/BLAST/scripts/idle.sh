#!/usr/bin/env sh

enable_idle() {
    swayidle -w \
        timeout 1800 'swaylock -f -c 000000' \
        timeout 1805 'niri msg action power-off-monitors' resume 'niri msg action power-on-monitors' \
        before-sleep '$XDG_CONFIG_HOME/BLAST/scripts/volume.sh --toggle-mute; swaylock -f -c 000000'
}

disable_idle() {
    pkill -e swayidle
}

main() {
    case "${1}" in
        --enable | -e)
            enable_idle
            ;;
        --disable | -d)
            disable_idle
            ;;
        *)
            echo "Usage: ${0} [--enable|-e] | [--disable|-d]"
            exit 1
            ;;
    esac
}

main "$@"
