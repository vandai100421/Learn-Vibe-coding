# decisions.md — Architecture Decision Records (ADR)

> Mục đích: ghi lại mỗi quyết định kỹ thuật quan trọng + các lựa chọn đã loại + vì sao chọn.
> Nguyên tắc: một quyết định = một mục. Không xóa, chỉ đánh dấu "Superseded by ADR-XXX" nếu đổi ý.

## Template

```
### ADR-XXX: [Tên quyết định ngắn]

- **Ngày:** YYYY-MM-DD
- **Trạng thái:** Accepted / Superseded by ADR-YYY / Deprecated
- **Bối cảnh:** vấn đề cần giải quyết là gì? ràng buộc nào (RAM, offline, thời gian)?
- **Các lựa chọn:** liệt kê 2-4 phương án + ưu/nhược từng cái
- **Quyết định:** chọn cái nào
- **Vì sao:** lý do chính (1-2 câu)
- **Hậu quả:** mất/giàn gì, rủi ro đi kèm, hành động tiếp theo
```

---

## ADR-001: Chọn Docker Desktop thay WSL2 + Docker Engine

- **Ngày:** 2026-07-13
- **Trạng thái:** Accepted
- **Bối cảnh:** Máy 8GB RAM, Windows 10. Cần chạy Docker cho P1 (HomelabOps). PROJECT.md ban đầu ghi WSL2 + Ubuntu, nhưng RAM eo hẹp.
- **Các lựa chọn:**
  - **A. WSL2 + Docker Engine (trong Ubuntu):** nhẹ hơn về lý thuyết, nhưng WSL2 mặc định "ăn" 50% RAM (~4GB), cấu hình `.wslconfig` phức tạp cho người mới.
  - **B. Docker Desktop (native Windows):** dễ cài, GUI giới hạn RAM trực tiếp trong Settings → Resources, tích hợp Compose sẵn.
  - **C. Docker Toolbox (VirtualBox):** lỗi thời, không dùng nữa.
- **Quyết định:** B — Docker Desktop.
- **Vì sao:** với 8GB RAM, khả năng giới hạn resource qua GUI quan trọng hơn cấu hình tinh vi. Người học cần tập trung vào sysadmin concept, không phải cấu hình WSL2.
- **Hậu quả:** ăn RAM hơn WSL2 một chút; phải giới hạn Docker Desktop ~3-4GB; không học được `.wslconfig` (chấp nhận, ghi vào backlog).

---

## ADR-002: Chọn Qwen2.5:3B làm model chính cho P2

- **Ngày:** 2026-07-13
- **Trạng thái:** Accepted
- **Bối cảnh:** P2 (OpsBrain) cần LLM chạy local offline. Máy 8GB RAM, không GPU. Cần dư RAM cho Windows + Open WebUI + ChromaDB + bge-m3.
- **Các lựa chọn:**
  - **A. Qwen2.5:32B (Q4):** chất lượng tiếng Việt tốt nhất, nhưng cần ~20GB RAM → không thể chạy.
  - **B. Qwen2.5:14B (Q4):** cần ~9GB RAM → chật, chậm, Windows sẽ swap.
  - **C. Qwen2.5:7B (Q4):** cần ~5GB RAM → khả thi nhưng chật, để lại ít RAM cho Open WebUI/ChromaDB.
  - **D. Qwen2.5:3B (Q4):** cần ~2.5GB RAM → dư dả, chạy nhanh trên CPU.
- **Quyết định:** D — Qwen2.5:3B làm mặc định; thử 7B ở Tuần 4 nếu RAM dư.
- **Vì sao:** 3B đủ học concept RAG (pipeline không phụ thuộc model size). Trade-off chất lượng tiếng Việt chấp nhận được vì mục tiêu chính là học, không phải sản phẩm.
- **Hậu quả:** câu trả lời tiếng Việt trung bình-khá; cần prompt engineering tốt hơn để bù; ghi rủi ro vào `risks.md` (RISK-001).

---

## ADR-003: ___

- **Ngày:**
- **Trạng thái:**
- **Bối cảnh:**
- **Các lựa chọn:**
- **Quyết định:**
- **Vì sao:**
- **Hậu quả:**
