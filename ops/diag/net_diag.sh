#!/usr/bin/env bash
set -euo pipefail

HOST="${1:-github.com}"
PORT="${2:-443}"
URL="${3:-https://github.com}"

echo "== TARGET =="
echo "HOST=$HOST PORT=$PORT URL=$URL"

echo -e "\n== DNS =="
getent ahosts "$HOST" | awk '{print $1}' | head -n1 || echo "DNS-FAIL"

echo -e "\n== TCP CONNECT ($HOST:$PORT) =="
if timeout 3 bash -lc "</dev/tcp/$HOST/$PORT" 2>/dev/null; then
  echo "TCP-OK"
else
  echo "TCP-FAIL"
fi

echo -e "\n== HTTP PROBE ($URL) =="
curl -s -o /dev/null -w "code=%{http_code} time=%{time_total}\n" "$URL" || echo "CURL-FAIL"

echo -e "\n== DEFAULT ROUTE =="
ip route | sed -n '1,3p' || true

echo -e "\n== LOCAL LISTENERS (top 10) =="
ss -tulpn | head -n 10 || true

echo -e "\n== TRACEROUTE (first 5 hops) =="
(traceroute -n -m 5 "$HOST" 2>/dev/null || echo "no-traceroute") | sed -n '1,6p'
