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

### TROUBLE-003:

- **Ngày:**
- **Service:**
- **Triệu chứng:**
- **Nguyên nhân gốc:**
- **Cách khắc phục:**
- **Bài học:**
- **Trạng thái:**
