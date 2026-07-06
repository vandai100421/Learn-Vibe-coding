# Project 1 — HomelabOps: Stack dịch vụ tự host

## Tổng quan

HomelabOps là dự án triển khai và quản lý một hạ tầng dịch vụ hoàn chỉnh trên Docker, nhằm học các kiến thức cốt lõi của quản trị hệ thống: containerization, networking, monitoring, logging, backup và automation.

Dự án tập trung giải quyết bài toán vận hành nhiều dịch vụ cùng lúc trong môi trường nội bộ, tạo nền tảng thực hành cho kỹ năng sysadmin.

---

# 1. Bối cảnh

Là người học quản trị hệ thống, tôi cần nắm vững:

- Cách triển khai nhiều dịch vụ trên Docker
- Cấu hình mạng, reverse proxy, SSL
- Giám sát tài nguyên và trạng thái dịch vụ
- Tập hợp log để troubleshooting
- Backup và restore dữ liệu
- Tự động hóa tác vụ vận hành

Môi trường thực hành: máy cá nhân (32GB RAM, có GPU), WSL2 + Ubuntu.

---

# 2. Vấn đề thực tế

Các tình huống quản trị thường gặp:

- Triển khai đồng thời 5-10 dịch vụ, mỗi dịch vụ một port, khó quản lý
- Không biết service nào đang tốn nhiều RAM/CPU
- Service bị treo mà không nhận được cảnh báo
- Log rải rác ở nhiều container, khó truy vấn khi có sự cố
- Mất dữ liệu volume khi chưa có backup định kỳ
- Mỗi lần thêm service phải config thủ công lặp lại

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

# 5. MVP

## Input

- Dockerfile / docker-compose.yml
- Config file (Nginx, Prometheus, Promtail)
- Script bash
- Dữ liệu cần backup (volume, DB)

## Processing

- Docker Compose điều phối service
- Reverse proxy định tuyến request
- Exporter thu thập metrics
- Promtail đẩy log về Loki
- Cron chạy script backup
- Ansible playbook deploy service (Infrastructure as Code)

## Output

- Dashboard trung tâm (Homepage)
- Grafana dashboard giám sát
- Loki query log
- Thư mục backup định kỳ
- Ansible playbook deploy tự động
- SOP / runbook

---

# 6. Công nghệ dự kiến

Containerization

- Docker Engine
- Docker Compose

Reverse Proxy

- Nginx Proxy Manager

Monitoring

- Prometheus
- Node Exporter
- Grafana

Uptime (tùy chọn)

- Uptime Kuma
- Hoặc dùng Prometheus Alertmanager (tránh trùng lặp công cụ)

Logging

- Loki
- Promtail

Dashboard

- Homepage

Backup

- Bash
- Cron

Automation (Infrastructure as Code)

- Ansible

---

# 7. Tiêu chí hoàn thành

- Stack dịch vụ chạy được qua reverse proxy.
- Grafana hiển thị metrics tài nguyên.
- Log container query được trong Loki.
- Backup tự động chạy theo lịch.
- Có 1 Ansible playbook deploy được 1-2 service.
- Có 2-3 SOP vận hành (khởi động lại stack, restore, thêm service).
- Hiểu concept của từng thành phần (không chỉ config chạy).

---

# 8. Hướng phát triển

Project này tạo ra:

- Hạ tầng thực hành cho Project 2 (OpsBrain)
- SOP và log mẫu để ingest làm tri thức cho trợ lý AI
- Nền tảng mở rộng sang Kubernetes, CI/CD nội bộ
