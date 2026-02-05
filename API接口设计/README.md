# 大贺运输新系统 API文档

## 使用文件

唯一文件: `APIドキュメント.html`

---

## 快速开始

### 1. 打开文档
```
APIドキュメント.html
```
在浏览器中直接打开。

### 2. 认证设置（重要！）
1. 点击右上角的 "Authorize" 按钮
2. 在Token输入框中输入 `test-token`
3. 点击 "Authorize"
4. 点击 "Close"

### 3. 使用API
1. 选择任意API
2. 点击 "Try it out"
3. 输入参数
4. 点击 "Execute"

---

## API列表（18个）

| 模块 | API数量 | 端点 |
|-----------|-------|----------------|
| Authentication | 3 | POST /auth/login, POST /auth/logout, POST /auth/refresh |
| Partners | 2 | GET /partners/search, GET /partners/{companyId} |
| Orders | 2 | GET /orders/search, GET /orders/{orderId} |
| Completed Orders | 1 | GET /completed-orders/search |
| Billings | 1 | GET /billings/search |
| Base Accounts | 1 | GET /base-accounts/search |
| Action History | 1 | GET /action-history/search |
| Uploads | 2 | POST /uploads, GET /uploads/history |

---

## 注意事项

- **认证**: 所有API（POST /auth/login 除外）都需要认证
- **测试用Token**: 使用 `test-token`
- **实际API调用**: 如果API服务器未运行，会报错
- **开发环境**: `http://localhost:8080/api/v1`
- **服务器切换**: Swagger UI右上角下拉菜单可切换

---

## 操作步骤

1. 打开 `APIドキュメント.html`
2. 点击右上角 "Authorize" 按钮
3. 输入 `test-token`
4. 点击 "Authorize"
5. 点击 "Close"
6. 点击任意API的 "Try it out"
7. 输入参数
8. 点击 "Execute"

---

## 文件说明

- **唯一文件**: `APIドキュメント.html`
- **认证方式**: 输入 `test-token` 即可
- **使用方法**: Authorize → Try it out → Execute

---

## 文件结构

```
API接口设计/
├── APIドキュメント.html          # 唯一可用的文档文件
├── README.md                      # 本说明文件
├── openapi/                       # OpenAPI规范文件
│   ├── openapi.yaml              # 主定义文件
│   ├── openapi-complete.yaml     # 完整规范文件
│   └── README.md                 # OpenAPI目录说明
└── 07_OpenAPI_3.0_インターフェース定義.md  # 原始设计文档
```

---

## 技术支持

- 联系人: IT推进部
- 邮箱: it-support@ohga.co.jp

---

**最后更新**: 2026-02-05  
**版本**: 1.0（统一版）
