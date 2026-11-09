# URL Chrome on Render

This service runs Google Chrome in a virtual desktop and exposes the desktop through noVNC.

## Deploy

1. In Render, create a **New + → Blueprint** service and select this repository, or create a Docker Web Service from the repository.
2. Set `START_URL` to the website Chrome should open (for example, `https://example.com`).
3. Set `VNC_PASSWORD` to a strong password. Do not leave it blank or share it.
4. Deploy. Open the service's `https://<your-service>.onrender.com/vnc.html` URL.
5. Enter the VNC password when prompted. Chrome will open the configured `START_URL`.

Render routes both the noVNC page and its WebSocket connection through the service's `PORT`.

## Environment variables

- `START_URL`: initial page opened in Chrome; must be an `http://` or `https://` URL.
- `VNC_PASSWORD`: required VNC password used to protect remote desktop access.
- `PORT`: provided by Render automatically; do not hardcode it.

The browser profile is temporary and is reset when the service restarts or is redeployed.
