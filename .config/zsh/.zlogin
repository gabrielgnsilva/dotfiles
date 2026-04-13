#!/usr/bin/env zsh

# region: SESSION
[ "$(tty)" = "/dev/tty1" ] && ! pgrep niri > /dev/null && {
  # environment variables
  export XDG_CURRENT_DESKTOP=niri
  export XDG_SESSION_DESKTOP=niri
  export XDG_SESSION_TYPE=wayland

  export XCURSOR_PATH="${HOME}"/.local/share/icons:/usr/share/icons
  export XCURSOR_THEME="breeze_cursors"
  export XCURSOR_SIZE=24

  # Consistent theme between QT and GTK apps
  export QT_QPA_PLATFORM=wayland
  export QT_QPA_PLATFORMTHEME=qt5ct
  export QT_AUTO_SCREEN_SCALE_FACTOR=1
  export GTK_THEME=Breeze-Dark

  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  gsettings set org.gnome.desktop.interface cursor-size "${XCURSOR_SIZE}"
  gsettings set org.gnome.desktop.interface cursor-theme "${XCURSOR_THEME}"
  gsettings set org.gnome.desktop.interface document-font-name 'CaskaydiaCove Nerd Font 10'
  gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'
  gsettings set org.gnome.desktop.interface font-hinting 'full'
  gsettings set org.gnome.desktop.interface font-name 'CaskaydiaCove Nerd Font 10'
  gsettings set org.gnome.desktop.interface gtk-theme 'Breeze-Dark'
  gsettings set org.gnome.desktop.interface icon-theme 'breeze-dark'
  gsettings set org.gnome.desktop.interface monospace-font-name 'CaskaydiaCove Nerd Font Mono 9'

  # start wm
  niri-session -l
}
# regionend
