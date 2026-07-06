# Project 2 – Internal AI Assistant

## Tổng quan

Internal AI Assistant là trợ lý AI hoạt động hoàn toàn offline, hỗ trợ người dùng khai thác dữ liệu công việc bằng ngôn ngữ tự nhiên.

Hệ thống kế thừa dữ liệu từ Project 1 để trả lời câu hỏi, thống kê dữ liệu và hỗ trợ đọc hiểu tài liệu.

---

# 1. Bối cảnh

Sau khi dữ liệu đã được chuẩn hóa trong Project 1, người dùng vẫn phải tự tìm kiếm và đọc dữ liệu.

Mục tiêu của Project 2 là giúp người dùng chỉ cần đặt câu hỏi bằng ngôn ngữ tự nhiên.

---

# 2. Vấn đề

Ví dụ:

- Có bao nhiêu nhu cầu ảnh trễ hạn?
- Đơn vị nào xử lý chậm nhất?
- So sánh Quý I và Quý II.
- Tóm tắt SOP Backup.
- Tìm hướng dẫn triển khai Docker.

---

# 3. Mục tiêu

Xây dựng trợ lý AI có khả năng:

- Tìm kiếm dữ liệu.
- Đọc tài liệu.
- Tóm tắt.
- Thống kê.
- Giải thích.

Hoạt động hoàn toàn offline.

---

# 4. Người dùng

- Cá nhân tôi.
- Quản trị hệ thống.
- Lập trình viên.
- Nhân viên kỹ thuật.

---

# 5. MVP

## Input

Người dùng nhập câu hỏi.

Ví dụ:

- Có bao nhiêu nhu cầu ảnh đúng hạn?
- Đơn vị nào có nhiều yêu cầu nhất?
- Tóm tắt SOP.
- Giải thích Docker Compose.

---

## Processing

- Phân tích câu hỏi.
- Tìm dữ liệu liên quan.
- Tạo Context.
- Gửi Context tới Local LLM.
- Sinh câu trả lời.

---

## Output

- Câu trả lời.
- Thống kê.
- Biểu đồ.
- Danh sách tài liệu tham khảo.
- Trích dẫn nguồn.

---

# 6. Công nghệ dự kiến

Frontend

- React

Backend

- NodeJS

AI

- Ollama

Model

- Qwen Coder

Database

- SQLite

---

# 7. Tiêu chí hoàn thành

- Chat với AI.
- Tìm kiếm dữ liệu.
- Trả lời bằng tiếng Việt.
- Hiển thị nguồn.
- Hoạt động offline.

---

# 8. Hướng phát triển

Project này sẽ trở thành nền tảng cho Personal AI Engineer.