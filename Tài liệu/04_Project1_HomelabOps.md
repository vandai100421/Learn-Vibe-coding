# Project 1 — HomelabOps: Stack dịch vụ tự host

## Tổng quan

HomelabOps là dự án triển khai và quản lý một hạ tầng dịch vụ hoàn chỉnh trên Docker, nhằm học các kiến thức cốt lõi của quản trị hệ thống: containerization, networking, monitoring, logging, backup và automation.

Dự án tập trung giải quyết bài toán vận hành nhiều dịch vụ cùng lúc trong môi trường nội bộ, tạo nền tảng thực hành cho kỹ năng sysadmin.

**Scope được tinh chỉnh cho 4 tuần, phân tầng ưu tiên.**

---

# 1. Bối cảnh

Là người học quản trị hệ thống, tôi cần nắm vững:

- Cách triển khai nhiều dịch vụ trên Docker
- Cấu hình mạng, reverse proxy, SSL
- Giám sát tài nguyên và trạng thái dịch vụ
- Tập hợp log để troubleshooting
- Backup và restore dữ liệu
- Tự động hóa tác vụ vận hành

Môi trường thực hành: máy cá nhân (8GB RAM, Windows 10), Docker Desktop.

**Lưu ý tài nguyên (8GB RAM):** Cần chạy từng nhóm service, không bật toàn bộ stack cùng lúc. Ưu tiên Tier 1 trước (Nginx Proxy Manager + Grafana ~300MB), bật Loki/Promtail/Ansible khi cần thực hành. Giới hạn RAM Docker Desktop trong Settings → Resources (để ~3-4GB cho Docker, còn lại cho Windows).

---

# 2. Vấn đề thực tế

Các tình huống quản trị thường gặp:

- Triển khai đồng thời nhiều dịch vụ, mỗi dịch vụ một port, khó quản lý
- Không biết service nào đang tốn nhiều RAM/CPU
- Service bị treo mà không nhận được cảnh báo
- Log rải rác ở nhiều container, khó truy vấn khi có sự cố
- Mất dữ liệu volume khi chưa có backup định kỳ

---

# 3. Mục tiêu

Xây dựng stack hạ tầng giúp:

- Triển khai dịch vụ qua Docker Compose
- Truy cập qua domain ảo thay vì port
- Giám sát tài nguyên và trạng thái
- Tập hợp log tập trung
- Backup tự động theo lịch
- Có tài liệu SOP để vận hành

Trọng tâm: học concept, không cố hoàn thiện sản phẩm.

---

# 4. Người dùng

Người dùng chính:

- Cá nhân tôi (học sysadmin).

Có thể mở rộng:

- Nhóm vận hành nội bộ.

---

# 5. MVP (phân tầng ưu tiên)

## Tier 1 — Bắt buộc (Tuần 1)

### Input

- Dockerfile / docker-compose.yml
- Config file (Nginx Proxy Manager, Prometheus)
- Script bash

### Processing

- Docker Compose điều phối **2-3 service** (không phải 5-10)
- Reverse proxy (Nginx Proxy Manager) định tuyến request qua domain ảo
- Node Exporter thu thập metrics → Prometheus lưu trữ → Grafana hiển thị

### Output

- 2-3 service chạy qua reverse proxy với domain ảo
- Grafana dashboard hiển thị metrics tài nguyên (RAM, CPU, disk)

## Tier 2 — Nên có (Tuần 2)

### Processing

- Promtail đẩy log về Loki
- Cron chạy script backup

### Output

- Log container query được trong Loki
- Backup tự động chạy theo lịch, có thư mục backup

## Tier 3 — Tùy chọn (chỉ làm nếu Tier 1+2 xong sớm)

- Homepage dashboard trung tâm
- Ansible playbook deploy 1-2 service (Infrastructure as Code)
- Uptime Kuma hoặc Alertmanager (chọn 1, tránh trùng lặp công cụ)

---

# 6. Công nghệ dự kiến

### Containerization

- Docker Desktop (bao gồm Docker Engine)
- Docker Compose

### Reverse Proxy

- Nginx Proxy Manager

### Monitoring

- Prometheus
- Node Exporter
- Grafana

### Logging

- Loki
- Promtail

### Backup

- Bash
- Cron

### Tùy chọn (Tier 3)

- Homepage (dashboard)
- Ansible (automation / IaC)
- Uptime Kuma hoặc Alertmanager

---

# 7. Tiêu chí hoàn thành

**Bắt buộc (Tier 1):**

- 2-3 service chạy được qua reverse proxy.
- Grafana hiển thị metrics tài nguyên.
- Hiểu concept của từng thành phần (không chỉ config chạy).

**Nên có (Tier 2):**

- Log container query được trong Loki.
- Backup tự động chạy theo lịch.
- Có 1-2 SOP vận hành (khởi động lại stack, restore backup).

**Tùy chọn (Tier 3):**

- Có 1 Ansible playbook deploy được 1-2 service.
- Có 2-3 SOP vận hành hoàn chỉnh.
- Homepage dashboard trung tâm.

---

# 8. Hướng phát triển

Project này tạo ra:

- Hạ tầng thực hành cho Project 2 (OpsBrain)
- SOP và log mẫu để ingest làm tri thức cho trợ lý AI
- Nền tảng mở rộng sang Kubernetes, CI/CD nội bộ