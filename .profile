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

# SESSION
de="Hyprland"  # Desktop Environment
if [[ "$(tty)" = "/dev/tty1" ]] && ! pgrep "${de}" > /dev/null; then
    case "${de,,}" in
        'qtile' )
        echo "qtile"
                export XAUTHORITY="${XDG_RUNTIME_DIR}"/Xauthority
                export XCOMPOSEFILE="${XDG_CONFIG_HOME}"/X11/xcompose
                export XINITRC="${XDG_CONFIG_HOME}"/X11/xinitrc

                startx "${XINITRC}" "${de}" &> /dev/null
                ;;
        'hyprland' )

                export XDG_CURRENT_DESKTOP=Hyprland
                export XDG_SESSION_DESKTOP=Hyprland
                export XDG_SESSION_TYPE=wayland
                export QT_QPA_PLATFORM=wayland

                # Fix gtk settings.ini not appling when using Hyprland
                config="${XDG_CONFIG_HOME}/gtk-3.0/settings.ini"
                if [[ -f "${config}" ]]; then
                    gnome_schema="org.gnome.desktop.interface"
                    gtk_theme="$(grep 'gtk-theme-name' "${config}" | sed 's/.*\s*=\s*//')"
                    icon_theme="$(grep 'gtk-icon-theme-name' "${config}" | sed 's/.*\s*=\s*//')"
                    cursor_theme="$(grep 'gtk-cursor-theme-name' "${config}" | sed 's/.*\s*=\s*//')"
                    font_name="$(grep 'gtk-font-name' "${config}" | sed 's/.*\s*=\s*//')"
                    gsettings set "${gnome_schema}" gtk-theme "${gtk_theme}"
                    gsettings set "${gnome_schema}" icon-theme "${icon_theme}"
                    gsettings set "${gnome_schema}" cursor-theme "${cursor_theme}"
                    gsettings set "${gnome_schema}" font-name "${font_name}"
                fi

                Hyprland
            ;;
        * )
            printf "\nSession '%s' not found!" "${de}"
        ;;
    esac
fi

unset -v de
