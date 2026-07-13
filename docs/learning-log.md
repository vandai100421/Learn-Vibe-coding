# learning-log.md — Nhật ký học tập

> Mục đích: ghi lại concept đã hiểu theo TASKS.md (3-5 concept/tuần).
> Nguyên tắc: ghi bằng lời mình hiểu, không copy-paste. Nếu giải thích được cho người khác = mức 5.

## Mức hiểu

- `1` — Nghe qua, biết tồn tại
- `2` — Hiểu khái niệm, chưa dùng được
- `3` — Dùng được theo hướng dẫn
- `4` — Dùng độc lập, troubleshoot được
- `5` — Giải thích được cho người khác

## Template mỗi entry

```
### [Tuần X] Concept: [tên]
- **Ngày:** YYYY-MM-DD
- **Mức hiểu:** 1-5
- **Giải thích bằng lời mình:** 2-3 câu
- **Ví dụ cụ thể đã làm:** lệnh/file liên quan
- **Câu hỏi còn lại:** (nếu có)
- **Tài liệu tham khảo:** link/file
```

---

## Tuần 1 — P1: Nền tảng hạ tầng Docker

### [Tuần 1] Concept: Docker network (bridge vs internal)

- **Ngày:** 2026-07-14
- **Mức hiểu:** 3
- **Giải thích bằng lời mình:** Docker mặc định tạo bridge network cho container giao tiếp. Mỗi network cô lập — container khác network không thấy nhau. Expose port chỉ để host truy cập, không cần cho container-container. Container gọi nhau bằng **tên service** (Docker DNS resolve), không phải IP hay localhost.
- **Ví dụ cụ thể đã làm:** NPM và Homepage cùng network `proxy` (compose `homelabops/docker-compose.yml:51`). NPM forward `app1.local` → `homepage:3000` được vì Docker DNS resolve tên `homepage` thành IP container. Nếu khác network → NPM không thấy `homepage` → 502 Bad Gateway.
- **Câu hỏi còn lại:** Khi nào dùng `internal: true`? Có chặn internet ra không?
- **Tài liệu tham khảo:** `homelabops/docker-compose.yml`, Docker docs network.

### [Tuần 1] Concept: Reverse proxy

- **Ngày:** 2026-07-14
- **Mức hiểu:** 3
- **Giải thích bằng lời mình:** Thay vì truy cập `localhost:3000`, `localhost:9090`..., dùng Nginx Proxy Manager nhận request theo domain (`app1.local`) rồi forward đến service đúng. Lợi ích: 1 port (80/443), SSL tập trung, dễ nhớ.
- **Ví dụ cụ thể đã làm:** Cấu hình `hosts` file trỏ `app1.local → 127.0.0.1`, NPM forward `app1.local` → `homepage:3000`.
- **Câu hỏi còn lại:** SSL local thế nào? Cần certificate tự ký?
- **Tài liệu tham khảo:** `homelabops/nginx-proxy/`.

### [Tuần 1] Concept: Named volume vs bind mount

- **Ngày:** 2026-07-14
- **Mức hiểu:** 3
- **Giải thích bằng lời mình:** Cả 2 đều lưu dữ liệu container ra ngoài, nhưng cách quản lý khác. Named volume (ví dụ `npm_data:/data`) do Docker quản lý vị trí lưu, không sửa trực tiếp được, phù hợp dữ liệu quan trọng không cần đụng vào. Bind mount (ví dụ `./homepage/config:/app/config`) trỏ thẳng vào thư mục trên host, sửa file trực tiếp container thấy ngay, phù hợp config cần chỉnh thường xuyên.
- **Ví dụ cụ thể đã làm:** NPM dùng named volume `npm_data` (config proxy, user — không sửa tay). Homepage dùng bind mount `./homepage/config` (sửa `services.yaml`, `settings.yaml` trực tiếp trên host, dashboard cập nhật ngay).
- **Câu hỏi còn lại:** Khi backup, named volume backup thế nào? Có cần `docker run --rm -v ...` để sao chép ra?
- **Tài liệu tham khảo:** `homelabops/docker-compose.yml:22,40`, CODING_STANDARDS.md mục Docker.

### [Tuần 1] Concept: (chưa ghi — điền tiếp)

- **Ngày:**
- **Mức hiểu:**
- **Giải thích bằng lời mình:**
- **Ví dụ cụ thể đã làm:**
- **Câu hỏi còn lại:**
- **Tài liệu tham khảo:**

---

## Tuần 2 — P1: Giám sát, log, backup

