#!/usr/bin/env sh

if pgrep -a lxqt-policykit-agent > /dev/null; then
  exit 0
fi

exec lxqt-policykit-agent
