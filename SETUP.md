# SETUP.md

# Cài đặt môi trường phát triển

## 1. Cài đặt phần mềm

- Git
- Node.js (LTS)
- Visual Studio Code
- OpenCode CLI
- PowerShell (Windows)

Kiểm tra:

```bash
git --version
node -v
npm -v
opencode --version
```

---

# 2. Cài đặt OpenCode

Cài đặt theo hướng dẫn chính thức của OpenCode.

Sau khi cài đặt, kiểm tra:

```bash
opencode --version
```

---

# 3. Cấu hình OpenCode

Tạo file:

```text
opencode.json
```

Ví dụ:

```json
{
  "$schema": "https://opencode.ai/config.json",

  "provider": {
    "custom": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Custom API",
      "options": {
        "baseURL": "{env:CUSTOM_BASE_URL}",
        "apiKey": "{env:CUSTOM_API_KEY}"
      },
      "models": {
        "glm-5.2": {
          "name": "GLM 5.2"
        }
      }
    }
  },

  "model": "custom/glm-5.2",

  "permission": {
    "bash": "ask",
    "edit": "ask"
  },

  "instructions": [
    "PROJECT.md",
    "ARCHITECTURE.md",
    "CODING_STANDARDS.md",
    "DEVELOPMENT_RULES.md",
    "TASKS.md"
  ]
}
```

---

# 4. Thiết lập biến môi trường

## PowerShell (tạm thời)

```powershell
$env:CUSTOM_BASE_URL="https://your-api/v1"
$env:CUSTOM_API_KEY="your_api_key"
```

Kiểm tra:

```powershell
echo $env:CUSTOM_BASE_URL
echo $env:CUSTOM_API_KEY
```

---

## Thiết lập vĩnh viễn

```powershell
setx CUSTOM_BASE_URL "https://your-api/v1"
setx CUSTOM_API_KEY "your_api_key"
```

Sau khi chạy:

- Đóng Terminal
- Mở lại Terminal

---

# 5. Chạy OpenCode

```bash
opencode
```

---

# Lỗi thường gặp

## 1. "/chat/completions" cannot be parsed as a URL

### Nguyên nhân

`CUSTOM_BASE_URL` chưa được thiết lập hoặc không hợp lệ.

### Kiểm tra

```powershell
echo $env:CUSTOM_BASE_URL
```

Nếu kết quả rỗng hoặc chỉ có:

```text
/chat/completions
```

=> Thiết lập lại biến môi trường.

---

## 2. Unauthorized / Invalid API Key

### Nguyên nhân

API Key không đúng.

### Kiểm tra

```powershell
echo $env:CUSTOM_API_KEY
```

---

## 3. Model not found

### Nguyên nhân

Tên model trong `opencode.json` không khớp với model trên API.

Ví dụ:

```json
"model": "custom/glm-5.2"
```

Kiểm tra lại tên model từ nhà cung cấp.

---

## 4. Connection refused

### Nguyên nhân

Server AI chưa chạy.

Ví dụ:

- Ollama chưa start
- LM Studio chưa bật server
- API nội bộ chưa hoạt động

---

## 5. Permission denied

Kiểm tra:

```json
"permission": {
    "bash": "ask",
    "edit": "ask"
}
```

Nếu muốn AI tự thực thi:

```json
"permission": {
    "bash": "allow",
    "edit": "allow"
}
```

> Chỉ sử dụng khi làm việc trong môi trường an toàn.

---

# Kiểm tra nhanh

```powershell
echo $env:CUSTOM_BASE_URL
echo $env:CUSTOM_API_KEY

git --version
node -v
npm -v
opencode --version
```

Nếu tất cả đều hiển thị đúng, môi trường đã sẵn sàng.