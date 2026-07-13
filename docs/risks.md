# risks.md — Rủi ro chưa xảy ra + giảm thiểu

> Mục đích: nhận diện rủi ro TRƯỚC khi xảy ra, có kế hoạch giảm thiểu.
> Khác `issues.md`: rủi ro là "có thể xảy ra", issue là "đang xảy ra".
> Nguyên tắc: review cuối mỗi tuần — rủi ro nào thành thật → chuyển sang `issues.md`.

## Trạng thái

- `active` — rủi ro còn hiện hữu, cần theo dõi
- `mitigated` — đã có biện pháp giảm, còn tác động thấp
- `avoided` — tránh được hẳn (thay đổi kế hoạch)
- `occurred` — đã xảy ra → chuyển sang `issues.md`

## Đánh giá

- **Xác suất:** High / Medium / Low
- **Tác động:** High (chặn project) / Medium (chậm tiến độ) / Low (khó chịu)

## Bảng rủi ro

| ID | Rủi ro | Xác suất | Tác động | Trạng thái | Tuần | Giảm thiểu |
|---|---|---|---|---|---|---|
| RISK-001 | Qwen2.5:3B trả lời tiếng Việt kém | Medium | Medium | mitigated | Tuần 3 | Thử 7B nếu RAM dư; tune system prompt (Tuần 4) |
| RISK-002 | 8GB RAM không đủ chạy P1 + P2 song song | High | High | mitigated | Tuần 3 | Chỉ chạy 1 project tại 1 thời điểm; tắt P1 stack khi dùng P2 |
| RISK-003 | Ollama model không tải được offline | Low | High | mitigated | Tuần 4 | Pre-stage `~/.ollama/models` trước khi air-gap |
| RISK-004 | Docker Desktop hết RAM → container bị kill | Medium | Medium | active | Tuần 1-4 | Giới hạn RAM Docker 3-4GB; track `resource-budget.md` |
| RISK-005 | Hết thời gian 4 tuần trước khi xong offline package | Medium | High | active | Tuần 4 | Ưu tiên Tier 1+2; offline package làm đầu Tuần 4 |

---

## Chi tiết rủi ro

### RISK-001: Qwen2.5:3B trả lời tiếng Việt kém

- **Mô tả:** Model 3B có thể trả lời tiếng Việt lủng củng, sai ngữ pháp, hoặc trả lời tiếng Anh.
- **Tác động:** Chất lượng P2 kém, khó học đánh giá RAG (không phân biệt được do model kém hay retrieval kém).
- **Giảm thiểu:**
  1. Viết system prompt chặt: "Luôn trả lời tiếng Việt, rõ ràng, ngắn gọn" (Tuần 4).
  2. Thử `qwen2.5:7b` nếu RAM dư → so sánh chất lượng.
  3. Tách biến: test retrieval riêng (kiểm tra context có đúng tài liệu không) trước khi đánh giá câu trả lời.
- **Khi nào xảy ra:** Tuần 3 test Q&A đầu tiên.
- **Nếu xảy ra:** tạo ISSUE, chuyển sang `troubleshooting.md` khi fix.

### RISK-002: 8GB RAM không đủ chạy P1 + P2 song song

- **Mô tả:** Cả P1 (Docker stack ~3GB) và P2 (Ollama 3B ~2.5GB + Open WebUI + ChromaDB ~1GB) đều chạy → vượt RAM.
- **Tác động:** Container bị kill, mất dữ liệu đang xử lý.
- **Giảm thiểu:**
  1. Chỉ 1 project active tại 1 thời điểm.
  2. Khi dùng P2, tắt P1 stack: `docker compose -f homelabops/docker-compose.yml stop`.
  3. Tài liệu P1 (SOP, config) đã export ra file → P2 không cần P1 chạy.
- **Trạng thái:** mitigated (đã có quy tắc).

### RISK-006: (template trống)

- **Mô tả:**
- **Tác động:**
- **Giảm thiểu:**
- **Khi nào xảy ra:**
