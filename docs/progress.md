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

(điền khi đến Tuần 2)

---

## Tuần 3 — P2: Pipeline RAG offline

(điền khi đến Tuần 3)

---

## Tuần 4 — P2: Tinh chỉnh + Đóng gói offline

(điền khi đến Tuần 4)
