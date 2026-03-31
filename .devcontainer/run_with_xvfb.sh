#!/bin/bash

# Create /tmp/.X11-unix directory with correct permissions
mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix
chown root:root /tmp/.X11-unix

# Kill any existing Xvfb processes
pkill -f "Xvfb :0" || true

# Remove the lock file if it exists
rm -f /tmp/.X0-lock

# Start Xvfb and set DISPLAY environment variable
Xvfb :0 -screen 0 1024x768x24 &
XVFB_PID=$!
export DISPLAY=:0

# Start x11vnc without a password on port 5900
x11vnc -display :0 -nopw -forever -rfbport 5900 -bg -o /tmp/x11vnc.log -noxdamage -noxfixes -noxkb -nolookup -no6 -shared &

# Start openbox window manager
openbox-session &

# Start noVNC
websockify --web=/usr/share/novnc/ --wrap-mode=ignore 6080 localhost:5900 &

# Wait a moment to ensure Xvfb has started
sleep 2

# Verify DISPLAY is set
echo "DISPLAY is set to $DISPLAY"

# Keep the script running to maintain the X session
sleep infinity
