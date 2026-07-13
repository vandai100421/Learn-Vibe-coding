# docs/ — Hệ thống ghi chú dự án

> Mục đích: kiểm soát vấn đề, quyết định, tiến độ và bài học trong suốt 4 tuần.
> Nguyên tắc: ghi ngắn, ghi đúng, ghi vì sao. Đây là nguồn tri thức để nạp vào P2.

## Quy ước ghi nhật ký 4 cấp (quan trọng)

Phân biệt rõ 4 loại để không ghi nhầm file:

| Loại | File | Khi nào ghi | Trạng thái |
|---|---|---|---|
| **Quyết định** | `decisions.md` | Khi chọn giữa ≥2 lựa chọn | Chốt rồi, không đổi |
| **Lỗi đã fix** | `troubleshooting.md` | Khi giải quyết xong lỗi | Đã đóng |
| **Vấn đề chưa giải quyết** | `issues.md` | Khi phát hiện, chưa fix | open / blocked / closed |
| **Rủi ro chưa xảy ra** | `risks.md` | Khi nhận ra nguy cơ | active / mitigated / avoided |

Quy tắc chuyển trạng thái:
- `risk` (chưa xảy ra) → nếu xảy ra → thành `issue` (mở)
- `issue` → khi fix xong → chuyển sang `troubleshooting` (đóng, rút bài học)
- Không xóa entry khi đóng, chỉ đổi trạng thái để giữ lịch sử

## Danh sách file

| File | Vai trò | Tần suất ghi |
|---|---|---|
| [decisions.md](decisions.md) | ADR — quyết định kỹ thuật + vì sao chọn | Mỗi lần quyết định |
| [troubleshooting.md](troubleshooting.md) | Lỗi đã gặp + nguyên nhân gốc + cách fix | Mỗi lần fix xong |
| [issues.md](issues.md) | Vấn đề đang mở, theo dõi trạng thái | Khi phát hiện → khi đóng |
| [risks.md](risks.md) | Rủi ro chưa xảy ra + giảm thiểu | Khi nhận ra |
| [learning-log.md](learning-log.md) | Concept đã học, mức hiểu | Cuối mỗi phiên |
| [progress.md](progress.md) | Tiến độ thực tế vs TASKS.md | Cuối mỗi phiên |
| [resource-budget.md](resource-budget.md) | RAM/disk từng service (8GB eo hẹp) | Khi bật/tắt service |
| [backlog.md](backlog.md) | Ý tưởng ngoài scope, làm sau khóa | Khi nảy ý |

## Quy ước chung

- Ngày tháng: `YYYY-MM-DD` (ISO, tránh nhầm DD/MM).
- ID: `ADR-XXX`, `ISSUE-XXX`, `RISK-XXX` — đánh số liên tục, không dùng lại.
- Mức ưu tiên: `P0` (chặn tiến độ) / `P1` (quan trọng) / `P2` (muộn được).
- Mức hiểu (learning-log): `1` nghe qua / `3` dùng được / `5` giải thích được cho người khác.
- Mỗi entry có mục **Bài học** hoặc **Vì sao** — không ghi sự kiện trần trui.
- File này và các file khác sẽ được upload vào Open WebUI (P2) làm tri thức.

## Tích hợp P1 → P2

```
docs/decisions.md        ──┐
docs/troubleshooting.md  ──┼──► Open WebUI knowledge (P2)
docs/learning-log.md     ──┘
```

→ P2 có thể trả lời: "Vì sao chọn ChromaDB?", "Lần trước lỗi X fix thế nào?".
