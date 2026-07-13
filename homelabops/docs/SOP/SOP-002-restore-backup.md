# SOP-002: Restore backup volume

## Mục đích

Khôi phục dữ liệu volume từ file backup (tar.gz) khi mất dữ liệu, volume hỏng, hoặc cần rollback về trạng thái trước đó.

## Điều kiện tiên quyết

- Đã chạy `backup.sh` ít nhất 1 lần (có file `.tar.gz` trong `homelabops/backups/`)
- Docker Desktop đang chạy
- **CẢNH BÁO:** Restore sẽ ghi đè dữ liệu hiện tại trong volume → dừng service liên quan trước khi restore

## Các bước

### 1. Xem danh sách backup có sẵn

```bash
ls -lh "E:\Tài liệu\Vibe coding\Học tập\homelabops\backups"
```

Chọn file backup cần restore (ví dụ `homelabops_grafana_data_20260714_010033.tar.gz`).

### 2. Dừng service liên quan

Ví dụ restore `grafana_data` → dừng Grafana để tránh conflict ghi file:

```bash
cd "E:\Tài liệu\Vibe coding\Học tập\homelabops"
docker compose stop grafana
```

### 3. Xóa dữ liệu cũ trong volume (nếu có)

```bash
docker run --rm \
  -v homelabops_grafana_data:/data \
  alpine:3.19 \
  sh -c "rm -rf /data/* /data/.* 2>/dev/null; true"
```

**Vì sao xóa trước:** Nếu volume có dữ liệu hỏng, restore ghi đè có thể không sạch → tốt nhất xóa hết rồi giải nén vào.

### 4. Restore từ file backup

```bash
MSYS_NO_PATHCONV=1 docker run --rm \
  -v homelabops_grafana_data:/data \
  -v "E:\Tài liệu\Vibe coding\Học tập\homelabops\backups:/backup" \
  alpine:3.19 \
  tar xzf "/backup/homelabops_grafana_data_20260714_010033.tar.gz" -C /data
```

**Lưu ý:**
- `MSYS_NO_PATHCONV=1` bắt buộc trên Git Bash Windows (tránh path conversion)
- Đổi tên file `.tar.gz` cho đúng backup cần restore
- Đổi tên volume (`homelabops_grafana_data`) cho đúng service

### 5. Khởi động lại service

```bash
docker compose start grafana
```

## Xác minh

### Kiểm tra container Up

```bash
docker ps --format "table {{.Names}}\t{{.Status}}" | grep grafana
```

### Kiểm tra dữ liệu đã restore

Ví dụ Grafana: vào http://grafana.local → Dashboards, kiểm tra dashboard Node Exporter Full vẫn còn.

Ví dụ Prometheus: vào http://prometheus.local:9090 → query `node_load1`, kiểm tra có dữ liệu lịch sử.

## Troubleshooting

### "volume not found"

- Tên volume sai → liệt kê: `docker volume ls | grep homelabops`
- Volume chưa tạo (service chưa chạy lần nào) → `docker compose up -d <service>` trước, rồi restore.

### Restore xong nhưng service không hoạt động

- Kiểm tra log: `docker compose logs <service>`
- Có thể file backup hỏng → kiểm tra: `tar tzf <file>.tar.gz | head` (phải liệt kê được nội dung)
- Nếu backup hỏng → dùng file backup khác (cũ hơn).

### Permission error sau restore

- Container alpine tạo file với root:root, service có thể chạy user khác → `docker exec -u root <container> chown -R <user>:<group> /data`
