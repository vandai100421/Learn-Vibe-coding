# SOP-003: Thêm service mới vào HomelabOps stack

## Mục đích

Thêm 1 service Docker mới vào stack HomelabOps, cấu hình reverse proxy qua NPM, thêm dashboard link vào Homepage. Áp dụng cho mọi service mới (Uptime Kuma, Portainer, v.v.).

## Điều kiện tiên quyết

- Docker Desktop đang chạy, stack HomelabOps đang up
- Đã đọc `CODING_STANDARDS.md` (pin version, restart policy, network)
- Biết image name + version của service cần thêm (ví dụ `louislam/uptime-kuma:1.23.11`)

## Các bước

### 1. Thêm service vào docker-compose.yml

Mở `homelabops/docker-compose.yml`, thêm block service mới dưới `services:`. Ví dụ thêm Uptime Kuma:

```yaml
  # ─────────────────────────────────────────────
  # Uptime Kuma — monitoring uptime (tùy chọn Tuần 2)
  # ─────────────────────────────────────────────
  uptime-kuma:
    image: louislam/uptime-kuma:1.23.11   # Pin version, KHÔNG dùng latest
    container_name: uptime-kuma
    restart: unless-stopped               # Bắt buộc theo CODING_STANDARDS
    volumes:
      - uptime_kuma_data:/app/data        # Named volume cho dữ liệu quan trọng
    networks:
      - proxy                             # Để NPM route domain ảo → service
    environment:
      - TZ=${TZ:-Asia/Ho_Chi_Minh}
```

**Quy tắc (từ CODING_STANDARDS):**
- Pin version (`1.23.11`), không `latest` — để tái tạo được trong môi trường offline
- `restart: unless-stopped` — bắt buộc
- Named volume cho dữ liệu quan trọng (`/app/data`)
- Không expose port ra host nếu không cần thiết — để NPM route

### 2. Thêm volume vào phần volumes

Cuối file compose, thêm:

```yaml
volumes:
  ...
  uptime_kuma_data:
```

### 3. Validate compose

```bash
cd "E:\Tài liệu\Vibe coding\Học tập\homelabops"
docker compose config
```

- Không lỗi cú pháp → tiếp tục.
- Lỗi → sửa YAML (thụt lề, cú pháp).

### 4. Khởi động service mới

```bash
docker compose up -d uptime-kuma
```

- Pull image lần đầu (chậm), sau đó start container.

### 5. Thêm domain ảo vào file hosts

Mở Notepad **as Administrator**, mở `C:\Windows\System32\drivers\etc\hosts`, thêm:

```
127.0.0.1  uptime-kuma.local
```

Lưu lại (Ctrl+S).

### 6. Tạo Proxy Host trong NPM

Vào http://npm.local (hoặc http://localhost:81) → Hosts → Proxy Hosts → Add Proxy Host:

| Trường | Giá trị |
|--------|---------|
| Domain Names | `uptime-kuma.local` |
| Scheme | `http` |
| Forward Hostname | `uptime-kuma` (tên service trong compose) |
| Forward Port | `3001` (port nội bộ của service — check docs) |
| Block Common Exploits | ✅ |
| Websockets Support | ✅ |

Save.

### 7. Thêm service vào Homepage dashboard

Mở `homelabops/homepage/config/services.yaml`, thêm vào group `HomelabOps`:

```yaml
    - Uptime Kuma:
        href: http://uptime-kuma.local
        icon: uptime-kuma
        description: Monitoring uptime service
        ping: http://uptime-kuma.local
```

Homepage tự reload config (bind mount), không cần restart.

### 8. Thêm volume vào backup script

Mở `homelabops/backup/backup.sh`, thêm tên volume mới vào mảng `VOLUMES`:

```bash
VOLUMES=(
  ...
  "homelabops_uptime_kuma_data"
)
```

## Xác minh

### Container Up

```bash
docker ps --format "table {{.Names}}\t{{.Status}}" | grep uptime-kuma
```

### Truy cập qua domain ảo

```bash
curl -s -o /dev/null -w "%{http_code}" http://uptime-kuma.local   # Kỳ vọng: 200
```

Hoặc mở trình duyệt: http://uptime-kuma.local

### Homepage hiển thị service

Vào http://app1.local, kiểm tra group HomelabOps có link "Uptime Kuma" với ping xanh.

## Troubleshooting

### 502 Bad Gateway khi truy cập domain ảo

- NPM không thấy service → kiểm tra cùng network `proxy` trong compose
- Port sai → check docs service, đảm bảo Forward Port đúng port nội bộ

### "No such host" trong NPM logs

- Forward Hostname phải là **tên service** (ví dụ `uptime-kuma`), không phải container_name hay localhost

### Service không lên sau `docker compose up -d`

```bash
docker compose logs uptime-kuma
```

- Image pull fail (offline) → pre-stage image trước
- Volume permission error → check docs service, có thể cần chạy với user cụ thể
