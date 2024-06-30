#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use
# polybar-msg cmd quit
# Otherwise you can use the nuclear option:
killall -q polybar

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybartop.log /tmp/polybarbottom.log
polybar laptop 2>&1 | tee -a /tmp/polybar_laptop.log &
disown
polybar external 2>&1 | tee -a /tmp/polybar_external.log &
disown

echo "Bars launched..."
