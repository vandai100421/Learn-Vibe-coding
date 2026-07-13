# Project 2 — OpsBrain: Trợ lý AI cho quản trị hệ thống (RAG offline)

## Tổng quan

OpsBrain là trợ lý AI hoạt động hoàn toàn offline, hỗ trợ người quản trị hệ thống tra cứu tài liệu, tóm tắt SOP, phân tích log và trả lời câu hỏi vận hành bằng ngôn ngữ tự nhiên (tiếng Việt).

Hệ thống kế thừa dữ liệu từ Project 1 (SOP, runbook, config, log mẫu) làm nguồn tri thức, tận dụng RAG pipeline built-in của Open WebUI thay vì tự code từ đầu, tập trung thời gian vào việc học concept và tinh chỉnh chất lượng.

**Scope được tinh chỉnh cho 4 tuần, phân tầng ưu tiên.**

---

# 1. Bối cảnh

Sau khi Project 1 hoàn thành, tôi có một bộ tài liệu vận hành (SOP, config, log mẫu). Tuy nhiên:

- Khi gặp sự cố, vẫn phải tra cứu thủ công
- Log lỗi khó diễn giải nếu chưa từng gặp
- Cần tra cứu lệnh Linux nhanh mà không có internet
- Cần tóm tắt tài liệu dài (PDF SOP, cheatsheet)

Mục tiêu Project 2 là xây trợ lý AI offline giải quyết các nhu cầu trên.

---

# 2. Vấn đề

Ví dụ câu hỏi thực tế:

- "Cách restore backup cho service X?"
- "Service nào đang tốn nhiều RAM nhất?"
- "Log error này nghĩa là gì, xử lý thế nào?"
- "Tóm tắt SOP backup."
- "Khác biệt giữa RAG và fine-tuning?"
- "Lệnh Linux kiểm tra port đang mở?"

---

# 3. Mục tiêu

Xây trợ lý AI có khả năng:

- Tìm kiếm tài liệu nội bộ (SOP, runbook, config)
- Tóm tắt tài liệu dài
- Phân tích log, giải thích lỗi
- Trả lời bằng tiếng Việt
- Trích dẫn nguồn tài liệu
- Hoạt động hoàn toàn offline

Trọng tâm: học concept local LLM, embedding, vector DB, RAG pipeline (hybrid search, reranking) và đóng gói offline. Tận dụng RAG built-in của Open WebUI thay vì tự code ingest pipeline.

---

# 4. Người dùng

Người dùng chính:

- Cá nhân tôi (học sysadmin, vận hành Project 1).

Có thể mở rộng:

- Nhóm vận hành nội bộ.

---

# 5. MVP (phân tầng ưu tiên)

## Tier 1 — Bắt buộc (Tuần 3)

### Input

Tài liệu tri thức (từ Project 1), upload trực tiếp qua Open WebUI:

- SOP, runbook
- Config mẫu (Nginx, Prometheus, Docker)
- Cheatsheet Linux
- Log mẫu có nhãn lỗi

Câu hỏi người dùng:

- Tiếng Việt, ngôn ngữ tự nhiên

### Processing (tận dụng built-in RAG)

- Upload tài liệu qua UI Open WebUI (không cần tự code ingest script)
- Open WebUI tự động: đọc → chunk → embed (bge-m3) → lưu vector DB
- Query: phân tích câu hỏi → embed → hybrid search (BM25 + vector) → top-k context + reranking
- Sinh: gửi context + câu hỏi tới local LLM → trả lời + trích nguồn

### Output

- Câu trả lời tiếng Việt
- Danh sách tài liệu tham khảo
- Trích dẫn nguồn

## Tier 2 — Nên có (Tuần 4)

- So sánh hiệu năng giữa 2 vector DB: ChromaDB vs Qdrant
- Bật hybrid search (BM25 + vector) + reranking trong Open WebUI
- Thử Qwen2.5:7B nếu RAM dư (cân nhắc trade-off tốc độ/chất lượng), mặc định dùng 3B

## Tier 3 — Tùy chọn (chỉ làm nếu Tier 1+2 xong sớm)

- Đóng gói offline: model + image + cache sẵn sàng mang vào môi trường nội bộ
- Log analysis chuyên sâu (paste log → AI giải thích + đề xuất xử lý)
- Thử PGVector nếu đã có PostgreSQL sẵn (chỉ khi muốn so sánh thêm)

---

# 6. Công nghệ dự kiến

### Local LLM

- Ollama
- Qwen2.5:3B (model chính — phù hợp 8GB RAM, chạy được trên CPU)
- Qwen2.5:7B (thử nếu RAM dư, chất lượng tốt hơn nhưng chậm hơn)
- Trade-off: 3B đủ học concept RAG, chất lượng tiếng Việt trung bình-khá; 7B tốt hơn nhưng chật RAM

### Embedding

- bge-m3

### Vector Database (chỉ so sánh 2)

- ChromaDB (mặc định của Open WebUI)
- Qdrant (thử so sánh hiệu năng)
- PGVector (chỉ nếu còn thời gian và đã có PostgreSQL)

### Frontend + RAG engine

- Open WebUI (built-in RAG: hybrid search + reranking)

### Tương tác AI khi code

- OpenCode + GLM 5.2 (trong thời gian khóa học)

---

# 7. Tiêu chí hoàn thành

**Bắt buộc (Tier 1):**

- Chat được với AI bằng tiếng Việt.
- Trả lời dựa trên tài liệu nội bộ đã upload.
- Hiển thị nguồn tài liệu tham khảo.
- Hoạt động offline hoàn toàn (sau khi pre-stage tài nguyên).

**Nên có (Tier 2):**

- Hiểu và bật được hybrid search (BM25 + vector) + reranking trong Open WebUI.
- Đã thử so sánh 2 vector DB (ChromaDB vs Qdrant).
- Hiểu concept RAG pipeline end-to-end (không chỉ chạy được).

**Tùy chọn (Tier 3):**

- Đã đóng gói offline: model + image + cache sẵn sàng mang vào môi trường nội bộ.
- Phân tích log chuyên sâu.

---

# 8. Hướng phát triển

**Version 1 (trong khóa)**

- AI Search / Q&A trên tài liệu ops (built-in RAG)

**Version 2**

- Log analysis chuyên sâu

**Version 3**

- Tích hợp với Project 1: hỏi trạng thái hạ tầng realtime

**Version 4**

- Agent: tự thực thi lệnh vận hành

**Version 5**

- Multi-source: code, tài liệu học tập, quy trình

**Version 6**

- Enterprise AI Assistant nội bộ