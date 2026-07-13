# BÁO CÁO KẾT QUẢ THỰC HIỆN DỰ ÁN

**Khóa học:** Code with AI — Học cách dùng AI để lập trình + Quản trị hệ thống
**Thời gian thực hiện:** 2026-07-13 — 2026-07-14
**Người thực hiện:** [Học viên]
**Hỗ trợ:** OpenCode + GLM 5.2

---

## 1. TỔNG QUAN

Báo cáo này ghi lại kết quả thực hiện 2 project trong khuôn khổ khóa học "Code with AI":

| Project | Tên | Mục tiêu | Trạng thái |
|---------|-----|----------|------------|
| P1 | HomelabOps | Stack dịch vụ tự host trên Docker, học sysadmin cơ bản | ✅ Hoàn thành (Tuần 1 + Tuần 2) |
| P2 | OpsBrain | Trợ lý AI offline RAG cho quản trị hệ thống | 🔄 Đang tiến hành (Tuần 3 — bước đầu) |

**Môi trường:**
- Máy cá nhân: 8GB RAM, không GPU, Windows 10
- Docker Desktop v29.6.1 (WSL2, giới hạn ~4GB RAM)
- Ollama v0.31.2 (native Windows, CPU)

---

## 2. KẾT QUẢ PROJECT 1 — HOMELABOPS

### 2.1. Tuần 1 — Nền tảng hạ tầng Docker

#### Việc đã làm

| # | Việc | Kết quả xác minh |
|---|------|------------------|
| 1 | Cài Docker Desktop, giới hạn RAM 4GB | `docker info` → 3.73GiB |
| 2 | Tạo cấu trúc `homelabops/` + `docker-compose.yml` | `docker compose config` hợp lệ |
| 3 | Chạy `docker compose up -d` — NPM + Homepage | `docker ps` → 2 container Up |
| 4 | Cấu hình NPM Proxy Host: `app1.local` → `homepage:3000` | `curl app1.local` → `<title>Homepage</title>` |
| 5 | Tạo Proxy Host: `npm.local` → `nginx-proxy-manager:81` | `curl npm.local` → title "Nginx Proxy Manager" |
| 6 | Sửa file `hosts` thêm 4 domain ảo | `ping` 4 domain đều → 127.0.0.1 |
| 7 | Ghi nhật ký học tập + commit | commit `c79004b` |

#### Concept đã học (3/5 mục tiêu Tuần 1)

1. **Docker network cô lập + Docker DNS:** Container cùng network mới gọi nhau được, bằng tên service (không phải IP/localhost). NPM forward `app1.local` → `homepage:3000` được vì cùng network `proxy`.
2. **Reverse proxy:** NPM nhận request theo domain, forward đến service đúng. Lợi ích: 1 port (80) ra host, service khác ẩn trong Docker network.
3. **Named volume vs bind mount:** Named volume (`npm_data:/data`) do Docker quản lý, không sửa tay. Bind mount (`./homepage/config:/app/config`) sửa trực tiếp trên host, container thấy ngay.

---

### 2.2. Tuần 2 — Giám sát, log, backup

#### Việc đã làm

| # | Việc | Kết quả xác minh |
|---|------|------------------|
| 1 | Thêm Prometheus + Node Exporter | Cả 2 target `up` trong `/api/v1/targets` |
| 2 | Thêm Grafana + datasource Prometheus | `node_load1` query trả giá trị 0.71 |
| 3 | Import dashboard Node Exporter Full (ID 1860) | Dashboard hiển thị CPU/RAM/disk/network |
| 4 | Tạo Proxy Host cho `prometheus.local` + `grafana.local` | `curl` cả 2 → HTTP 200 |
| 5 | Thêm Loki + Promtail | Promtail push log 7 container lên Loki |
| 6 | Tạo datasource Loki trong Grafana | Query `{container_name="npm"}` trả log NPM |
| 7 | Viết `backup.sh` (5 volume → tar.gz) | Test 5/5 thành công (~445KB) |
| 8 | Tạo Windows Task Scheduler "HomelabOps Backup" | Task Ready, chạy daily 2:00 AM |
| 9 | Viết 3 SOP vận hành | SOP-001, 002, 003 hoàn chỉnh |
| 10 | Ghi nhật ký + commit | commit `e5be656`, `68bcbc4`, `5fe4c65` |

