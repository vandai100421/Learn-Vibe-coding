# Project 2 — OpsBrain: Trợ lý AI cho quản trị hệ thống (RAG offline)

## Tổng quan

OpsBrain là trợ lý AI hoạt động hoàn toàn offline, hỗ trợ người quản trị hệ thống tra cứu tài liệu, tóm tắt SOP, phân tích log và trả lời câu hỏi vận hành bằng ngôn ngữ tự nhiên (tiếng Việt).

Hệ thống kế thừa dữ liệu từ Project 1 (SOP, runbook, config, log mẫu) làm nguồn tri thức, tận dụng RAG pipeline built-in của Open WebUI thay vì tự code từ đầu, tập trung thời gian vào việc học concept và tinh chỉnh chất lượng.

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

# 5. MVP

## Input

Tài liệu tri thức (từ Project 1), upload trực tiếp qua Open WebUI:

- SOP, runbook
- Config mẫu (Nginx, Prometheus, Docker)
- Cheatsheet Linux
- Log mẫu có nhãn lỗi

Câu hỏi người dùng:

- Tiếng Việt, ngôn ngữ tự nhiên

## Processing (tận dụng built-in RAG)

- Upload tài liệu qua UI Open WebUI (không cần tự code ingest script)
- Open WebUI tự động: đọc → chunk → embed (bge-m3) → lưu vector DB
- Query: phân tích câu hỏi → embed → hybrid search (BM25 + vector) → top-k context + reranking
- Sinh: gửi context + câu hỏi tới local LLM → trả lời + trích nguồn
- (Tùy chọn) Log analysis: paste log → AI giải thích + đề xuất xử lý

## Output

- Câu trả lời tiếng Việt
- Danh sách tài liệu tham khảo
- Trích dẫn nguồn
- (Tùy chọn) Phân tích log

---

# 6. Công nghệ dự kiến

Local LLM

- Ollama
- Qwen2.5:32B (model chính)
- Qwen2.5:14B (dự phòng)

Embedding

- bge-m3

Vector Database (học so sánh, chọn 1)

- ChromaDB (mặc định của Open WebUI)
- Qdrant (thử so sánh hiệu năng)
- PGVector (thử nếu đã có PostgreSQL)

Frontend + RAG engine

- Open WebUI (built-in RAG: hybrid search + reranking)

Tương tác AI khi code

- OpenCode + GLM 5.2 (trong thời gian khóa học)

---

# 7. Tiêu chí hoàn thành

- Chat được với AI bằng tiếng Việt.
- Trả lời dựa trên tài liệu nội bộ đã upload.
- Hiểu và bật được hybrid search (BM25 + vector) + reranking trong Open WebUI.
- Đã thử so sánh ít nhất 2 vector DB (ChromaDB vs Qdrant/PGVector).
- Hiển thị nguồn tài liệu tham khảo.
- Hoạt động offline hoàn toàn (sau khi pre-stage tài nguyên).
- Đã đóng gói offline: model + image + cache sẵn sàng mang vào môi trường nội bộ.
- Hiểu concept RAG pipeline end-to-end (không chỉ chạy được).

---

# 8. Hướng phát triển

Version 1 (trong khóa)

- AI Search / Q&A trên tài liệu ops (built-in RAG)

Version 2

- Log analysis chuyên sâu

Version 3

- Tích hợp với Project 1: hỏi trạng thái hạ tầng realtime

Version 4

- Agent: tự thực thi lệnh vận hành

Version 5

- Multi-source: code, tài liệu học tập, quy trình

Version 6

- Enterprise AI Assistant nội bộ
