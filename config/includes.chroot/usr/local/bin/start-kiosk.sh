#!/bin/sh
set -e

# Power mgmt / screensaver off
xset -dpms
xset s off
xset s noblank

# Hide cursor after idle (optional)
unclutter -idle 0.1 -root &

# Start the minimal WM
matchbox-window-manager -use_titlebar no -use_cursor no &

# Pick your homepage / app URL
URL="${KIOSK_URL:-https://www.foodprn.it}"

# Launch Chromium (kiosk)
# Tip: --user-data-dir=/tmp keeps session ephemeral in RAM
exec chromium \
  --kiosk \
  --no-first-run \
  --no-default-browser-check \
  --incognito \
  --disable-translate \
  --disable-features=TranslateUI \
  --disable-session-crashed-bubble \
  --disable-infobars \
  --check-for-update-interval=31536000 \
  --user-data-dir=/tmp/chromium-kiosk \
  "$URL"
