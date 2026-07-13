# SOP-001: Khởi động lại HomelabOps stack

## Mục đích

Khởi động lại toàn bộ stack HomelabOps sau khi restart máy, sau khi Docker Desktop update, hoặc khi service bị down.

## Điều kiện tiên quyết

- Docker Desktop đã cài (v29.6.1+)
- Docker Desktop **đang chạy** (icon Docker xanh ở system tray)
- Thư mục `homelabops/` có `docker-compose.yml`

## Các bước

### 1. Kiểm tra Docker daemon đang chạy

```bash
docker version
```

- Nếu phần **Server** hiện version → Docker đang chạy, tiếp tục bước 2.
- Nếu lỗi `daemon not running` → mở ứng dụng Docker Desktop, chờ ~1-2 phút đến khi icon xanh.

### 2. Vào thư mục stack

```bash
cd "E:\Tài liệu\Vibe coding\Học tập\homelabops"
```

### 3. Khởi động toàn bộ stack

```bash
docker compose up -d
```

- Lần đầu sau restart: khởi động lại container (không pull lại image).
- Nếu có thay đổi compose: recreate container theo config mới.

### 4. Kiểm tra tất cả container Up

```bash
docker ps --format "table {{.Names}}\t{{.Status}}"
```

Kỳ vọng: 7 container Up (npm, homepage, prometheus, node-exporter, grafana, loki, promtail).

## Xác minh

Truy cập các service qua domain ảo:

| URL | Kỳ vọng |
|-----|---------|
| http://app1.local | Homepage dashboard |
| http://npm.local | NPM admin (login) |
| http://grafana.local | Grafana (dashboard Node Exporter Full) |
| http://prometheus.local:9090 | Prometheus UI |

Hoặc verify nhanh bằng lệnh:

```bash
curl -s -o /dev/null -w "%{http_code}" http://app1.local   # Kỳ vọng: 200
```

## Troubleshooting

### Container không Up

```bash
docker compose logs <service_name>
```

- Lỗi port conflict: service khác đang chiếm port → `netstat -ano | findstr :80`
- Lỗi volume: named volume hỏng → `docker volume rm homelabops_<volume_name>` rồi `docker compose up -d`

### Container Up nhưng service không truy cập được

- Kiểm tra NPM Proxy Host: vào http://npm.local, xem Hosts → Proxy Hosts có domain tương ứng không.
- Kiểm tra Docker network: `docker network inspect homelabops_proxy` — service phải cùng network với NPM.
- Kiểm tra file hosts: `cat C:\Windows\System32\drivers\etc\hosts` — domain ảo phải trỏ `127.0.0.1`.

### Prometheus target DOWN

- Vào http://prometheus.local:9090 → Status → Targets.
- Nếu `node-exporter` DOWN: kiểm tra cùng network `monitoring` trong compose.
