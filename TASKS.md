# TASKS.md

# Lịch trình 4 tuần

## Nguyên tắc phân bổ

- Mỗi tuần: 60% thời gian học concept + 40% thực hành.
- Trọng tâm: hiểu "vì sao", không chỉ "làm sao".
- Mỗi tuần ghi lại 3-5 concept đã học vào `docs/learning-log.md`.
- Commit nhỏ, thường xuyên sau mỗi bước chạy đúng.

---

## Tuần 1 — P1: Nền tảng hạ tầng Docker

### Mục tiêu học

- Docker Engine vs Docker Desktop: vì sao dùng Engine trong WSL2.
- Docker Compose: orchestration nhiều service.
- Docker network: bridge, internal, expose port.
- Reverse proxy: vì sao cần, định tuyến theo domain.
- DNS local: file `hosts`, domain ảo.

### Việc cần làm

- [ ] Cài WSL2 + Ubuntu + Docker Engine (không dùng Docker Desktop).
- [ ] Tạo cấu trúc thư mục `/homelabops/`.
- [ ] Viết `docker-compose.yml`: Nginx Proxy Manager + Homepage.
- [ ] Cấu hình reverse proxy: truy cập `app1.local` thay vì port.
- [ ] Cấu hình `hosts` file trỏ domain ảo về `127.0.0.1`.
- [ ] Dùng OpenCode + GLM 5.2 sinh config, troubleshoot.
- [ ] Ghi log học tập: 3-5 concept đã hiểu.

### Đầu ra kỳ vọng

- Dashboard Homepage hiển thị, truy cập qua domain ảo.
- Hiểu concept Docker network và reverse proxy.

---

## Tuần 2 — P1: Giám sát, log, backup

### Mục tiêu học

- Metrics vs logs: khác biệt, khi dùng cái nào.
- Prometheus: kiến trúc pull, exporter là gì.
- Grafana: dashboard, query PromQL cơ bản.
- Loki + Promtail: vì sao không dùng ELK, log structured.
- Uptime monitoring: healthcheck, alerting.
- Backup: incremental vs full, cron scheduling.
- Bash scripting: `set -euo pipefail`, error handling.
- Ansible: Infrastructure as Code, vì sao cần cho vận hành nhiều server.

### Việc cần làm

- [ ] Thêm Prometheus + Node Exporter vào compose.
- [ ] Thêm Grafana, import dashboard CPU/RAM/disk.
- [ ] (Tùy chọn) Thêm Uptime Kuma, cấu hình cảnh báo service down.
- [ ] Thêm Loki + Promtail, query log container.
- [ ] Viết script `backup.sh` backup volume + DB.
- [ ] Cấu hình cron chạy backup định kỳ.
- [ ] Viết 1 Ansible playbook deploy 1-2 service (học IaC).
- [ ] Viết 2-3 SOP: "khởi động lại stack", "restore backup", "thêm service mới".
- [ ] Ghi log học tập: 3-5 concept đã hiểu.

### Đầu ra kỳ vọng

- Grafana dashboard hoạt động.
- Log query được trong Loki.
- Backup chạy định kỳ.
- 1 Ansible playbook chạy được.
- 2-3 SOP hoàn chỉnh (sẽ upload vào P2).

---

## Tuần 3 — P2: Pipeline RAG offline

### Mục tiêu học

- Local LLM: Ollama architecture, vì sao chạy được offline.
- Model selection: vì sao chọn Qwen2.5:32B, trade-off RAM/speed/quality.
- Embedding: vector là gì, vì sao cần embed, bge-m3 vì sao tốt tiếng Việt.
- Vector DB: ChromaDB vs Qdrant vs FAISS, vì sao chọn ChromaDB.
- RAG pipeline: ingest → chunk → embed → store → retrieve → generate.
- Chunking: token-based, overlap, vì sao quan trọng.

### Việc cần làm

- [ ] Cài Ollama, pull `qwen2.5:32b` + `bge-m3`.
- [ ] Test chạy model trên GPU, đo tốc độ.
- [ ] Cài ChromaDB (Docker) + Open WebUI (Docker).
- [ ] Kết nối Open WebUI với Ollama.
- [ ] Upload tài liệu P1 (SOP, config, log mẫu) qua Open WebUI UI.
- [ ] Test Q&A cơ bản: "Cách restore backup?", "Service nào đang chạy?".
- [ ] Ghi log học tập: 3-5 concept đã hiểu.

### Đầu ra kỳ vọng

- Chat được với AI bằng tiếng Việt.
- AI trả lời dựa trên tài liệu P1, có hiển thị nguồn.

---

## Tuần 4 — P2: Tinh chỉnh + Đóng gói offline

### Mục tiêu học

- RAG tuning: chunk size, overlap, top-k, re-ranking.
- Hybrid search: BM25 + vector, vì sao quan trọng.
- Vector DB so sánh: ChromaDB vs Qdrant vs PGVector.
- Prompt engineering: system prompt cho trợ lý sysadmin.
- Offline packaging: pre-stage tài nguyên, air-gap ready.
- API integration: kết nối LLM với dữ liệu realtime (Docker API, Uptime Kuma).
- Log analysis: parse log, AI giải thích lỗi.

### Việc cần làm

- [ ] Bật hybrid search (BM25 + vector) trong Open WebUI, so sánh với vector-only.
- [ ] Bật reranking, đánh giá chất lượng trả lời.
- [ ] Tune retrieval: chunk size, top-k, test bộ câu hỏi thực tế.
- [ ] Thử chuyển vector DB sang Qdrant/PGVector, so sánh hiệu năng.
- [ ] Viết system prompt cho trợ lý sysadmin tiếng Việt.
- [ ] Tính năng paste log → AI giải thích + đề xuất xử lý.
- [ ] (Tùy chọn) Tích hợp: hỏi "service nào đang down?" qua Docker API.
- [ ] Đóng gói offline:
  - [ ] `docker save` tất cả image → tar.
  - [ ] Sao chép `~/.ollama/models`.
  - [ ] `pip download` packages → wheel cache.
  - [ ] Tải bge-m3 weights về local.
  - [ ] Sao chép `chromadb/data`.
- [ ] Viết tài liệu hướng dẫn triển khai offline.
- [ ] Ghi log học tập: 3-5 concept đã hiểu + tổng kết khóa học.

### Đầu ra kỳ vọng

- Trợ lý AI hoàn chỉnh: hỏi đáp tiếng Việt, trích nguồn, phân tích log.
- Đã thử hybrid search + reranking, hiểu khác biệt với vector-only.
- Đã so sánh ít nhất 2 vector DB.
- Gói offline sẵn sàng mang vào môi trường nội bộ.
- Tài liệu triển khai offline hoàn chỉnh.

---

## Tổng kết khóa học

Sau 4 tuần, cần có:

1. **HomelabOps** stack chạy ổn định, có monitoring + logging + backup.
2. **OpsBrain** RAG pipeline hoạt động offline, trả lời được câu hỏi ops.
3. **Gói offline** pre-stage đầy đủ cho môi trường air-gap.
4. **Log học tập** ghi lại toàn bộ concept đã hiểu.
5. **SOP + tài liệu** vận hành và triển khai.

## Backlog (làm sau khóa)

- Kubernetes thay Docker Compose.
- CI/CD nội bộ (Gitea + Drone / Woodpecker).
- Multi-agent cho OpsBrain.
- Fine-tuning model cho tiếng Việt ops.
- Reverse engineering, MCP integration.
