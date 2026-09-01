#!/bin/bash
# Tap the booted Simulator at a fraction of the *device screen* (not the window).
#
# Replaces the Quartz path in sim_tap.py, which needs pyobjc — not installed on
# this machine. Uses System Events instead, so it needs Accessibility permission
# for whatever runs it.
#
# Usage: sim_tap_osa.sh <fx> <fy>     # both 0..1, origin top-left of the screen
set -euo pipefail

FX="$1"; FY="$2"
TITLEBAR=28   # Simulator window chrome above the device screen, in points

# Activate first: System Events cannot see the device window while Simulator is
# in the background, and the query fails with -1719 instead of returning bounds.
osascript -e 'tell application "Simulator" to activate' -e 'delay 0.6' >/dev/null

read -r X Y W H <<<"$(osascript -e 'tell application "System Events" to tell process "Simulator" to get {position, size} of (first window whose subrole is "AXStandardWindow")' | tr -d ',' )"

GX=$(python3 -c "print(round($X + $FX * $W))")
GY=$(python3 -c "print(round($Y + $TITLEBAR + $FY * ($H - $TITLEBAR)))")

osascript -e "tell application \"Simulator\" to activate" \
          -e "delay 0.3" \
          -e "tell application \"System Events\" to click at {$GX, $GY}"
echo "tapped frac=($FX,$FY) -> global=($GX,$GY) window=($X,$Y,$W,$H)"
