#!/usr/bin/env bash
set -euo pipefail
SRC="/var/log"
DEST="/opt/backups/logs"
mkdir -p "$DEST"
ts="$(date +%F_%H%M%S)"
ARCHIVE="$DEST/logs_${ts}.tgz"
sudo tar -czf "$ARCHIVE" --warning=no-file-changed --exclude='*.gz' "$SRC"
find "$DEST" -type f -name 'logs_*.tgz' -mtime +7 -delete
echo "[backup] created: $ARCHIVE"
ls -lh "$ARCHIVE"
