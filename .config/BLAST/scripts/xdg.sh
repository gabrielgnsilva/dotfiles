#!/usr/bin/env sh

# end all possible running xdg-desktop-portals
killall -e xdg-desktop-portal-gnome
killall -e xdg-desktop-portal-gtk
killall -e xdg-desktop-portal

sleep 0.1

# import all session environment variables
dbus-update-activation-environment --systemd --all
systemctl --user import-environment QT_QPA_PLATFORMTHEME

sleep 0.5

# stop all services
systemctl --user stop pipewire
systemctl --user stop wireplumber
systemctl --user stop xdg-desktop-portal-gnome
systemctl --user stop xdg-desktop-portal-gtk
systemctl --user stop xdg-desktop-portal

sleep 2

# start required services
systemctl --user start pipewire
systemctl --user start wireplumber
systemctl --user start xdg-desktop-portal
systemctl --user start xdg-desktop-portal-gtk
systemctl --user start xdg-desktop-portal-gnome

sleep 5
