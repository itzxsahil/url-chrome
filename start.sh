#!/usr/bin/env bash
set -euo pipefail

: "${VNC_PASSWORD:?Set VNC_PASSWORD in Render environment variables}"

PORT="${PORT:-10000}"
START_URL="${START_URL:-https://www.google.com}"

# Validate the configured launch URL before passing it to Chrome.
python3 - "$START_URL" <<'PY'
import sys
from urllib.parse import urlparse
u = urlparse(sys.argv[1])
if u.scheme not in ("http", "https") or not u.netloc:
    raise SystemExit("START_URL must be a valid http:// or https:// URL")
PY

mkdir -p /tmp/.X11-unix
Xvfb :1 -screen 0 1366x768x24 -ac +extension GLX +render -noreset &
export DISPLAY=:1
sleep 2

x11vnc -storepasswd "$VNC_PASSWORD" /tmp/vnc.pass >/dev/null
x11vnc -display :1 -forever -shared -rfbauth /tmp/vnc.pass -listen 127.0.0.1 -rfbport 5900 &

google-chrome \
  --no-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --no-first-run \
  --no-default-browser-check \
  --user-data-dir=/tmp/chrome-profile \
  --start-maximized \
  "$START_URL" &

# Render routes HTTP and WebSocket traffic through the same public port.
exec websockify --web=/usr/share/novnc --heartbeat=30 "$PORT" 127.0.0.1:5900
