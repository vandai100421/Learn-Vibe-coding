# PROJECT.md

# Thông tin dự án

## Mục tiêu

Khóa học "Code with AI" - học cách dùng AI để lập trình, đồng thời xây dựng kiến thức quản trị hệ thống.

Mục tiêu chính: học kiến thức, kỹ năng.
Mục tiêu phụ: hoàn thành 2 project thực hành.

## Hai project

1. **HomelabOps** (`Tài liệu/04_Project1_HomelabOps.md`): Stack dịch vụ tự host trên Docker, học sysadmin cơ bản.
2. **OpsBrain** (`Tài liệu/05_Project2_OpsBrain.md`): Trợ lý AI offline RAG cho quản trị hệ thống, học local LLM + RAG pipeline.

## Môi trường

- Máy cá nhân: 8GB RAM, không có GPU
- OS: Windows 10, dùng Docker Desktop cho P1, Ollama native cho P2
- Lưu ý tài nguyên: 8GB RAM giới hạn số service chạy đồng thời ở P1 và buộc chọn LLM nhỏ (Qwen2.5:3B) ở P2
- Thời gian: 4 tuần
- Hết khóa: không còn GLM 5.2, vào môi trường air-gapped

## Nguyên tắc khi hỗ trợ AI

- Trọng tâm là giải thích concept, không chỉ sinh code
- Khi đề xuất giải pháp, luôn giải thích "vì sao" chọn phương án đó
- So sánh các phương án thay thế khi có thể (ví dụ: RAG vs fine-tuning, ChromaDB vs Qdrant)
- Ưu tiên tận dụng hệ thống có sẵn (Open WebUI, AnythingLLM) thay vì code từ đầu
- Mọi tài nguyên (model, image, package) phải pre-stage được cho môi trường offline

## Người dùng

- Background: web backend/frontend, Docker cơ bản
- Đang học để làm quản trị hệ thống
- Tiếng Việt là ngôn ngữ chính

## Tham khảo

- Biên bản họp: `Code with AI Meeting 20260706 [VI].md`
- Cấu hình môi trường: `SETUP.md`
- Đề tài project: `Tài liệu/`
