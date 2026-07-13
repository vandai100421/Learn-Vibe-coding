# issues.md — Vấn đề đang mở, theo dõi trạng thái

> Mục đích: theo dõi các vấn đề CHƯA giải quyết, cần xử lý. Khác `troubleshooting.md` (lỗi đã fix).
> Nguyên tắc: mỗi vấn đề 1 ID cố định. Khi fix xong → đổi trạng thái `closed` + copy bài học sang `troubleshooting.md`.

## Trạng thái

- `open` — mới phát hiện, chưa làm
- `in-progress` — đang xử lý
- `blocked` — bị chặn, cần bên thứ 3 / quyết định khác
- `closed` — đã giải quyết (chuyển entry sang troubleshooting.md)
- `cancelled` — quyết định không làm nữa (ghi lý do)

## Ưu tiên

- `P0` — chặn tiến độ tuần, phải fix ngay
- `P1` — quan trọng, fix trong tuần
- `P2` — muộn được, ghi backlog nếu hết thời gian

## Bảng theo dõi

| ID | Mô tả ngắn | Ưu tiên | Trạng thái | Tuần | Người gán | Ngày mở | Ghi chú |
|---|---|---|---|---|---|---|---|
| ISSUE-001 | (ví dụ) Grafana dashboard trống sau khi import | P1 | open | Tuần 2 | tôi | 2026-07-15 | Cần kiểm tra datasource Prometheus |
| ISSUE-002 | (ví dụ) Open WebUI không thấy Ollama | P0 | open | Tuần 3 | tôi | 2026-07-20 | Kiểm tra `OLLAMA_BASE_URL` |

---

## Chi tiết vấn đề

### ISSUE-001: (ví dụ mẫu) Grafana dashboard trống sau khi import

- **Mô tả:** Import dashboard Node Exporter Full từ grafana.com, nhưng tất cả panel hiện "No data".
- **Tiền đề:** Prometheus đang chạy, Node Exporter up.
- **Nguyên nhân nghi ngờ:** datasource trong dashboard là `Prometheus` nhưng instance Grafana chưa cấu hình datasource cùng tên; hoặc job name trong query không khớp `prometheus.yml`.
- **Bước tiếp theo:**
  1. Kiểm tra Grafana → Connections → Data sources có `Prometheus` không.
  2. Test query trong Grafana Explore: `up{job="node-exporter"}`.
  3. Nếu trống → sửa job name trong `prometheus.yml`.
- **Liên kết:** ADR-001 (Docker network), TROUBLE-001.

### ISSUE-002: (ví dụ mẫu) Open WebUI không kết nối được Ollama

- **Mô tả:** Open WebUI hiện "Ollama not reachable" ở góc phải.
- **Tiền đề:** Ollama chạy native Windows (port 11434), Open WebUI chạy trong Docker.
- **Nguyên nhân nghi ngờ:** Open WebUI trong container gọi `localhost:11434` → localhost của container, không phải host. Cần `host.docker.internal:11434`.
- **Bước tiếp theo:**
  1. Đặt biến `OLLAMA_BASE_URL=http://host.docker.internal:11434` trong compose Open WebUI.
  2. Test `curl http://localhost:11434/api/tags` từ host.
- **Liên kết:** ADR-002 (Qwen2.5:3B).

### ISSUE-003:

- **Mô tả:**
- **Tiền đề:**
- **Nguyên nhân nghi ngờ:**
- **Bước tiếp theo:**
- **Liên kết:**
