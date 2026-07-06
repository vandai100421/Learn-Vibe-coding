# Biên bản họp: Code with AI - Progress Meeting - 06/07/2026

> **Tóm tắt nhanh [TL;DR]:**

> - Đổi người phụ trách buổi: anh Mạnh bận việc gia đình, chuyển sang anh Hà phụ trách, anh Cường quản lý chung.
> - Chốt phương pháp: dùng công cụ mở OpenCode cùng mô hình chạy local GLM 5.2 thay cho công cụ thương mại, vì lý do bảo mật và chính sách dữ liệu.
> - Anh Cường demo trực tiếp quy trình "mô tả yêu cầu, AI phân tích, lập kế hoạch rồi tự code" trên file đề xuất của Tài.
> - Bài toán của Đại được đánh giá quá lớn cho một người trong 4 tuần; định hướng thu hẹp phạm vi và tận dụng hệ thống có sẵn.

## 0. Thông tin chung

- **Dự án / Khóa học:** Code with AI (đơn đặt hàng từ một cơ quan đối tác, hình thức khóa học dùng AI để lập trình).
- **Thời gian:** 06/07/2026, 14:59.
- **Thời lượng:** 83 phút.
- **Hình thức:** online, có chia sẻ màn hình.
- **Người phụ trách / giảng viên:** Viet Cuong Nguyen (anh Cường), Viet Ha Le (anh Hà), hai người dẫn dắt và giao việc.
- **Học viên có mặt:** Tai Bui the (Tài), Đại Nguyễn Văn (Đại), Dong Ngo Duy (Đông, Duy).
- **Vắng mặt:** anh Mạnh, người dự kiến phụ trách ban đầu, bận việc gia đình.
- **Nguồn transcript:** Tactiq, `Code_with_AI_-_Progress_Meeting.txt`.

## 1. Mục tiêu cuộc họp

Kiểm tra tiến độ nhiệm vụ đầu tiên (cài đặt môi trường), thống nhất phương pháp làm việc với AI, demo quy trình, và thảo luận, điều chỉnh đề xuất của từng học viên cho phù hợp khóa học 4 tuần.

## 2. Nội dung trình bày và demo

**Kiểm tra yêu cầu từ thứ Sáu:** Tài đã phản hồi; Đại đã cài xong, test không lỗi, đã làm đề xuất nhưng quên gửi (gửi ngay trong buổi); Đông đã cài môi trường và API. Nhóm thống nhất gửi chung các đề xuất lên nhóm để học hỏi lẫn nhau.

**Phương pháp làm việc (anh Hà trình bày):** Cách làm chuyển từ tự viết code sang "trò chuyện" với AI qua giao diện dòng lệnh (CLI), coi AI như người làm thuê code hộ; người dùng giám sát, duyệt các bước và kiểm tra kết quả. Có thể dùng công cụ thương mại như Claude Code, nhưng phải đưa dữ liệu ra ngoài nên có thể vướng chính sách. Giải pháp thay thế: dùng công cụ mở OpenCode cùng dịch vụ AI tự dựng, chạy trên máy của bên mình để kiểm soát dữ liệu. Quy trình: tạo thư mục dự án, mở bằng CLI hoặc VS Code, chuẩn bị tài liệu, ngữ cảnh (ví dụ tài liệu API) cho AI đọc, rồi AI suy luận, vạch bước và sinh code.

**Demo trực tiếp (anh Cường, dùng file đề xuất của Tài):** Đưa file vào giao diện chat với mô hình local GLM 5.2, yêu cầu phân tích. AI nêu tiêu chí đánh giá, phân tích bối cảnh, xác định người dùng sơ cấp và thứ cấp, đề xuất MVP và dữ liệu mẫu. Tiếp đó yêu cầu AI lập bản kế hoạch / spec, phân tích kỹ thuật, gợi ý mô hình AI cho việc chẩn đoán lỗi, và bật tìm kiếm web để tham khảo các hệ thống tương tự. Khi người kỹ thuật đã ưng, đưa spec vào OpenCode để nó sinh ứng dụng hoàn chỉnh. Các khả năng khác được nêu: chuyển ngôn ngữ lập trình (Python sang Go, C++), thiết kế giao diện bằng Claude Design kiểu Figma, tạo web điều khiển cho chương trình dòng lệnh, và reverse engineering (khó hơn nhưng làm được).

## 3. Thảo luận và định hướng

**Cấu trúc khóa học (anh Cường trả lời câu hỏi của Đại):** Đây là đơn đặt hàng từ cơ quan đối tác, mục tiêu hiện thực hóa việc dùng AI để code và hướng tới cơ quan tự triển khai mô hình local. Thời gian khoảng một tháng, giai đoạn đầu làm dạng hỏi đáp, tự do, không theo giáo trình cứng; tài liệu sẽ biên soạn dần trong quá trình.

**Về mô hình local GLM 5.2:** Chất lượng phụ thuộc mô hình. GLM 5.2 gần tương đương các mô hình thương mại tốt nhất (ví von khoảng 87 so với 90 điểm), kém hơn Claude Opus 4.8 một chút. Claude Fable mới ra và bị Mỹ hạn chế công bố (kiểm soát xuất khẩu). Triển khai không phức tạp nhưng cần máy mạnh (đang chạy trên máy H200); mô hình khoảng 700 đến 754 tỷ tham số. Nhập máy về Việt Nam cần xin phép; Viettel có nhiều máy và dùng GLM 5.2 để code nội bộ. Lý do ưu tiên mã nguồn mở: dự án thực tế trong cơ quan khó dùng công cụ thương mại vì dữ liệu gửi ra ngoài, có thể bị cấm. Anh Cường cho biết đã dùng GLM 5.2 code lại toàn bộ website công ty (nền WordPress), thiết kế bằng Claude Design, đa ngôn ngữ Việt / Anh / Nhật, responsive, deploy lên VPS, tổng khoảng 2 ngày làm việc.

