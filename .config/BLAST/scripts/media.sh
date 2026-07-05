#!/usr/bin/env sh

main() {
    case "${1}" in
        "open")
            xdg-open "https://music.youtube.com"
            ;;
        "play-pause")
            playerctl play-pause
            ;;
        "stop")
            playerctl stop
            ;;
        "next")
            playerctl next
            ;;
        "previous")
            playerctl previous
            ;;
        "forward")
            playerctl position 5+
            ;;
        "rewind")
            playerctl position 5-
            ;;
        *)
            echo "Usage: ${0} {open|play-pause|stop|next|previous}"
            exit 1
            ;;
    esac
}

# invoke main with args only if not sourced
if ! (return 0 2> /dev/null); then
    main "${@}"
fi
