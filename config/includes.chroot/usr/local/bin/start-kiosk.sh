#!/bin/sh

set -e

xset -dpms
xset s off
xset s noblank

unclutter -idle 0.1 -root &

if command -v xrandr >/dev/null 2>&1; then
  output="$(xrandr | awk '/ connected/{print $1; exit}')"
  if [ -n "$output" ]; then
    xrandr --output "$output" --mode 1920x1080 || true
  fi
fi

matchbox-window-manager -use_titlebar no -use_cursor no &

IFACE=$(ip -o link show | awk -F': ' '!/lo:/ && /link\/ether/ {print $2; exit}')
MACRAW=$(cat "/sys/class/net/$IFACE/address")
MAC=$(printf '%s' "$MACRAW" | tr -d :)
URL="https://totem.foodprn.it/welcome/${MAC}"

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
