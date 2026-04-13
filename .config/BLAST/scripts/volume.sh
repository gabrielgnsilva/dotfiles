#!/usr/bin/env sh

# change the volume for the current audio session (pipewire)

main() {
    if [ "${#}" -lt 1 ] || [ "${#}" -gt 2 ]; then
        printf "Usage: %s [--silent] {+N|-N|0-100|--toggle-mute}\n" "$(basename "${0}")" >&2
        exit 1
    fi

    silent=0
    action=""

    for arg in "${@}"; do
        case "${arg}" in
            --silent)
                silent=1
                ;;
            *)
                if [ -n "${action}" ]; then
                    printf "Too many arguments.\n" >&2
                    printf "Usage: %s [--silent] {+N|-N|0-100|--toggle-mute}\n" "$(basename "${0}")" >&2
                    exit 1
                fi
                action="${arg}"
                ;;
        esac
    done

    if [ -z "${action}" ]; then
        printf "Missing volume action.\n" >&2
        printf "Usage: %s [--silent] {+N|-N|0-100|--toggle-mute}\n" "$(basename "${0}")" >&2
        exit 1
    fi

    case "${action}" in
        --toggle-mute)
            pulsemixer --toggle-mute
            exit 0
            ;;
        +*)
            value="${action#+}"
            case "${value}" in
                ''|*[!0-9]*)
                    printf "Invalid volume increment: %s\n" "${action}" >&2
                    exit 1
                    ;;
            esac
            pamixer --increase "${value}"
            ;;
        -*)
            value="${action#-}"
            case "${value}" in
                ''|*[!0-9]*)
                    printf "Invalid volume decrement: %s\n" "${action}" >&2
                    exit 1
                    ;;
            esac
            pamixer --decrease "${value}"
            ;;
        *)
            case "${action}" in
                ''|*[!0-9]*)
                    printf "Invalid argument: %s\n" "${action}" >&2
                    printf "Expected {+N|-N|0-100|--toggle-mute}.\n" >&2
                    exit 1
                    ;;
            esac

            if [ "${action}" -lt 0 ] || [ "${action}" -gt 100 ]; then
                printf "Volume must be between 0 and 100 (got %s).\n" "${action}" >&2
                exit 1
            fi

            pamixer --set-volume "${action}"
            ;;
    esac

    if [ "${silent}" -eq 1 ]; then
        exit 0
    fi

    currentvol="$(pamixer --get-volume)"
    mute="$(pamixer --get-mute)"
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

# invoke main with args only if not sourced
if ! (return 0 2> /dev/null); then
    if isAlreadyRunning; then
        exit 1
    fi
    main "${@}"
    flock -u 9
fi

unset -f main isAlreadyRunning
