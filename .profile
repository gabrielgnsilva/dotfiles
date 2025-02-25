# shellcheck shell=bash disable=SC1091

# region: Path
export PATH="${PATH}":"${HOME}"/.local/bin
export PATH="${PATH}":/usr/local/lib/java/jdk1.8.0_202/bin/
export PATH="$PATH:$GEM_HOME/bin"
# regionend

# region: Environment variables
export GNUPGHOME="${XDG_DATA_HOME}"/gnupg
export GTK2_RC_FILES="${XDG_CONFIG_HOME}"/gtk-2.0/gtkrc-2.0
export INPUTRC="${XDG_CONFIG_HOME}"/readline/inputrc
export LESSHISTFILE="${XDG_CONFIG_HOME}"/less/lesshst
export QT_STYLE_OVERRIDE=kvantum
export WGETRC="${XDG_CONFIG_HOME}"/wget/wgetrc
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/nvim/init.lua" | source $MYVIMRC'
export GOPATH="${HOME}/.local/share/go"
export GOBIN="${GOPATH}/bin"
SUDO_PROMPT="$(tput setab 1 setaf 7 bold)[sudo]$(tput sgr0) $(tput setaf 6)password for$(tput sgr0) $(tput setaf 5)%p$(tput sgr0): "
export SUDO_PROMPT
export ROC_ENABLE_PRE_VEGA=1
export NVM_DIR="$HOME/.config/nvm"
# regionend

# #region: Load NVM
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# #regionend

# region: BASHRC
source "${XDG_CONFIG_HOME}"/bash/bashrc
# regionend

# region: SESSION
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
            export HYPRCURSOR_SIZE=24
            export HYPRCURSOR_THEME=theme_CapitaineCursors-Light
            export HYPRLAND_TRACE=1
            export AQ_TRACE=1

            # Fix gtk settings.ini not appling when using Hyprland
            config="${XDG_CONFIG_HOME}/gtk-3.0/settings.ini"
            if [[ -f "${config}" ]]; then
                gsettings set "org.gnome.desktop.interface" gtk-theme "$(grep 'gtk-theme-name' "${config}" | sed 's/.*\s*=\s*//')"
                gsettings set "org.gnome.desktop.interface" icon-theme "$(grep 'gtk-icon-theme-name' "${config}" | sed 's/.*\s*=\s*//')"
                gsettings set "org.gnome.desktop.interface" cursor-theme "$(grep 'gtk-cursor-theme-name' "${config}" | sed 's/.*\s*=\s*//')"
                gsettings set "org.gnome.desktop.interface" font-name "$(grep 'gtk-font-name' "${config}" | sed 's/.*\s*=\s*//')"
                gsettings set "org.gnome.desktop.interface" cursor-size "$(grep 'gtk-cursor-theme-size' "${config}" | sed 's/.*\s*=\s*//')"
                gsettings set "org.gnome.desktop.interface" toolbar-style "$(grep 'gtk-toolbar-style' "${config}" | sed 's/.*\s*=\s*//')"
                gsettings set "org.gnome.desktop.interface" toolbar-icons-size "$(grep 'gtk-toolbar-icon-size' "${config}" | sed 's/.*\s*=\s*//')"
                # gsettings set "org.gnome.desktop.interface" icon-sizes "$(grep 'gtk-icon-sizes ' "${config}" | sed 's/.*\s*=\s*//')"
                # gsettings set "org.gnome.desktop.interface" menu-images "$(grep 'gtk-menu-images' "${config}" | sed 's/.*\s*=\s*//')"
                # gsettings set "org.gnome.desktop.interface" menu-popup-delay "$(grep 'gtk-menu-popup-delay ' "${config}" | sed 's/.*\s*=\s*//')"
                # gsettings set "org.gnome.desktop.interface" button-images "$(grep 'gtk-button-images' "${config}" | sed 's/.*\s*=\s*//')"
                # gsettings set "org.gnome.desktop.interface" enable-event-sounds "$(grep 'gtk-enable-event-sounds' "${config}" | sed 's/.*\s*=\s*//')"
                # gsettings set "org.gnome.desktop.interface" enable-input-feedback-sounds "$(grep 'gtk-enable-input-feedback-sounds' "${config}" | sed 's/.*\s*=\s*//')"
                gsettings set "org.gnome.desktop.interface" font-antialiasing "$(grep 'gtk-xft-antialias' "${config}" | sed 's/.*\s*=\s*//')"
                gsettings set "org.gnome.desktop.interface" font-hinting "$(grep 'gtk-xft-hinting' "${config}" | sed 's/.*\s*=\s*//')"
                gsettings set "org.gnome.desktop.interface" font-rgba-order "$(grep 'gtk-xft-rgba' "${config}" | sed 's/.*\s*=\s*//')"
                # gsettings set "org.gnome.desktop.interface" application-prefer-dark-theme "$(grep 'gtk-application-prefer-dark-theme' "${config}" | sed 's/.*\s*=\s*//')"
                # gsettings set "org.gnome.desktop.interface" decoration-layout "$(grep 'gtk-decoration-layout' "${config}" | sed 's/.*\s*=\s*//')"
            fi

            Hyprland
            ;;
        *)
            printf "\nSession '%s' not found!" "${de}"
            ;;
    esac
fi
# regionend

# region: Angular CLI
if command -v ng &> /dev/null; then
    source <(ng completion script)
fi
# regionend

unset -v de gnome_schema config gtk_theme icon_theme cursor_theme font_name
