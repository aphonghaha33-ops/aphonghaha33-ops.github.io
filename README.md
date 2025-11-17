# Story Manager — Hướng dẫn nhanh

Các file liên quan:
- `all_stories.html` — trang tổng hợp, bây giờ đọc `stories/index.json` để biết danh sách các câu chuyện.
- `stories/index.json` — chỉ mục tên file (được tạo/đọc bởi trang và script).
- `scripts/manage_stories.ps1` — script PowerShell giúp thêm/xóa file và cập nhật `index.json` trực tiếp trên đĩa.

Thêm / xóa story — hai cách:

1) Giao diện web (không ghi trực tiếp lên đĩa)
- Mở `all_stories.html` bằng Live Server.
- Bấm `Quản lý` để mở panel quản lý.
- Bạn có thể chọn file `.txt` để <u>tạo và tải xuống</u> (trong trình duyệt). Sau đó copy file đã tải vào thư mục `stories/` trên máy.
- Hoặc chỉnh sửa list trong UI rồi bấm `Tải index.json` để tải xuống phiên bản index mới — sau đó thay thế `stories/index.json` trên đĩa.

2) Dùng PowerShell (ghi trực tiếp vào thư mục `stories/`)
- Mở PowerShell ở thư mục dự án (ví dụ `C:\Users\aa\Downloads\web`).
- Thêm file từ đường dẫn nguồn:
  .\scripts\manage_stories.ps1 -AddPath "C:\đường\dẫn\tới\file.txt"
- Xóa file theo tên:
  .\scripts\manage_stories.ps1 -RemoveName "Tên file.txt"
- Xây lại index từ thư mục `stories/`:
  .\scripts\manage_stories.ps1 -RebuildIndex

Ghi chú:
- Trình duyệt không có quyền ghi thẳng vào thư mục local khi mở trang bằng Live Server — vì vậy UI cung cấp công cụ để tạo file và tải về, còn hành động ghi lên đĩa cần copy thủ công hoặc dùng script PowerShell.
- Sau khi thay đổi nội dung trong `stories/` hoặc `stories/index.json`, bấm `Tải lại nội dung` trong `all_stories.html` để làm mới trang.

Nếu muốn, tôi có thể thêm tính năng tự động gửi file từ UI đến một server nhỏ (node/express) để ghi vào đĩa — nhưng điều đó yêu cầu chạy một server bổ sung.
