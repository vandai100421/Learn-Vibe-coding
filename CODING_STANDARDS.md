# CODING_STANDARDS.md

# Tiêu chuẩn code

## Nguyên tắc chung

- Mọi file config/script phải có comment ngắn giải thích "vì sao", không chỉ "là gì".
- Tên biến, tên hàm rõ nghĩa, dùng tiếng Anh cho code, tiếng Việt cho comment/tài liệu.
- Không hardcode secret trong file config, luôn dùng biến môi trường (`.env`).
- Ưu tiên đơn giản, dễ hiểu hơn là tối ưu sớm.

## Docker

- Mỗi service một file `docker-compose` rõ ràng, hoặc gộp vào 1 file có comment phân đoạn.
- Dùng named volume thay vì bind mount cho dữ liệu quan trọng (trừ khi cần sửa file trực tiếp).
- Mọi container phải có `restart: unless-stopped`.
- Không expose port không cần thiết ra host; dùng internal network khi có thể.
- Image phải pin version (ví dụ `prom/prometheus:v2.50.0`), không dùng `latest`.

## Bash script (backup, automation)

- Đầu script: `set -euo pipefail` để fail nhanh.
- Có comment giải thích mục đích script ở đầu file.
- Biến ở đầu file, dễ thay đổi.
- Luôn log ra console: `echo "[INFO] ..."` / `echo "[ERROR] ..."`.
- Có bước kiểm tra thư mục tồn tại trước khi ghi/xóa.
- Test script ở chế độ dry-run trước khi chạy thật.

## Python (ingest script P2)

- Dùng virtualenv, ghi dependency vào `requirements.txt`.
- Type hint cho hàm public.
- Docstring ngắn cho hàm chính.
- Xử lý lỗi rõ ràng (try/except có log), không để script crash im lặng.
- Tách logic thành hàm nhỏ, dễ test.

## Config file (YAML)

- Có comment giải thích từng mục quan trọng.
- Validate config sau khi sửa (ví dụ `docker compose config`).
- Không commit file `.env` thật, chỉ commit `.env.example`.

## Tài liệu (SOP, cheatsheet)

- Dùng Markdown.
- Cấu trúc: Mục đích → Điều kiện tiên quyết → Các bước → Xác minh → Troubleshooting.
- Có ví dụ lệnh cụ thể, không chỉ mô tả chung chung.

## Git

- Commit message ngắn, mô tả hành động: "add backup script", "fix nginx config".
- Không commit file lớn, secret, hoặc thư mục `node_modules`/`__pycache__`.
- `.gitignore` đầy đủ: `.env`, `backups/`, `*.log`, `chromadb/data`, `ollama/models`.
