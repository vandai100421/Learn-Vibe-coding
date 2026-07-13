# troubleshooting.md — Lỗi đã fix + bài học

> Mục đích: ghi lại lỗi đã gặp, nguyên nhân GỐC, cách khắc phục, và bài học rút ra.
> Nguyên tắc: chỉ ghi khi đã fix xong. Không ghi lỗi đang mở (dùng `issues.md`).
> Quan trọng: phần **Nguyên nhân gốc** phải đào sâu — hỏi "vì sao?" 3-5 lần (5 Whys).

## Template

```
### TROUBLE-XXX: [Tên lỗi ngắn]
- **Ngày:** YYYY-MM-DD
- **Service:** tên container/service liên quan
- **Triệu chứng:** thấy gì? output/lỗi cụ thể
- **Nguyên nhân gốc:** vì sao thật sự xảy ra (sau 5 Whys)
- **Cách khắc phục:** lệnh/bước cụ thể đã làm
- **Bài học:** quy tắc/thói quen để không lặp lại
- **Trạng thái:** Closed
```

---

### TROUBLE-001: (ví dụ mẫu — Prometheus không scrape được Node Exporter)

- **Ngày:** 2026-07-15
- **Service:** prometheus, node-exporter
- **Triệu chứng:** Truy cập Prometheus → Status → Targets, `node-exporter` hiện `DOWN`. Log Prometheus: `connection refused`.
- **Nguyên nhân gốc:** Node Exporter và Prometheus nằm khác Docker network. Node Exporter ở `monitoring` network, Prometheus ở `proxy` network → không thấy nhau. Gốc thật sự: khi viết compose chưa nghĩ "pull model" của Prometheus cần cùng network với exporter.
- **Cách khắc phục:**
  ```yaml
  # Thêm node-exporter vào network mà prometheus đang dùng
  services:
    node-exporter:
      networks:
        - monitoring   # phải trùng network với prometheus
  ```
  Sau đó: `docker compose up -d prometheus node-exporter`.
- **Bài học:** Prometheus pull model → cần exporter và Prometheus cùng network. Khi thêm service mới, luôn kiểm tra `networks:` trong compose.
- **Trạng thái:** Closed

---

### TROUBLE-002: (ví dụ mẫu — Ollama chạy hết RAM, Windows kill process)

- **Ngày:** 2026-07-22
- **Service:** ollama
- **Triệu chứng:** Chat trong Open WebUI treo giữa chừng, Ollama process biến mất. Windows Event Viewer: "Application terminated due to low memory".
- **Nguyên nhân gốc:** Đang chạy Qwen2.5:7B (~5GB) + Open WebUI + ChromaDB + Docker Desktop stack P1 cùng lúc → vượt 8GB.
- **Cách khắc phục:** Tắt P1 stack (`docker compose stop`) khi dùng P2. Hoặc đổi về `qwen2.5:3b`.
- **Bài học:** 8GB không chạy được cả 2 project song song. Kiểm tra `resource-budget.md` trước khi bật service. Quy tắc: 1 project active tại một thời điểm.
- **Trạng thái:** Closed

---

### TROUBLE-003: Loki crash do config field `max_chunk_size` không hợp lệ

- **Ngày:** 2026-07-14
- **Service:** loki
- **Triệu chứng:** Container Loki restart liên tục, log: `failed parsing config: field max_chunk_size not found in type validation.plain`.
- **Nguyên nhân gốc:** Field `max_chunk_size` trong `limits_config` đã bị deprecated/đổi tên trong Loki 2.9.7. Mình copy từ tài liệu cũ版本的Loki.
- **Cách khắc phục:** Xóa field `max_chunk_size` khỏi `loki-config.yml`, giữ `retention_period` (vẫn hợp lệ). `docker compose up -d loki`.
- **Bài học:** Không copy config blindly từ internet — phải check docs version chính xác. Loki changelog có section deprecated fields.
- **Trạng thái:** Closed

---

### TROUBLE-004: Git Bash MSYS path conversion làm hỏng backup script

- **Ngày:** 2026-07-14
- **Service:** backup.sh (chạy qua Git Bash)
- **Triệu chứng:** `tar: can't open 'C:/Program Files/Git/backup/...'` — backup 5/5 thất bại.
- **Nguyên nhân gốc:** Git Bash (MSYS2) tự convert path Unix `/backup/` thành path Windows tuyệt đối `C:/Program Files/Git/backup/`. Container alpine nhận path sai, không tạo file được.
- **Cách khắc phục:** Đặt `MSYS_NO_PATHCONV=1` trước lệnh `docker run` để tắt path conversion.
- **Bài học:** Git Bash trên Windows convert path tự động — break script Docker. Khi script truyền path Linux vào container, luôn dùng `MSYS_NO_PATHCONV=1` hoặc double-slash `//backup`.
- **Trạng thái:** Closed

---

### TROUBLE-005:
