#!/usr/bin/env bash
# auto_backup.sh - tự động backup hằng ngày

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/backups/auto_backup.log"

echo "$(date +'%F %T') - Chạy backup tự động" >> "$LOG_FILE"
bash "${SCRIPT_DIR}/backup.sh" >> "$LOG_FILE" 2>&1
