# Project 1 – Internal Work Analytics

## Tổng quan

Internal Work Analytics là công cụ hỗ trợ tự động tổng hợp, phân tích và thống kê dữ liệu công việc từ nhiều nguồn khác nhau nhằm giảm thời gian tìm kiếm, thống kê và lập báo cáo.

Dự án tập trung giải quyết các công việc lặp lại trong quá trình tổng hợp dữ liệu nghiệp vụ, giúp người dùng nhanh chóng tạo báo cáo theo tháng, quý hoặc năm.

---

# 1. Bối cảnh

Trong quá trình làm việc, tôi thường xuyên phải quản lý số lượng lớn dữ liệu như:

- Danh sách nhu cầu ảnh
- Báo cáo công việc
- File Excel
- File Word
- File PDF
- Nhật ký công việc
- SOP
- Tài liệu nội bộ

Các dữ liệu được lưu trữ rời rạc ở nhiều thư mục và nhiều định dạng khác nhau.

Khi lãnh đạo yêu cầu thống kê, việc tìm kiếm và tổng hợp hiện nay vẫn thực hiện thủ công nên mất nhiều thời gian và dễ sai sót.

---

# 2. Vấn đề thực tế

Ví dụ các yêu cầu thường gặp:

- Có bao nhiêu nhu cầu ảnh đã được đáp ứng đúng hạn trong Quý I?
- Có bao nhiêu nhu cầu ảnh bị trễ hạn trong 2 quý đầu năm?
- Có bao nhiêu yêu cầu chưa được xử lý?
- Đơn vị nào có tỷ lệ hoàn thành thấp nhất?
- So sánh kết quả giữa Quý I và Quý II.

Hiện nay các thống kê trên đều phải thực hiện thủ công.

---

# 3. Mục tiêu

Xây dựng công cụ giúp:

- Tự động đọc dữ liệu.
- Chuẩn hóa dữ liệu.
- Thống kê theo điều kiện.
- Sinh báo cáo.
- Xuất Excel hoặc PDF.

---

# 4. Người dùng

Người dùng chính:

- Cá nhân tôi.

Có thể mở rộng:

- Quản trị hệ thống.
- Nhân viên kỹ thuật.
- Bộ phận tổng hợp.
- Người quản lý.

---

# 5. MVP

## Input

- Excel
- CSV
- SQLite
- Folder chứa tài liệu

Điều kiện thống kê:

- Tháng
- Quý
- Năm
- Đơn vị
- Trạng thái
- Loại công việc

---

## Processing

- Quét dữ liệu
- Chuẩn hóa dữ liệu
- Kiểm tra dữ liệu
- Phân loại
- Thống kê
- Tính KPI
- Sinh báo cáo

---

## Output

- Dashboard
- Báo cáo Excel
- Báo cáo PDF
- CSV
- Biểu đồ thống kê

---

# 6. Công nghệ dự kiến

Frontend

- React

Backend

- NodeJS
- Express

Database

- SQLite

Chart

- Chart.js

---

# 7. Tiêu chí hoàn thành

- Đọc được dữ liệu.
- Thống kê theo điều kiện.
- Xuất báo cáo.
- Giao diện dễ sử dụng.
- Hoạt động offline.

---

# 8. Hướng phát triển

Project này sẽ tạo ra Business Database phục vụ cho Project 2.