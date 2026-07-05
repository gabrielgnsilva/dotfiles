#!/usr/bin/env sh

pkill rofi \
  || exec rofi -modi emoji -show emoji
