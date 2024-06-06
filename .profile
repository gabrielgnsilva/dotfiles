# shellcheck shell=bash disable=SC1091

# PATH
export PATH="${PATH}":"${HOME}"/.local/bin
export PATH="${PATH}":/usr/local/lib/java/jdk1.8.0_202/bin/

# ENVIRONMENT VARIABLES
export GNUPGHOME="${XDG_DATA_HOME}"/gnupg
export GTK2_RC_FILES="${XDG_CONFIG_HOME}"/gtk-2.0/gtkrc-2.0
export INPUTRC="${XDG_CONFIG_HOME}"/readline/inputrc
export LESSHISTFILE="${XDG_CONFIG_HOME}"/less/lesshst
export QT_STYLE_OVERRIDE=kvantum
export WGETRC="${XDG_CONFIG_HOME}"/wget/wgetrc
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/nvim/init.lua" | source $MYVIMRC'

# BASHRC
source "${XDG_CONFIG_HOME}"/bash/bashrc

function setGSettings() {
    local gnome_schema="org.gnome.desktop.interface"

    gsettings set "${gnome_schema}" gtk-theme "$(grep 'gtk-theme-name' "${1}" | sed 's/.*\s*=\s*//')"
    gsettings set "${gnome_schema}" icon-theme "$(grep 'gtk-icon-theme-name' "${1}" | sed 's/.*\s*=\s*//')"
    gsettings set "${gnome_schema}" cursor-theme "$(grep 'gtk-cursor-theme-name' "${1}" | sed 's/.*\s*=\s*//')"
    gsettings set "${gnome_schema}" font-name "$(grep 'gtk-font-name' "${1}" | sed 's/.*\s*=\s*//')"

    gsettings set "${gnome_schema}" cursor-size "$(grep 'gtk-cursor-theme-size' "${1}" | sed 's/.*\s*=\s*//')"
    gsettings set "${gnome_schema}" toolbar-style "$(grep 'gtk-toolbar-style' "${1}" | sed 's/.*\s*=\s*//')"
    gsettings set "${gnome_schema}" toolbar-icons-size "$(grep 'gtk-toolbar-icon-size' "${1}" | sed 's/.*\s*=\s*//')"
    # gsettings set "${gnome_schema}" icon-sizes "$(grep 'gtk-icon-sizes ' "${1}" | sed 's/.*\s*=\s*//')"
    # gsettings set "${gnome_schema}" menu-images "$(grep 'gtk-menu-images' "${1}" | sed 's/.*\s*=\s*//')"
    # gsettings set "${gnome_schema}" menu-popup-delay "$(grep 'gtk-menu-popup-delay ' "${1}" | sed 's/.*\s*=\s*//')"
    # gsettings set "${gnome_schema}" button-images "$(grep 'gtk-button-images' "${1}" | sed 's/.*\s*=\s*//')"
    # gsettings set "${gnome_schema}" enable-event-sounds "$(grep 'gtk-enable-event-sounds' "${1}" | sed 's/.*\s*=\s*//')"
    # gsettings set "${gnome_schema}" enable-input-feedback-sounds "$(grep 'gtk-enable-input-feedback-sounds' "${1}" | sed 's/.*\s*=\s*//')"
    gsettings set "${gnome_schema}" font-antialiasing "$(grep 'gtk-xft-antialias' "${1}" | sed 's/.*\s*=\s*//')"
    gsettings set "${gnome_schema}" font-hinting "$(grep 'gtk-xft-hinting' "${1}" | sed 's/.*\s*=\s*//')"
    gsettings set "${gnome_schema}" font-rgba-order "$(grep 'gtk-xft-rgba' "${1}" | sed 's/.*\s*=\s*//')"
    # gsettings set "${gnome_schema}" application-prefer-dark-theme "$(grep 'gtk-application-prefer-dark-theme' "${1}" | sed 's/.*\s*=\s*//')"
    # gsettings set "${gnome_schema}" decoration-layout "$(grep 'gtk-decoration-layout' "${1}" | sed 's/.*\s*=\s*//')"
}

# SESSION
de="Hyprland" # Desktop Environment
if [[ "$(tty)" = "/dev/tty1" ]] && ! pgrep "${de}" > /dev/null; then
    case "${de,,}" in
        'qtile')
            export XAUTHORITY="${XDG_RUNTIME_DIR}"/Xauthority
            export XCOMPOSEFILE="${HOME}"/.XCompose
            export XINITRC="${XDG_CONFIG_HOME}"/X11/xinitrc
            export XDG_CURRENT_DESKTOP=Qtile
            export XDG_SESSION_DESKTOP=Qtile

            startx "${XINITRC}" "${de}" &> /dev/null
            ;;
        'hyprland')
            export XCOMPOSEFILE="${HOME}"/.XCompose
            export XDG_CURRENT_DESKTOP=Hyprland
            export XDG_SESSION_DESKTOP=Hyprland
            export XDG_SESSION_TYPE=wayland
            export QT_QPA_PLATFORM=wayland

            # Fix gtk settings.ini not appling when using Hyprland
            config="${XDG_CONFIG_HOME}/gtk-3.0/settings.ini"
            if [[ -f "${config}" ]]; then
                setGSettings "${config}"
            fi

            Hyprland
            ;;
        *)
            printf "\nSession '%s' not found!" "${de}"
            ;;
    esac
fi

unset -f setGSettings
unset -v de gnome_schema gtk_theme icon_theme cursor_theme font_name
