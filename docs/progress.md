# progress.md — Nhật ký tiến độ

> Mục đích: so sánh tiến độ THỰC TẾ vs TASKS.md, phát hiện trễ sớm.
> Nguyên tắc: ghi cuối mỗi phiên làm việc (ngắn, 5-10 dòng). Cuối tuần tổng kết.

## Template mỗi phiên

```
### YYYY-MM-DD — [chủ đề phiên]
- **Thời gian:** HH:MM-HH:MM (khoảng Xh)
- **Mục tiêu phiên:** 1-2 việc định làm
- **Đã làm:** việc thật sự làm + lệnh/file
- **Chưa làm:** việc định làm mà chưa xong + vì sao
- **Khó khăn:** (nếu có) → link ISSUE/RISK/TROUBLE
- **Kế hoạch phiên sau:** 1-2 việc tiếp theo
```

---

## Tuần 1 — P1: Nền tảng hạ tầng Docker

### 2026-07-14 — Cài Docker Desktop + compose NPM + Homepage + reverse proxy

- **Thời gian:** 20:00-23:30 (khoảng 3.5h)
- **Mục tiêu phiên:** Cài Docker Desktop, tạo cấu trúc `homelabops/`, viết compose NPM + Homepage, cấu hình reverse proxy qua domain ảo.
- **Đã làm:**
  - Cài Docker Desktop, kiểm tra RAM: 3.73GiB cấp cho Docker (WSL2).
  - Đi lại từng phần `homelabops/docker-compose.yml` (NPM + Homepage), hiểu: pin version, named volume vs bind mount, Docker network cô lập.
  - `docker compose up -d` — pull 2 image, 2 container up (npm, homepage healthy).
  - Cấu hình NPM Proxy Host: `app1.local` → `homepage:3000`, `npm.local` → `nginx-proxy-manager:81`.
  - Sửa file `hosts`: thêm `app1.local`, `npm.local`, `grafana.local`, `prometheus.local` → `127.0.0.1`.
  - Test: `curl http://app1.local` trả `<title>Homepage</title>` (reverse proxy hoạt động).
- **Chưa làm:** SSL local (dời sang sau, không chặn). Widget CPU/RAM cho Homepage (cần Docker socket, dời Tuần 2).
- **Khó khăn:** Lỗi chính tả `granfana.local` trong file hosts → `ping` không resolve. Fix: sửa thành `grafana.local` (cần quyền admin để lưu file hosts).
- **Kế hoạch phiên sau:** Bắt đầu Tuần 2 — thêm Prometheus + Node Exporter vào compose, cấu hình Grafana dashboard CPU/RAM/disk.

### YYYY-MM-DD — (phiên tiếp theo)

- **Thời gian:**
- **Mục tiêu phiên:**
- **Đã làm:**
- **Chưa làm:**
- **Khó khăn:**
- **Kế hoạch phiên sau:**

---

## Tổng kết Tuần 1

- **Mục tiêu TASKS.md đạt được:**
  - ✅ Cài Docker Desktop, giới hạn RAM (~4GB).
  - ✅ Tạo cấu trúc `homelabops/`.
  - ✅ Viết `docker-compose.yml`: NPM + Homepage.
  - ✅ Cấu hình reverse proxy: truy cập `app1.local` thay vì port.
  - ✅ Cấu hình `hosts` file trỏ domain ảo về `127.0.0.1` (4 domain: app1, npm, grafana, prometheus).
  - ✅ Dùng OpenCode + GLM 5.2 sinh config, troubleshoot.
  - ✅ Ghi log học tập: 3 concept đã hiểu.
- **Mục tiêu chưa đạt:** SSL local (dời sang sau, không chặn tiến độ). Widget tài nguyên Homepage (dời Tuần 2, cần Docker socket).
- **Concept đã học:** `docs/learning-log.md` — Docker network (bridge, Docker DNS), Reverse proxy, Named volume vs bind mount.
- **Vấn đề mở:** không có ISSUE mới. Lỗi chính tả `granfana.local` đã fix ngay trong phiên.
- **Tự đánh giá:** đúng tiến độ. Tuần 1 hoàn thành trong 1 phiên, sẵn sàng sang Tuần 2.

---

## Tuần 2 — P1: Giám sát, log, backup

### 2026-07-14 — Prometheus + Node Exporter + Grafana + Loki + Promtail + backup

