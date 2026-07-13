# backlog.md — Ý tưởng ngoài scope, làm sau khóa

> Mục đích: chứa ý tưởng/tính năng KHÔNG làm trong 4 tuần để tránh bị kéo scope.
> Nguyên tắc: nảy ý → ghi vào đây → quay lại làm sau khóa. Không mở rộng TASKS.md.

## Template

```
### BL-XXX: [Tên ý tưởng]
- **Mô tả:** 1-2 câu
- **Lý do muốn có:** vì sao cần
- **Lý do chưa làm:** vì sao không làm trong 4 tuần (scope, RAM, thời gian)
- **Ưu tiên:** High / Medium / Low
- **Khi nào làm:** sau khóa / khi nâng RAM / khi có thời gian
- **Tham khảo:** link/file liên quan
```

---

## BL-001: Kubernetes thay Docker Compose

- **Mô tả:** Chuyển stack P1 sang K8s (minikube hoặc k3s).
- **Lý do muốn có:** Học orchestrator thực tế hơn, scale, self-healing.
- **Lý do chưa làm:** 8GB RAM không đủ chạy K8s cluster + workload. Scope 4 tuần đã kín.
- **Ưu tiên:** Medium
- **Khi nào làm:** Khi nâng RAM lên 16GB+ hoặc có máy riêng.
- **Tham khảo:** Backlog trong TASKS.md.

---

## BL-002: CI/CD nội bộ (Gitea + Woodpecker/Drone)

- **Mô tả:** Self-host Git server + CI runner, push code → auto deploy P1 stack.
- **Lý do muốn có:** Học pipeline DevOps end-to-end.
- **Lý do chưa làm:** Ngoài scope, RAM eo hẹp.
- **Ưu tiên:** Medium
- **Khi nào làm:** Sau khóa, khi có máy mạnh hơn.

---

## BL-003: Fine-tune Qwen2.5:3B cho tiếng Việt ops

- **Mô tả:** Fine-tune model trên bộ Q&A sysadmin tiếng Việt.
- **Lý do muốn có:** Bù chất lượng kém của model 3B (RISK-001).
- **Lý do chưa làm:** Fine-tune cần GPU + data + thời gian, ngoài khả năng 4 tuần.
- **Ưu tiên:** Low
- **Khi nào làm:** Khi có GPU hoặc dùng cloud GPU.

---

## BL-004: Multi-agent cho OpsBrain

- **Mô tả:** Nhiều agent chuyên biệt: 1 tra cứu SOP, 1 parse log, 1 thực thi lệnh.
- **Lý do muốn có:** Phân tách trách nhiệm, chất lượng trả lời tốt hơn.
- **Lý do chưa làm:** Phức tạp, P2 MVP chỉ cần 1 pipeline RAG.
- **Ưu tiên:** Low
- **Khi nào làm:** Version 4-5 của OpsBrain (xem doc 05 mục 8).

---

## BL-005: Học `.wslconfig` và WSL2 tinh vi

- **Mô tả:** Chuyển Docker Desktop sang WSL2 + Docker Engine, cấu hình `.wslconfig` giới hạn RAM.
- **Lý do muốn có:** Nhẹ hơn, học sâu hơn về virtualization.
- **Lý do chưa làm:** ADR-001 chọn Docker Desktop vì dễ, tập trung học sysadmin concept.
- **Ưu tiên:** Low
- **Khi nào làm:** Khi muốn đào sâu Windows virtualization.

---

## BL-006: Ansible playbook deploy service

- **Mô tả:** Viết Ansible playbook deploy 1-2 service (NPM + Homepage) tự động, thay vì `docker compose up` thủ công.
- **Lý do muốn có:** Học Infrastructure as Code, idempotency, declarative config.
- **Lý do chưa làm:** Tuần 2 đã kín (monitoring + logging + backup + SOP). Cài Ansible trên Windows cần WSL/Python setup thêm.
- **Ưu tiên:** Medium
- **Khi nào làm:** Sau khóa, khi có thời gian cài Ansible.
- **Tham khảo:** `TASKS.md` Tuần 2, `docs/decisions.md`.
