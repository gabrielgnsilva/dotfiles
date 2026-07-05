#!/usr/bin/env sh

pkill rofi \
  || exec rofi -modi drun,run -show drun -i -theme-str '@import "theme.rasi"'