### [Tuần 2] Concept: Prometheus pull model + exporter

- **Ngày:** 2026-07-14
- **Mức hiểu:** 3
- **Giải thích bằng lời mình:** Prometheus dùng pull model — nó chủ động gọi đến exporter mỗi 15s để lấy metrics, không nhận push. Exporter là chương trình expose metrics ra endpoint `/metrics`. Node Exporter expose metrics hệ thống (CPU, RAM, disk). Hệ quả: Prometheus và exporter phải cùng Docker network mới scrape được.
- **Ví dụ cụ thể đã làm:** Prometheus ở network `proxy` + `monitoring`, Node Exporter chỉ ở `monitoring`. Prometheus scrape `node-exporter:9100` (Docker DNS resolve). Cả 2 target `up` trong `/api/v1/targets`.
- **Câu hỏi còn lại:** Khi nào dùng push model (Pushgateway) thay pull?
- **Tài liệu tham khảo:** `homelabops/docker-compose.yml`, `homelabops/prometheus/prometheus.yml`.

### [Tuần 2] Concept: Metrics vs Logs (khi nào dùng cái nào)

- **Ngày:** 2026-07-14
- **Mức hiểu:** 4
- **Giải thích bằng lời mình:** Metrics = số đo theo thời gian (CPU 80%, RAM 4GB), nhỏ có cấu trúc, trả lời "hệ thống có khỏe không?". Logs = sự kiện (error, request), lớn text, trả lời "chuyện gì đã xảy ra? tại sao lỗi?". Cần cả hai: metrics báo có vấn đề, logs cho biết vấn đề là gì. Prometheus cho metrics, Loki cho logs, cả hai query trong Grafana UI.
- **Ví dụ cụ thể đã làm:** Grafana có 2 datasource: Prometheus (metrics) + Loki (logs). Dashboard Node Exporter Full query Prometheus. Explore Loki với `{container_name="npm"}` xem log NPM.
- **Câu hỏi còn lại:** Alerting nên dựa trên metrics hay logs?
- **Tài liệu tham khảo:** `homelabops/docker-compose.yml` (services: prometheus, loki, grafana).

### [Tuần 2] Concept: Loki vs ELK (vì sao chọn Loki với 8GB RAM)

- **Ngày:** 2026-07-14
- **Mức hiểu:** 3
- **Giải thích bằng lời mình:** ELK (Elasticsearch) index toàn bộ nội dung log → mạnh full-text search nhưng nặng RAM (JVM heap 2-4GB+). Loki chỉ index label (metadata), log để thô → nhẹ (~200MB), query bằng LogQL (giống PromQL). Với 8GB RAM, ELK không khả thi, Loki đủ nhẹ và tích hợp sẵn trong Grafana UI (không cần thêm service).
- **Ví dụ cụ thể đã làm:** Loki + Promtail chạy cùng stack, Promtail push log 7 container lên Loki. Query `{container_name="npm"}` trả log NPM trong Grafana Explore.
- **Câu hỏi còn lại:** Loki query chậm hơn Elasticsearch bao nhiêu? Khi nào Loki không đủ?
- **Tài liệu tham khảo:** `homelabops/loki/loki-config.yml`, `homelabops/promtail/promtail-config.yml`.

### [Tuần 2] Concept: Bash `set -euo pipefail` + backup volume Docker

- **Ngày:** 2026-07-14
- **Mức hiểu:** 3
- **Giải thích bằng lời mình:** `set -e` thoát khi lệnh lỗi, `set -u` lỗi khi dùng biến chưa định nghĩa, `set -o pipefail` lỗi nếu pipe có lệnh lỗi. Backup volume Docker không copy trực tiếp được (Docker quản lý vị trí) → dùng `docker run --rm -v volume:/data -v backup_dir:/backup alpine tar czf` tạo container tạm nén ra tar.gz.
- **Ví dụ cụ thể đã làm:** `backup.sh` backup 5 volume (npm_data, prometheus_data, grafana_data, loki_data, npm_letsencrypt) → tar.gz, 5/5 thành công (~445KB). Retention 7 ngày, chạy qua Windows Task Scheduler daily 2AM.
- **Câu hỏi còn lại:** Restore test thế nào để chắc backup không hỏng?
- **Tài liệu tham khảo:** `homelabops/backup/backup.sh`.

---

## Tuần 3 — P2: Pipeline RAG offline

(điền khi học Tuần 3)

---

## Tuần 4 — P2: Tinh chỉnh + Đóng gói offline

(điền khi học Tuần 4)
