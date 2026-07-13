# resource-budget.md — Theo dõi tài nguyên (RAM/disk)

> Mục đích: track RAM từng service vì 8GB rất eo hẹp. Quyết định bật/tắt service.
> Nguyên tắc: đo thực tế bằng `docker stats`, không tin ước tính. Cập nhật khi thay đổi stack.

## Tổng quan tài nguyên máy

- **RAM vật lý:** 8GB
- **Windows + process nền:** ~2.5-3GB (sau boot, trước Docker)
- **Dành cho Docker Desktop:** ~3-4GB (đã giới hạn trong Settings)
- **Dành cho Ollama (P2, native):** ~2-3GB
- **RAM còn dư (buffer):** ~1-1.5GB

> Quy tắc vàng: RAM thực dùng ≤ 7GB. Để 1GB buffer tránh Windows swap/kill process.

## Bảng RAM theo service (P1 — HomelabOps)

| Service | RAM ước tính | RAM thực đo | Khi nào bật | Trạng thái | Ghi chú |
|---|---|---|---|---|---|
| Docker Desktop (engine) | 800MB | (đo) | luôn (khi dùng P1) | active | Cài đặt nền |
| Nginx Proxy Manager | 100MB | (đo) | luôn | active | Cần để truy cập service khác |
| Homepage | 50MB | (đo) | khi xem dashboard | optional | Tắt được nếu không xem |
| Prometheus | 150MB | (đo) | khi học monitoring | active | Lưu metrics 15 ngày |
| Node Exporter | 20MB | (đo) | khi học monitoring | active | Rất nhẹ |
| Grafana | 150MB | (đo) | khi xem dashboard | optional | Tắt được nếu không xem |
| Loki | 150MB | (đo) | khi học logging | optional | |
| Promtail | 50MB | (đo) | khi học logging | optional | |
| Uptime Kuma | 100MB | (đo) | Tier 3 | optional | Bỏ nếu hết RAM |

**Cách đo thực tế:**
```bash
docker stats --no-stream --format "table {{.Name}}\t{{.MemUsage}}" 2>nul
```
→ điền cột "RAM thực đo" sau khi chạy stack 5-10 phút.

## Bảng RAM theo service (P2 — OpsBrain)

| Service | RAM ước tính | RAM thực đo | Khi nào bật | Trạng thái | Ghi chú |
|---|---|---|---|---|---|
| Ollama (Qwen2.5:3B Q4) | 2.5GB | (đo) | khi chat | active | Native Windows, không qua Docker |
| Ollama (bge-m3 embed) | 1GB | (đo) | khi ingest/query | active | Load khi cần |
| Open WebUI | 300MB | (đo) | khi chat | active | Qua Docker |
| ChromaDB | 200MB | (đo) | luôn (khi P2 active) | active | Qua Docker hoặc built-in Open WebUI |

**Cách đo Ollama (native, không qua Docker):**
```bash
# Windows Task Manager → tab Details → sort by Memory
# Hoặc PowerShell:
Get-Process ollama* | Select-Object Name, WorkingSet64
```

## Kịch bản bật/tắt khuyến nghị (8GB)

### Kịch bản A: Chỉ học P1 (Tuần 1-2)

```
Bật: Docker Desktop + NPM + Prometheus + Node Exporter + Grafana
Tắt: Ollama, Open WebUI, ChromaDB
RAM dự kiến: ~3.5GB (an toàn)
```

### Kịch bản B: Chỉ học P2 (Tuần 3-4)

```
Bật: Ollama + Open WebUI + ChromaDB
Tắt: Toàn bộ P1 stack (docker compose stop)
RAM dự kiến: ~4GB + Windows ~3GB = 7GB (vừa)
```

### Kịch bản C: CẢNH BÁO — chạy cả hai

```
KHÔNG KHUYẾN NGHỊ. RAM dự kiến: ~7.5GB+ → Windows swap, Ollama bị kill.
Nếu bắt buộc: tắt Loki/Promtail/Uptime Kuma (P1 optional), dùng Qwen2.5:3B (không 7B).
```

## Disk usage (theo dõi định kỳ)

| Mục | Dung lượng ước tính | Dung lượng thực | Ghi chú |
|---|---|---|---|
| Docker images P1 | ~2GB | (đo) | `docker images` |
| Docker volumes P1 | ~500MB | (đo) | `docker system df -v` |
| Ollama models | ~3GB | (đo) | `~/.ollama/models` |
| ChromaDB data | ~100MB | (đo) | Tùy số tài liệu |
| Backup | (đo) | | `homelabops/backups/` |

**Cách đo:**
```bash
docker system df -v
```