#### Concept đã học (4 concept)

1. **Prometheus pull model + exporter:** Prometheus chủ động gọi đến exporter mỗi 15s (pull), không nhận push. Exporter expose metrics ra `/metrics`. Hệ quả: Prometheus và exporter phải cùng Docker network.
2. **Metrics vs Logs:** Metrics = số đo theo thời gian (CPU, RAM), trả lời "hệ thống có khỏe không?". Logs = sự kiện (error, request), trả lời "chuyện gì đã xảy ra?". Cần cả hai: metrics báo có vấn đề, logs cho biết vấn đề là gì.
3. **Loki vs ELK:** ELK index toàn bộ nội dung log → mạnh nhưng nặng RAM (JVM heap 2-4GB+). Loki chỉ index label → nhẹ (~200MB), query bằng LogQL. Với 8GB RAM, Loki là lựa chọn khả thi.
4. **Bash `set -euo pipefail` + backup volume Docker:** `set -e` thoát khi lỗi, `set -u` lỗi biến chưa định nghĩa, `set -o pipefail` lỗi trong pipe. Backup volume dùng container tạm alpine + `tar czf`.

#### Stack P1 cuối cùng

```
7 container chạy:
├─ npm (Nginx Proxy Manager)      — port 80, 81, 443
├─ homepage                        — port 3000 (nội bộ)
├─ prometheus                      — port 9090
├─ node-exporter                   — port 9100 (nội bộ)
├─ grafana                         — port 3001
├─ loki                            — port 3100 (nội bộ)
└─ promtail                        — (không expose)

4 domain ảo:
├─ app1.local       → homepage
├─ npm.local        → npm admin
├─ grafana.local    → grafana
└─ prometheus.local → prometheus

2 Docker network:
├─ homelabops_proxy      (NPM route domain → service)
└─ homelabops_monitoring (Prometheus scrape + Grafana query + Promtail push)

Backup:
├─ backup.sh (5 volume → tar.gz, retention 7 ngày)
└─ Windows Task Scheduler (daily 2:00 AM)
```

#### 3 SOP đã viết

| SOP | Nội dung |
|-----|----------|
| SOP-001 | Khởi động lại stack sau restart máy |
| SOP-002 | Restore backup volume từ file tar.gz |
| SOP-003 | Thêm service mới vào stack (compose + hosts + NPM + Homepage + backup) |

---

## 3. KẾT QUẢ PROJECT 2 — OPSBRAIN (ĐANG TIẾN HÀNH)

### 3.1. Tuần 3 — Bước đầu: Pipeline RAG offline

#### Việc đã làm

| # | Việc | Kết quả xác minh |
|---|------|------------------|
| 1 | Tắt P1 stack (giải phóng RAM) | `docker ps` trống |
| 2 | Cài Ollama native Windows | `ollama --version` → v0.31.2 |
| 3 | Pull `qwen2.5:3b` (1.9GB) | `ollama list` hiện model |
| 4 | Pull `bge-m3` (1.2GB) | `ollama list` hiện model |
| 5 | Test Qwen2.5:3B trên CPU | Trả lời tiếng Việt OK, ~12s/câu ngắn |
| 6 | Tạo cấu trúc `opsbrain/` + `docker-compose.yml` | `docker compose config` hợp lệ |
| 7 | Cài Open WebUI (Docker) | `docker ps` → open-webui healthy |
| 8 | Kết nối Open WebUI ↔ Ollama | Model `qwen2.5:3b` xuất hiện trong dropdown |
| 9 | Tạo admin account | Đăng nhập thành công |
| 10 | Test chat cơ bản (chưa RAG) | AI trả lời tiếng Việt |

#### Concept đã học

