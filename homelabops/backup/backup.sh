#!/bin/bash
# backup.sh — backup toàn bộ named volume của HomelabOps stack
# Mục đích: sao chép dữ liệu volume (Prometheus, Grafana, Loki, NPM) ra file tar.gz
# Cách: tạo container tạm (alpine), mount volume + thư mục backup, tar czf
# Chạy: bash backup.sh (hoặc qua cron định kỳ)
# Restore: xem SOP restore-backup.md

set -euo pipefail  # Fail nhanh: e=thoát khi lỗi, u=lỗi biến chưa định nghĩa, pipefail=lỗi trong pipe

# ═══════════════════════════════════════════════
# Biến cấu hình — dễ thay đổi ở đầu file
# ═══════════════════════════════════════════════
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${SCRIPT_DIR}/../backups"  # Thư mục chứa file backup
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")     # Timestamp cho tên file
RETENTION_DAYS=7                        # Giữ backup 7 ngày, cũ hơn sẽ xóa

# Danh sách volume cần backup (tên volume theo Docker)
# Thêm volume mới vào đây khi thêm service
VOLUMES=(
  "homelabops_npm_data"
  "homelabops_npm_letsencrypt"
  "homelabops_prometheus_data"
  "homelabops_grafana_data"
  "homelabops_loki_data"
)

# ═══════════════════════════════════════════════
# Hàm log — in ra console với prefix [INFO]/[ERROR]
# ═══════════════════════════════════════════════
log_info() {
  echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') $1"
}

log_error() {
  echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') $1" >&2
}

# ═══════════════════════════════════════════════
# Kiểm tra thư mục backup tồn tại
# Vì sao: tar cần thư mục đích tồn tại trước khi ghi
# ═══════════════════════════════════════════════
if [ ! -d "$BACKUP_DIR" ]; then
  log_error "Thư mục backup không tồn tại: $BACKUP_DIR"
  log_info "Tạo thư mục: mkdir -p $BACKUP_DIR"
  mkdir -p "$BACKUP_DIR"
fi

log_info "Bắt đầu backup HomelabOps — $(date)"
log_info "Thư mục backup: $BACKUP_DIR"
log_info "Số volume cần backup: ${#VOLUMES[@]}"

# ═══════════════════════════════════════════════
# Backup từng volume
# Cách: docker run --rm tạo container tạm alpine, mount volume + backup dir
# tar czf nén volume thành file .tar.gz
# ═══════════════════════════════════════════════
SUCCESS_COUNT=0
FAIL_COUNT=0

for volume in "${VOLUMES[@]}"; do
  backup_file="${BACKUP_DIR}/${volume}_${TIMESTAMP}.tar.gz"
  log_info "Backup volume: $volume → $backup_file"

  # Kiểm tra volume tồn tại
  if ! docker volume inspect "$volume" >/dev/null 2>&1; then
    log_error "Volume không tồn tại, bỏ qua: $volume"
    FAIL_COUNT=$((FAIL_COUNT + 1))
    continue
  fi

  # Tạo container tạm để backup
  # --rm: tự xóa container sau khi xong
  # -v volume:/data: mount volume cần backup (read-only để an toàn)
  # -v backup_dir:/backup: mount thư mục ghi file backup
  # alpine: image nhẹ (~5MB), có sẵn tar
  # MSYS_NO_PATHCONV=1: Git Bash trên Windows tự convert path /backup → C:/.../backup
  # → phải tắt path conversion để container nhận đúng path Linux
  if MSYS_NO_PATHCONV=1 docker run --rm \
    -v "${volume}:/data:ro" \
    -v "${BACKUP_DIR}:/backup" \
    alpine:3.19 \
    tar czf "/backup/${volume}_${TIMESTAMP}.tar.gz" -C /data .; then
    log_info "✓ Backup thành công: $volume"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
  else
    log_error "✗ Backup thất bại: $volume"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
done

# ═══════════════════════════════════════════════
# Xóa backup cũ hơn RETENTION_DAYS
# Vì sao: tránh disk phình to, giữ 7 ngày là đủ cho homelab
# find -mtime +N: file cũ hơn N ngày
# ═══════════════════════════════════════════════
log_info "Dọn dẹp backup cũ hơn ${RETENTION_DAYS} ngày..."
deleted_count=$(find "$BACKUP_DIR" -name "*.tar.gz" -mtime +"$RETENTION_DAYS" -print -delete | wc -l)
log_info "Đã xóa $deleted_count file backup cũ"

# ═══════════════════════════════════════════════
# Tổng kết
# ═══════════════════════════════════════════════
log_info "════════════════════════════════════════"
log_info "Tổng kết backup:"
log_info "  Thành công: $SUCCESS_COUNT/$((SUCCESS_COUNT + FAIL_COUNT))"
log_info "  Thất bại: $FAIL_COUNT"
log_info "  Thời gian: $(date)"
log_info "  File backup tại: $BACKUP_DIR"
log_info "════════════════════════════════════════"

# Exit code: 0 nếu tất cả thành công, 1 nếu có lỗi
if [ "$FAIL_COUNT" -gt 0 ]; then
  log_error "Có $FAIL_COUNT volume backup thất bại!"
  exit 1
fi

log_info "Backup hoàn tất!"
exit 0
