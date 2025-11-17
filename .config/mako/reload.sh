#!/usr/bin/env sh

makoctl reload

# to test a 'high' urgency notification add '-u critical '
notify-send --app-name "MESSAGE TEST" "Title" "Normal Message" -u normal
notify-send --app-name "MESSAGE TEST" "Title" "Low Message" -u low
notify-send --app-name "MESSAGE TEST" "Title" "Critical Message" -u critical
