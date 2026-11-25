"""Tap the booted Simulator at device-pixel coordinates via Quartz mouse events.

Maps a device-pixel point (based on 1320x2868 iPhone 16 Pro Max) to the global
screen position of the Simulator window, then posts a real mouse click there.

Usage: python3 sim_tap.py <px> <py>          # tap at device pixel px,py
       python3 sim_tap.py --frac <fx> <fy>    # tap at fraction of screen (0..1)
"""
import sys
import subprocess
import time

DEV_W, DEV_H = 1320, 2868


def sim_window_bounds():
    """Return (x, y, w, h) of the Simulator device window in global points."""
    script = '''
    tell application "System Events"
        tell process "Simulator"
            set win to first window whose subrole is "AXStandardWindow"
            set p to position of win
            set s to size of win
            return (item 1 of p as string) & "," & (item 2 of p as string) & "," & (item 1 of s as string) & "," & (item 2 of s as string)
        end tell
    end tell
    '''
    out = subprocess.check_output(["osascript", "-e", script]).decode().strip()
    return [float(v) for v in out.split(",")]


def tap_frac(fx, fy):
    x, y, w, h = sim_window_bounds()
    gx = x + fx * w
    gy = y + fy * h
    # Quartz click
    from Quartz import (CGEventCreateMouseEvent, CGEventPost,
                        kCGEventLeftMouseDown, kCGEventLeftMouseUp,
                        kCGHIDEventTap, kCGMouseButtonLeft)
    for etype in (kCGEventLeftMouseDown, kCGEventLeftMouseUp):
        ev = CGEventCreateMouseEvent(None, etype, (gx, gy), kCGMouseButtonLeft)
        CGEventPost(kCGHIDEventTap, ev)
        time.sleep(0.05)
    print(f"tapped frac=({fx:.3f},{fy:.3f}) -> global=({gx:.0f},{gy:.0f})  window={x,y,w,h}")


if __name__ == "__main__":
    if sys.argv[1] == "--frac":
        tap_frac(float(sys.argv[2]), float(sys.argv[3]))
    else:
        tap_frac(float(sys.argv[1]) / DEV_W, float(sys.argv[2]) / DEV_H)