**Đề tài của Đại:** Đại làm về quản lý văn bản, lãnh đạo hay hỏi số liệu quý, năm; muốn xây hệ thống tự tổng hợp, thống kê, báo cáo và hỏi đáp bằng ngôn ngữ tự nhiên. Anh Hà và anh Cường đánh giá đây là bài toán rất chung, đã có nhiều hệ thống sẵn (Open WebUI, AnythingLLM, kho tri thức / RAG, embedding BGE-M3, vector DB kiểu ChromaDB, chạy local qua Ollama), nên không nên tự code lại từ đầu (ví von: đã có ô tô bán sẵn thì không cần tự chế). Đại lo "open source" nhạy cảm với cơ quan mình, có thể không được dùng, cơ quan thiên về tự phát triển để kiểm soát. Anh Cường giải thích có thể chỉ dùng mã nguồn mở ở mức thư viện, còn logic và thiết kế tự kiểm soát; việc tuyệt đối không dùng mã nguồn mở là cực khó (ngay cả Windows cũng dùng).

**Điều chỉnh phạm vi cho 4 tuần:** Nhóm dùng chính AI để tư vấn. AI nhận định phạm vi quá rộng cho 4 tuần, cần thu hẹp và tái cấu trúc thành các mốc, gộp thành một ứng dụng, giữ phần lõi (chạy offline, dùng Ollama mô hình nhỏ, RAG tiếng Việt, trích dẫn nguồn) và bỏ phần ngoài phạm vi. Anh Hà lưu ý bài toán dài hạn khác với bài tập học tập ngắn.

## 4. Kết luận

Chốt dùng OpenCode cùng GLM 5.2 làm nền tảng. Đề tài của Đại sẽ được thu hẹp cho vừa 4 tuần, ưu tiên tận dụng hệ thống có sẵn ở mức phù hợp, nhưng vẫn tạo nền tảng để sau này mở rộng. Không biên soạn giáo án cứng; học theo thực tế, các log và tài liệu ghi lại chính là tư liệu giảng dạy về sau.

## 5. Hạ tầng / Công cụ / Tài nguyên

Công cụ code: OpenCode (mở), Claude Code (thương mại). Mô hình: GLM 5.2 chạy local trên máy H200. Thiết kế giao diện: Claude Design. Hệ thống tài liệu / RAG có sẵn: Open WebUI, AnythingLLM, Ollama, embedding BGE-M3, vector DB ChromaDB. Triển khai: Docker, VPS. Anh Hà sẽ tạo tài khoản hệ thống GLM 5.2 cho từng học viên.

## 6. Nhật ký quyết định [decision log]

- Chuyển người phụ trách buổi từ anh Mạnh sang anh Hà; anh Cường quản lý chung.
- Các đề xuất gửi chung lên nhóm để học hỏi lẫn nhau.
- Dùng công cụ mở (OpenCode) và mô hình local GLM 5.2 thay công cụ thương mại, vì bảo mật và chính sách dữ liệu.
- Đề tài của Đại: không tự viết lại toàn bộ từ đầu; thu hẹp phạm vi cho 4 tuần, tận dụng hệ thống sẵn có.
- Không dùng giáo án cứng; log lại quá trình làm tư liệu.

## 7. Tổng hợp việc cần làm [action items]

| STT | Việc cần làm | Người phụ trách | Hạn | Trạng thái |
| --- | --- | --- | --- | --- |
| 1 | Tạo tài khoản hệ thống GLM 5.2 cho 3 học viên | Hà | không nêu | mới |
| 2 | Gửi lại bài toán / đề xuất lên nhóm chung | Tài, Đại, Đông | không nêu | mới |
| 3 | Xem lại và điều chỉnh đề bài cho vừa 4 tuần rồi gửi lại | Đại | không nêu | mới |
| 4 | Hoàn tất cài đặt nền tảng (OpenCode và môi trường), báo cáo tiến độ | Tài, Đại, Đông | không nêu | mới |
| 5 | Ghi lại tài liệu các bước cài đặt và khó khăn gặp phải | Tài, Đại, Đông | không nêu | mới |

## 8. Vấn đề tồn đọng / rủi ro [open issues]

- Bài toán của Đại quá lớn cho một người trong 4 tuần; anh Hà lưu ý cần cả team, một người làm dễ bị thiên lệch (bias).
- "Open source" có thể nhạy cảm và không được dùng ở cơ quan của Đại; cần làm rõ mức độ dùng cho phép.
- Chạy mô hình local cần máy đủ mạnh; mô hình nhỏ yếu hơn nhiều cho các tác vụ này.

## 9. Kế hoạch và lịch họp kế tiếp

- **Lịch họp tới:** chưa chốt; sẽ họp lại khi các học viên cài xong nền tảng.
- **Mục tiêu kỳ tới:** hoàn tất cài đặt OpenCode và môi trường, lên hệ thống chat thử nghiệm, chốt lại đề bài đã điều chỉnh.
- **Đầu ra kỳ vọng:** báo cáo tiến độ cài đặt để bàn tiếp về mặt thực tế.
