#!/usr/bin/env sh

pkill rofi || rofi -modi drun,run -show drun -i -theme-str '@import "theme.rasi"'
