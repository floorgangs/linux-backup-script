#!/usr/bin/env bash
# backup.sh - script backup cơ bản bằng tar.gz
# Phonk generated this
# ver: v2

set -euo pipefail  # Bắt lỗi nghiêm ngặt

# === CẤU HÌNH CƠ BẢN ===
SRC_DIR="${1:-./test_source}"  # Nếu không nhập, mặc định là ./test_source
DEST_DIR="./backups"
KEEP=7
MIN_FREE_GB=1  # yêu cầu ít nhất 1GB trống

mkdir -p "$DEST_DIR"
TIMESTAMP="$(date +'%Y-%m-%d_%H-%M-%S')"
BASENAME="$(basename "$SRC_DIR")"
OUTFILE="${DEST_DIR}/${BASENAME}-${TIMESTAMP}.tar.gz"
LOGFILE="${DEST_DIR}/backup.log"

# === HÀM GHI LOG ===
log() {
  echo "$(date +'%F %T') - $*" | tee -a "$LOGFILE"
}

# === KIỂM TRA NGUỒN ===
if [ ! -d "$SRC_DIR" ]; then
  log "LỖI: Thư mục nguồn không tồn tại: $SRC_DIR"
  exit 1
fi

# === KIỂM TRA DUNG LƯỢNG Ổ ĐĨA ===
free_gb=$(df -BG "$DEST_DIR" | awk 'NR==2 {print $4}' | sed 's/G//')
if (( free_gb < MIN_FREE_GB )); then
  log "LỖI: Không đủ dung lượng (còn ${free_gb}GB, cần ≥ ${MIN_FREE_GB}GB)"
  exit 1
fi

# === BẮT ĐẦU BACKUP ===
log " Bắt đầu backup: $SRC_DIR → $OUTFILE"
tar -czf "$OUTFILE" -C "$(dirname "$SRC_DIR")" "$(basename "$SRC_DIR")"
log " Hoàn tất: $OUTFILE"

# === XOÁ FILE BACKUP CŨ ===
count=$(ls -1t ${DEST_DIR}/${BASENAME}-*.tar.gz 2>/dev/null | wc -l)
if [ "$count" -gt "$KEEP" ]; then
  files_to_delete=$(ls -1t ${DEST_DIR}/${BASENAME}-*.tar.gz | tail -n +"$((KEEP+1))")
  for f in $files_to_delete; do
    rm -f "$f" && log "Xoá: $f"
  done
fi

log "KẾT THÚC backup"