- **Thời gian:** 00:00-01:15 (khoảng 1h15)
- **Mục tiêu phiên:** Thêm monitoring (Prometheus + Grafana), logging (Loki + Promtail), backup script.
- **Đã làm:**
  - Thêm Prometheus + Node Exporter vào compose, tạo 2 network (`proxy` + `monitoring`).
  - Cấu hình `prometheus.yml` (2 job: prometheus self + node-exporter). Scrape thành công, cả 2 target `up`.
  - Thêm Grafana, tạo datasource Prometheus (`http://prometheus:9090`), import dashboard Node Exporter Full (ID 1860).
  - Tạo Proxy Host trong NPM cho `prometheus.local` và `grafana.local`.
  - Thêm Loki + Promtail vào compose. Promtail thu thập log 7 container, push lên Loki thành công.
  - Tạo datasource Loki trong Grafana (`http://loki:3100`), test query `{container_name="npm"}` OK.
  - Viết `backup.sh`: backup 5 volume → tar.gz, có `set -euo pipefail`, log, retention 7 ngày. Test 5/5 thành công (~445KB).
  - Tạo Windows Task Scheduler "HomelabOps Backup" chạy daily 2:00 AM.
- **Chưa làm:** Ansible playbook, 2-3 SOP.
- **Khó khăn:**
  - Loki config lỗi `max_chunk_size not found` → field không hợp lệ trong v2.9.7 → xóa field đó.
  - Git Bash MSYS path conversion: `/backup` → `C:/Program Files/Git/backup` → fix `MSYS_NO_PATHCONV=1`.
  - Promtail ban đầu không resolve `loki` (Loki chưa start xong) → tự retry, thành công.
- **Kế hoạch phiên sau:** Viết Ansible playbook deploy service, viết 2-3 SOP (restart, restore, thêm service).

### 2026-07-14 — Viết 3 SOP vận hành

- **Thời gian:** 01:15-01:30 (15 phút)
- **Mục tiêu phiên:** Viết 3 SOP: restart stack, restore backup, thêm service mới.
- **Đã làm:**
  - `SOP-001-restart-stack.md`: quy trình khởi động lại stack sau restart máy, verify bằng curl + docker ps.
  - `SOP-002-restore-backup.md`: quy trình restore volume từ tar.gz, có cảnh báo dừng service trước, dùng `MSYS_NO_PATHCONV=1`.
  - `SOP-003-add-new-service.md`: quy trình thêm service mới (compose + hosts + NPM + Homepage + backup), ví dụ Uptime Kuma.
- **Chưa làm:** Ansible playbook (dời sang sau nếu hết thời gian).
- **Khó khăn:** không.
- **Kế hoạch phiên sau:** Tổng kết Tuần 2, sang Tuần 3 (P2: Ollama + RAG pipeline).

---

## Tổng kết Tuần 2

- **Mục tiêu TASKS.md đạt được:**
  - ✅ Thêm Prometheus + Node Exporter vào compose.
  - ✅ Thêm Grafana, import dashboard CPU/RAM/disk (Node Exporter Full, ID 1860).
  - ✅ Thêm Loki + Promtail, query log container được trong Grafana.
  - ✅ Viết script `backup.sh` backup volume + DB.
  - ✅ Cấu hình cron chạy backup định kỳ (Windows Task Scheduler daily 2AM).
  - ✅ Viết 2-3 SOP: restart stack, restore backup, thêm service mới.
  - ✅ Ghi log học tập: 4 concept đã hiểu.
- **Mục tiêu chưa đạt:** Ansible playbook (dời sang sau). Uptime Kuma (tùy chọn, dời).
- **Concept đã học:** `docs/learning-log.md` — Prometheus pull model + exporter, Metrics vs Logs, Loki vs ELK, Bash `set -euo pipefail` + backup volume.
- **Vấn đề mở:** không có ISSUE mới. TROUBLE-003 (Loki config), TROUBLE-004 (MSYS path) đã closed.
- **Tự đánh giá:** đúng tiến độ. Monitoring + logging + backup + SOP hoàn thành.

---

## Tuần 3 — P2: Pipeline RAG offline

(điền khi đến Tuần 3)

---

## Tuần 4 — P2: Tinh chỉnh + Đóng gói offline

(điền khi đến Tuần 4)