1. **RAG (Retrieval-Augmented Generation):** Tìm tài liệu liên quan → đưa context + câu hỏi cho LLM → trả lời dựa trên context. Khác fine-tuning: RAG thêm tài liệu = upload file, không cần train lại.
2. **Embedding + Vector DB:** Embedding chuyển văn bản thành vector (dãy số). Văn bản giống nhau → vector gần nhau. Vector DB lưu vector, query tìm top-k vector gần nhất = tài liệu liên quan nhất.
3. **Vì sao Ollama native, không Docker:** Ollama native tận dụng CPU trực tiếp, không qua lớp ảo hóa Docker → nhanh hơn. Docker Desktop đã tốn ~4GB RAM, chạy Ollama trong Docker thêm overhead.
4. **Vì sao Qwen2.5:3B:** 3B đủ RAM (~2.5GB), chất lượng chấp nhận được cho Q&A ops. 7B tốt hơn nhưng OOM kill với 8GB RAM.
5. **`host.docker.internal`:** Container Docker gọi Ollama native trên host Windows bằng `host.docker.internal:11434`, không phải `localhost` (localhost trong container = container本身, không có Ollama).

#### Còn lại trong Tuần 3

- [ ] Upload tài liệu P1 (SOP, config, log mẫu) qua Open WebUI UI
- [ ] Test Q&A RAG: "Cách restore backup?", "Service nào đang chạy?"
- [ ] Ghi log học tập Tuần 3

---

## 4. KHÓ KHĂN, TRỞ NGẠI VÀ CÁCH GIẢI QUYẾT

### 4.1. Proxy Host tạo xong nhưng `app1.local` vẫn ra "Default Site"

- **Thời điểm:** Tuần 1, bước cấu hình NPM
- **Triệu chứng:** `curl http://app1.local` trả `<title>Default Site</title>` (trang mặc định NPM), không phải Homepage.
- **Nguyên nhân:** Proxy Host trong NPM admin chưa được save thật sự (chưa bấm nút Save đúng).
- **Cách giải quyết:** Kiểm tra lại **Hosts → Proxy Hosts**, tạo lại với đúng giá trị, bấm **Save**. Verify lại bằng `curl`.
- **Bài học:** Sau khi cấu hình qua UI, luôn verify bằng lệnh (`curl`) xem kết quả đúng kỳ vọng chưa — không tin mù UI.

### 4.2. Lỗi chính tả `granfana.local` trong file hosts

- **Thời điểm:** Tuần 1, bước sửa file hosts
- **Triệu chứng:** `ping grafana.local` → "could not find host".
- **Nguyên nhân gốc (5 Whys):**
  1. Ping không resolve → file hosts sai?
  2. Kiểm tra file hosts → có dòng `granfana.local` (thiếu chữ `a`).
  3. Vì sao sai? Gõ tay chính tả.
  4. Vì sao không phát hiện? Không verify sau khi lưu.
  5. **Gốc:** Không có bước xác minh sau khi sửa file hosts.
- **Cách giải quyết:** Sửa `granfana.local` → `grafana.local`, lưu bằng Notepad as Administrator.
- **Bài học:** Sau khi sửa file hosts, luôn chạy `ping <domain>` để verify từng domain. Đặt quy tắc: **mỗi thay đổi phải verify ngay**.

### 4.3. File hosts không lưu được (thiếu quyền admin)

- **Thời điểm:** Tuần 1, bước sửa file hosts
- **Triệu chứng:** Sửa file hosts xong, lưu, nhưng giá trị cũ vẫn còn.
- **Nguyên nhân:** Notepad không có quyền admin → không ghi được vào `C:\Windows\System32\drivers\etc\hosts` (file hệ thống Windows).
- **Cách giải quyết:** Đóng Notepad → chuột phải → **Run as administrator** → mở file → sửa → Ctrl+S.
- **Bài học:** File hệ thống Windows cần quyền admin. Đây là đặc điểm OS, không phải lỗi.

### 4.4. Loki crash do config field `max_chunk_size` không hợp lệ

- **Thời điểm:** Tuần 2, bước thêm Loki
- **Triệu chứng:** Container Loki restart liên tục, log: `failed parsing config: field max_chunk_size not found in type validation.plain`.
- **Nguyên nhân gốc:** Field `max_chunk_size` trong `limits_config` đã bị deprecated/đổi tên trong Loki 2.9.7. Copy config từ tài liệu cũ version Loki.
- **Cách giải quyết:** Xóa field `max_chunk_size` khỏi `loki-config.yml`, giữ `retention_period` (vẫn hợp lệ). `docker compose up -d loki`.
- **Bài học:** Không copy config blindly từ internet — phải check docs version chính xác. Loki changelog có section deprecated fields. (Ghi vào `troubleshooting.md` TROUBLE-003.)

