#!/bin/bash
# Tap the booted Simulator at a fraction of the DEVICE SCREEN (0..1, top-left origin).
#
# Why this exists alongside sim_tap.py: that script needs pyobjc (not installed)
# and maps fractions over the whole window, including the title bar. That error
# is ~0 at the bottom of the screen but ~30pt at the top, which is enough to miss
# a toolbar button. Here the device area is derived from the device aspect ratio,
# and the window is re-measured on every tap because activating Simulator can
# move it.
#
# Usage: sim_tap2.sh <fx> <fy> [device_w device_h]
set -euo pipefail

FX="$1"; FY="$2"
DEV_W="${3:-1320}"; DEV_H="${4:-2868}"

osascript -e 'tell application "Simulator" to activate' >/dev/null
sleep 0.6

read -r X Y W H <<<"$(osascript -e 'tell application "System Events" to tell process "Simulator" to get {position, size} of (first window whose subrole is "AXStandardWindow")' | tr -d ',')"

read -r GX GY <<<"$(python3 -c "
w, h = $W, $H
dev_h_pts = w * ($DEV_H / $DEV_W)   # device area height at the window's width
chrome = h - dev_h_pts              # title bar above the device screen
print(round($X + $FX * w), round($Y + chrome + $FY * dev_h_pts))
")"

cliclick m:$GX,$GY w:200 dd:$GX,$GY w:120 du:$GX,$GY
echo "tapped dev=($FX,$FY) -> global=($GX,$GY) window=($X,$Y,$W,$H)"
