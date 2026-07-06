# ARCHITECTURE.md

# Kiến trúc tổng thể

## Tổng quan

Hai project bổ trợ nhau: P1 tạo hạ tầng + dữ liệu, P2 tiêu thụ dữ liệu đó làm tri thức.

```
Project 1 (HomelabOps)            Project 2 (OpsBrain)
┌─────────────────────┐           ┌─────────────────────┐
│  Docker Engine       │           │  Open WebUI (FE +   │
│  ├─ Nginx Proxy      │           │   RAG engine)       │
│  ├─ Homepage         │           │  ├─ Chat UI         │
│  ├─ Prometheus       │  SOP,     │  ├─ Upload tài liệu │
│  ├─ Grafana          │  config,  │  ├─ Hybrid search   │
│  ├─ Node Exporter    │  log ─────►│  │  (BM25+vector)  │
│  ├─ Loki + Promtail  │  upload   │  └─ Reranking       │
│  ├─ Uptime Kuma (opt)│           │                     │
│  ├─ Backup (cron)    │           │  Ollama (LLM)       │
│  └─ Ansible playbook │           │  └─ Qwen2.5:32B     │
└─────────────────────┘           │                     │
                                  │  Vector DB (chọn 1) │
                                  │  ├─ ChromaDB (mặc định)
                                  │  ├─ Qdrant          │
                                  │  └─ PGVector        │
                                  │  + bge-m3 embed     │
                                  └─────────────────────┘
```

---

## Project 1 — HomelabOps

### Kiến trúc dịch vụ

```
Internet / Local
     │
     ▼
Nginx Proxy Manager (port 80/443)
     │
     ├─► Homepage        (dashboard)
     ├─► Grafana         (monitoring UI)
     ├─► Uptime Kuma     (uptime UI)
     └─► Loki            (log query UI)

Docker internal network:
     ├─ Prometheus  ◄── Node Exporter (metrics)
     ├─ Loki        ◄── Promtail (log từ container)
     └─ Backup volume (cron + bash)

Ansible (host):
     └─ Playbook deploy service (Infrastructure as Code)
```

### Thành phần chính

| Thành phần | Vai trò | Port |
|-----------|---------|------|
| Nginx Proxy Manager | Reverse proxy, SSL, định tuyến domain ảo | 80, 443 |
| Homepage | Dashboard trung tâm | 3000 |
| Prometheus | Thu thập metrics | 9090 |
| Node Exporter | Metrics hệ thống | 9100 |
| Grafana | Dashboard trực quan | 3001 |
| Loki | Lưu log tập trung | 3100 |
| Promtail | Thu thập log container | - |
| Uptime Kuma (tùy chọn) | Cảnh báo uptime | 3002 |
| Ansible | Deploy service tự động (IaC) | - |

### Cấu trúc thư mục đề xuất

```
homelabops/
├─ docker-compose.yml
├─ .env
├─ nginx-proxy/
├─ homepage/
├─ prometheus/
│   └─ prometheus.yml
├─ grafana/
│   └─ dashboards/
├─ loki/
├─ promtail/
│   └─ promtail-config.yml
├─ uptime-kuma/
├─ backup/
│   ├─ backup.sh
│   └─ /backups/
└─ docs/
    └─ SOP/
```

---

## Project 2 — OpsBrain

### Kiến trúc RAG pipeline

```
Người dùng
   │
   │  câu hỏi tiếng Việt
   ▼
Open WebUI (Frontend + RAG engine built-in)
   │
   ▼
Ollama (LLM: Qwen2.5:32B)
   │
   │  cần context
   ▼
Hybrid Search (BM25 + vector) + Reranking
   │
   │  query embedding
   ▼
bge-m3 (Embedding model)
   │
   │  so khớp vector
   ▼
Tài liệu tri thức (upload trực tiếp từ P1)
```

### Luồng ingest (offline-ready, dùng built-in)

```
SOP, config, log (P1)
   │
   ▼
Open WebUI upload UI
   ├─ Đọc file (Tika/Docling loader)
   ├─ Chunk (theo token, có overlap)
   ├─ Embed qua bge-m3
   └─ Lưu vào vector DB (ChromaDB/Qdrant/PGVector)
```

### Luồng query

```
Câu hỏi → embed (bge-m3) → hybrid search (BM25+vector, top-k)
       → reranking → context + câu hỏi → Ollama (Qwen2.5:32B)
       → trả lời + trích nguồn → Open WebUI
```

### Thành phần

| Thành phần | Vai trò | Port |
|-----------|---------|------|
| Open WebUI | Frontend chat + RAG engine built-in | 8080 |
| Ollama | Chạy LLM local | 11434 |
| Vector DB (chọn 1) | ChromaDB (mặc định) / Qdrant / PGVector | 8000 |
| bge-m3 | Embedding model | - |

### Cấu trúc thư mục đề xuất

```
opsbrain/
├─ docker-compose.yml
├─ .env
├─ ollama/
│   └─ models/ (Qwen2.5:32B, bge-m3)
├─ open-webui/
│   └─ data/ (vector DB + tài liệu đã upload)
├─ /knowledge/ (tài liệu gốc để upload vào Open WebUI)
│   ├─ sop/
│   ├─ config/
│   ├─ cheatsheet/
│   └─ logs/
└─ docs/
    └─ offline-package/
```

---

## Tích hợp P1 → P2

```
HomelabOps (P1)                   OpsBrain (P2)
├─ docs/SOP/          ──── upload ────►  Open WebUI knowledge
├─ */config.yml       ──── upload ────►  Open WebUI knowledge
├─ logs/*.log         ──── upload ────►  Open WebUI knowledge
└─ cheatsheet.md      ──── upload ────►  Open WebUI knowledge
```

P2 có thể trả lời các câu hỏi về P1: "Cách backup?", "Config Nginx thế nào?", "Log này nghĩa gì?".

---

## Đóng gói offline (air-gap ready)

Tất cả tài nguyên phải pre-stage trước khi vào môi trường nội bộ:

| Tài nguyên | Cách đóng gói |
|-----------|---------------|
| Ollama models | `ollama pull` + sao chép `~/.ollama/models` |
| Docker images | `docker save` → tar file |
| Python packages | `pip download` → wheel cache |
| bge-m3 model | Tải weights về local |
| ChromaDB data | Sao chép thư mục `chromadb/data` |
| Tài liệu tri thức | Đã local sẵn |

→ Sau khi đóng gói, toàn bộ P2 có thể triển khai không cần internet.
