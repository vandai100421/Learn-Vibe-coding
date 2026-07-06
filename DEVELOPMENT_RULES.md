# DEVELOPMENT_RULES.md

# Quy tắc làm việc với AI

## Triết lý học tập

- Trọng tâm: hiểu concept, không chỉ chạy được code.
- Khi AI đề xuất giải pháp, luôn hỏi "vì sao chọn cách này?".
- So sánh phương án thay thế trước khi quyết định.
- Ghi lại những concept đã học vào nhật ký học tập (`docs/learning-log.md`).

## Quy trình làm việc với AI

1. **Mô tả yêu cầu rõ ràng** bằng tiếng Việt trước khi nhờ AI code.
2. **Cung cấp context đầy đủ**: file liên quan, cấu trúc dự án, ràng buộc (offline, tài nguyên).
3. **AI phân tích + lập kế hoạch** trước, người dùng duyệt mới vào code.
4. **Kiểm tra kết quả**: chạy lệnh, xem output, không tin mù.
5. **Commit nhỏ, thường xuyên** sau mỗi bước chạy đúng.

## Khi AI sai hoặc không hiểu

- Không cố "ép" AI sửa từng li từng tí; nạp lại context rõ hơn.
- Tách bài toán lớn thành việc nhỏ để AI xử lý từng phần.
- Ghi lại lỗi và cách khắc phục vào `docs/troubleshooting.md`.

## Nguyên tắc offline-first

- Mọi tài nguyên (image, model, package) phải có cách pre-stage.
- Không phụ thuộc internet để chạy hoặc build (sau giai đoạn pre-stage).
- Lưu ý version pin cứng để tái tạo được trong môi trường nội bộ.

## Nguyên tắc tận dụng có sẵn

- Không tự code thứ đã có sẵn tốt: Open WebUI, AnythingLLM, Grafana...
- Tự code phần: ingest script, config, integration, automation.
- Nếu tự code, phải giải thích được vì sao không dùng có sẵn.

## Giới hạn phạm vi

- Không mở rộng scope ngoài TASKS.md nếu chưa hoàn thành mục tiêu tuần.
- Muốn thêm tính năng: ghi vào `docs/backlog.md`, làm sau.
- Ưu tiên hoàn thành MVP theo timeline đã chốt.

## An toàn dữ liệu

- Không hardcode secret, API key, mật khẩu vào file.
- Dùng `.env` và `.env.example`.
- Không commit file backup, model, dữ liệu lớn.