### 4.5. Git Bash MSYS path conversion làm hỏng backup script

- **Thời điểm:** Tuần 2, bước test backup.sh
- **Triệu chứng:** `tar: can't open 'C:/Program Files/Git/backup/...'` — backup 5/5 thất bại.
- **Nguyên nhân gốc:** Git Bash (MSYS2) tự convert path Unix `/backup/` thành path Windows tuyệt đối `C:/Program Files/Git/backup/`. Container alpine nhận path sai, không tạo file được.
- **Cách giải quyết:** Đặt `MSYS_NO_PATHCONV=1` trước lệnh `docker run` để tắt path conversion. Test lại 5/5 thành công.
- **Bài học:** Git Bash trên Windows convert path tự động — break script Docker. Khi script truyền path Linux vào container, luôn dùng `MSYS_NO_PATHCONV=1` hoặc double-slash `//backup`. (Ghi vào `troubleshooting.md` TROUBLE-004.)

### 4.6. Promtail không resolve `loki` ban đầu

- **Thời điểm:** Tuần 2, bước khởi động Loki + Promtail
- **Triệu chứng:** Promtail log: `error sending batch, will retry` — `dial tcp: lookup loki on 127.0.0.11:53: no such host`.
- **Nguyên nhân gốc:** Loki chưa start xong (đang khởi tạo ingester, join ring) khi Promtail đã thử push. Docker DNS chưa resolve tên `loki` vì container chưa sẵn sàng.
- **Cách giải quyết:** Promtail có cơ chế retry tự động — đợi ~30s, Loki `/ready` trả `ready`, Promtail push thành công ("finished transferring logs written=2121").
- **Bài học:** Service có dependency khởi động (Loki cần thời gian init) → service phụ thuộc (Promtail) phải có retry. Không cần can thiệp thủ công, đợi đủ thời gian.

### 4.7. Open WebUI chờ tải model embedding từ HuggingFace

- **Thời điểm:** Tuần 3, bước cài Open WebUI
- **Triệu chứng:** Container Open WebUI status "unhealthy" kéo dài ~3 phút, log hiện nhiều HTTP request đến `huggingface.co`.
- **Nguyên nhân gốc:** Open WebUI lần đầu khởi động tải model embedding phụ trợ (`all-MiniLM-L6-v2`) từ HuggingFace — cần internet, tốn thời gian.
- **Cách giải quyết:** Đợi ~3-4 phút, model tải xong, container chuyển "healthy", HTTP 200.
- **Bài học:** Service lần đầu khởi động cần tải resource phụ trợ → Kiên nhẫn đợi, check `docker logs` để theo dõi tiến trình. Với môi trường offline (Tuần 4), cần pre-stage model này trước.

---

## 5. TỔNG KẾT KHÓ KHĂN THEO LOẠI

| Loại khó khăn | Số lần | Ví dụ |
|---------------|--------|-------|
| Lỗi cấu hình (config sai, deprecated) | 2 | Loki `max_chunk_size`, Proxy Host chưa save |
| Vấn đề Windows-specific | 3 | File hosts quyền admin, MSYS path conversion, file hosts lỗi chính tả |
| Service startup timing | 2 | Promtail không resolve Loki, Open WebUI tải model |
| **Tổng cộng** | **7** | |

**Nhận xét:** Phần lớn khó khăn đến từ môi trường Windows (file hosts, Git Bash path conversion) và config version mismatch. Các vấn đề đều được phát hiện sớm qua verify (`curl`, `ping`, `docker logs`, `docker ps`) và fix ngay trong phiên.

---

## 6. BÀI HỌC RÚT RA

### 6.1. Quy tắc kỹ thuật

