# learning-log.md — Nhật ký học tập

> Mục đích: ghi lại concept đã hiểu theo TASKS.md (3-5 concept/tuần).
> Nguyên tắc: ghi bằng lời mình hiểu, không copy-paste. Nếu giải thích được cho người khác = mức 5.

## Mức hiểu

- `1` — Nghe qua, biết tồn tại
- `2` — Hiểu khái niệm, chưa dùng được
- `3` — Dùng được theo hướng dẫn
- `4` — Dùng độc lập, troubleshoot được
- `5` — Giải thích được cho người khác

## Template mỗi entry

```
### [Tuần X] Concept: [tên]
- **Ngày:** YYYY-MM-DD
- **Mức hiểu:** 1-5
- **Giải thích bằng lời mình:** 2-3 câu
- **Ví dụ cụ thể đã làm:** lệnh/file liên quan
- **Câu hỏi còn lại:** (nếu có)
- **Tài liệu tham khảo:** link/file
```

---

## Tuần 1 — P1: Nền tảng hạ tầng Docker

### [Tuần 1] Concept: Docker network (bridge vs internal)

- **Ngày:** 2026-07-14
- **Mức hiểu:** 3
- **Giải thích bằng lời mình:** Docker mặc định tạo bridge network cho container giao tiếp. Mỗi network cô lập — container khác network không thấy nhau. Expose port chỉ để host truy cập, không cần cho container-container. Container gọi nhau bằng **tên service** (Docker DNS resolve), không phải IP hay localhost.
- **Ví dụ cụ thể đã làm:** NPM và Homepage cùng network `proxy` (compose `homelabops/docker-compose.yml:51`). NPM forward `app1.local` → `homepage:3000` được vì Docker DNS resolve tên `homepage` thành IP container. Nếu khác network → NPM không thấy `homepage` → 502 Bad Gateway.
- **Câu hỏi còn lại:** Khi nào dùng `internal: true`? Có chặn internet ra không?
- **Tài liệu tham khảo:** `homelabops/docker-compose.yml`, Docker docs network.

### [Tuần 1] Concept: Reverse proxy

- **Ngày:** 2026-07-14
- **Mức hiểu:** 3
- **Giải thích bằng lời mình:** Thay vì truy cập `localhost:3000`, `localhost:9090`..., dùng Nginx Proxy Manager nhận request theo domain (`app1.local`) rồi forward đến service đúng. Lợi ích: 1 port (80/443), SSL tập trung, dễ nhớ.
- **Ví dụ cụ thể đã làm:** Cấu hình `hosts` file trỏ `app1.local → 127.0.0.1`, NPM forward `app1.local` → `homepage:3000`.
- **Câu hỏi còn lại:** SSL local thế nào? Cần certificate tự ký?
- **Tài liệu tham khảo:** `homelabops/nginx-proxy/`.

### [Tuần 1] Concept: Named volume vs bind mount

- **Ngày:** 2026-07-14
- **Mức hiểu:** 3
- **Giải thích bằng lời mình:** Cả 2 đều lưu dữ liệu container ra ngoài, nhưng cách quản lý khác. Named volume (ví dụ `npm_data:/data`) do Docker quản lý vị trí lưu, không sửa trực tiếp được, phù hợp dữ liệu quan trọng không cần đụng vào. Bind mount (ví dụ `./homepage/config:/app/config`) trỏ thẳng vào thư mục trên host, sửa file trực tiếp container thấy ngay, phù hợp config cần chỉnh thường xuyên.
- **Ví dụ cụ thể đã làm:** NPM dùng named volume `npm_data` (config proxy, user — không sửa tay). Homepage dùng bind mount `./homepage/config` (sửa `services.yaml`, `settings.yaml` trực tiếp trên host, dashboard cập nhật ngay).
- **Câu hỏi còn lại:** Khi backup, named volume backup thế nào? Có cần `docker run --rm -v ...` để sao chép ra?
- **Tài liệu tham khảo:** `homelabops/docker-compose.yml:22,40`, CODING_STANDARDS.md mục Docker.

### [Tuần 1] Concept: (chưa ghi — điền tiếp)

- **Ngày:**
- **Mức hiểu:**
- **Giải thích bằng lời mình:**
- **Ví dụ cụ thể đã làm:**
- **Câu hỏi còn lại:**
- **Tài liệu tham khảo:**

---

## Tuần 2 — P1: Giám sát, log, backup

(điền khi học Tuần 2)

---

## Tuần 3 — P2: Pipeline RAG offline

(điền khi học Tuần 3)

---

## Tuần 4 — P2: Tinh chỉnh + Đóng gói offline

(điền khi học Tuần 4)
