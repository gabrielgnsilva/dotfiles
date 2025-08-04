#!/usr/bin/env sh

# Timers
_timer1="0.1"
_timer2="0.5"
_timer3="2"

# End all possible running xdg-desktop-portals
killall -e xdg-desktop-portal-hyprland
killall -e xdg-desktop-portal-gnome
killall -e xdg-desktop-portal-kde
killall -e xdg-desktop-portal-lxqt
killall -e xdg-desktop-portal-wlr
killall -e xdg-desktop-portal-gtk
killall -e xdg-desktop-portal

# Required environment variables
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=hyprland
systemctl --user import-environment QT_QPA_PLATFORMTHEME

# Stop all services
systemctl --user stop pipewire
systemctl --user stop wireplumber
systemctl --user stop xdg-desktop-portal
systemctl --user stop xdg-desktop-portal-gnome
systemctl --user stop xdg-desktop-portal-kde
systemctl --user stop xdg-desktop-portal-wlr
systemctl --user stop xdg-desktop-portal-hyprland
sleep "${_timer1}"

# Start xdg-desktop-portal-hyprland
/usr/lib/xdg-desktop-portal-hyprland &
sleep "${_timer1}"

# Start xdg-desktop-portal-gtk
if [ -f /usr/lib/xdg-desktop-portal-gtk ]; then
  /usr/lib/xdg-desktop-portal-gtk &
  sleep "${_timer1}"
fi

# Start xdg-desktop-portal
/usr/lib/xdg-desktop-portal &
sleep "${_timer2}"

# Start required services
systemctl --user start pipewire
systemctl --user start wireplumber
systemctl --user start xdg-desktop-portal
systemctl --user start xdg-desktop-portal-hyprland