1. **Verify mỗi bước:** chạy lệnh kiểm tra (`curl`, `ping`, `docker ps`, `docker logs`) sau mỗi thay đổi — không tin mù UI.
2. **Pin version cứng:** mọi image/config phải pin version (ví dụ `prom/prometheus:v2.51.1`), không dùng `latest` — để tái tạo được trong môi trường offline.
3. **Check docs version:** không copy config blindly từ internet — phải check docs version chính xác (Loki deprecated field).
4. **MSYS_NO_PATHCONV=1:** Git Bash trên Windows convert path tự động — break script Docker. Luôn dùng khi truyền path Linux vào container.
5. **Service dependency timing:** service phụ thuộc cần retry, đợi service chính sẵn sàng (Promtail ↔ Loki).

### 6.2. Quy tắc làm việc với AI

1. **Đi lại từng bước:** không chạy theo mẫu có sẵn, tự thực hiện từng bước để hiểu concept.
2. **AI giải thích "vì sao":** không chỉ sinh code, phải giải thích lý do chọn phương án (Loki vs ELK, Qwen2.5:3B vs 7B).
3. **Ghi nhật ký ngay:** `progress.md` + `learning-log.md` + `troubleshooting.md` cập nhật cuối phiên.
4. **Commit nhỏ sau mỗi cột mốc:** dễ rollback, theo dõi tiến độ.

### 6.3. Quản lý tài nguyên 8GB RAM

1. **1 project active tại một thời điểm:** P1 và P2 không chạy song song (TROUBLE-002).
2. **Chọn tool nhẹ:** Loki thay ELK, Qwen2.5:3B thay 7B, ChromaDB built-in thay Qdrant riêng.
3. **Giới hạn Docker RAM:** Settings → Resources → 4GB, còn ~4GB cho Windows + Ollama.

---

## 7. TRẠNG THÁ HIỆN TẠI VÀ KẾ HOẠCH TIẾP THEO

### Đã hoàn thành

- ✅ **Tuần 1:** Docker Desktop + NPM + Homepage + reverse proxy + domain ảo
- ✅ **Tuần 2:** Prometheus + Grafana + Loki + Promtail + backup script + cron + 3 SOP
- 🔄 **Tuần 3 (bước đầu):** Ollama + Qwen2.5:3B + bge-m3 + Open WebUI + test chat cơ bản

### Còn lại

- **Tuần 3 (tiếp):** Upload tài liệu P1 vào Open WebUI, test Q&A RAG, ghi log học tập
- **Tuần 4:** RAG tuning (chunk size, top-k, reranking), hybrid search (BM25 + vector), so sánh vector DB, system prompt sysadmin, đóng gói offline (air-gap ready)

### Git commits

```
5fe4c65  tuan 2 hoan thanh, ghi ansible vao backlog, chuan bi tuan 3
68bcbc4  tuan 2: 3 SOP van hanh (restart, restore, add service)
e5be656  tuan 2: prometheus + grafana + loki + promtail + backup script
c79004b  hoan thanh tuan 1: docker desktop + npm + homepage + reverse proxy
e97acff  hoc xong buoi -1
```

---

## 8. KẾT LUẬN

Trong thời gian thực hiện (2 ngày, ~5 giờ làm việc), đã hoàn thành:

1. **Project 1 (HomelabOps):** Stack 7 container Docker với monitoring (Prometheus + Grafana), logging (Loki + Promtail), backup tự động (script + cron), 3 SOP vận hành. Hiểu concept: Docker network, reverse proxy, metrics vs logs, pull model, bash scripting.

2. **Project 2 (OpsBrain):** Bước đầu pipeline RAG offline — Ollama native + Qwen2.5:3B + bge-m3 + Open WebUI. Chat cơ bản hoạt động, sẵn sàng test RAG với tài liệu P1.

3. **Khó khăn:** 7 vấn đề gặp phải, tất cả đã giải quyết. Phần lớn từ môi trường Windows và config version mismatch. Mỗi vấn đề đều được ghi vào `troubleshooting.md` để không lặp lại.

4. **Nguyên tắc offline-first:** Mọi tài nguyên (image, model, config) đã pin version, sẵn sàng đóng gói cho môi trường air-gap (Tuần 4).

Dự án đang đi đúng tiến độ theo `TASKS.md`, sẵn sàng tiếp tục Tuần 3 (RAG Q&A) và Tuần 4 (tuning + đóng gói offline).

---

*Báo cáo lập ngày 2026-07-14*
