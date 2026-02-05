# OpenAPI 3.0 接口定义

## 快速开始

### 浏览器显示
- **API文档**: 在上层目录打开 `APIドキュメント.html`

### 主要文件
- `openapi.yaml` - 主定义（外部引用使用）
- `openapi-complete.yaml` - 完整定义（单一文件）

## 文件结构

```
API接口设计/
├── openapi/                          # OpenAPI定义目录
│   ├── openapi.yaml                  # 主定义（外部引用）
│   ├── openapi-complete.yaml         # 完整的单一文件定义
│   ├── README.md                     # 本文件
│   ├── components/                   # 组件定义
│   │   ├── schemas/                  # 模式定义
│   │   │   ├── common.yaml          # 公共模式
│   │   │   ├── partners.yaml        # 合作伙伴模式
│   │   │   ├── orders.yaml          # 订单模式
│   │   │   ├── completed-orders.yaml # 业绩模式
│   │   │   └── billings.yaml        # 账单模式
│   │   ├── parameters/              # 参数定义
│   │   │   └── common.yaml          # 公共参数
│   │   └── responses/               # 响应定义
│   └── paths/                        # 路径定义
│       ├── auth/                     # 认证API
│       ├── partners/                 # 合作伙伴管理API
│       ├── orders/                   # 订单管理API
│       ├── completed-orders/         # 业绩管理API
│       ├── billings/                 # 账单管理API
│       ├── base-accounts/            # 基地账户API
│       ├── action-history/           # 操作历史API
│       └── uploads/                  # 文件上传API
```

## API模块列表

| 模块 | API数量 | 端点 | 说明 |
|-----------|-------|------------------|------|
| Authentication | 3 | `/api/v1/auth/*` | 登录、登出、Token刷新 |
| Partners | 3 | `/api/v1/partners/*` | 合作伙伴搜索、详情、用户管理 |
| Orders | 3 | `/api/v1/orders/*` | 订单搜索、详情、指示书管理 |
| Completed Orders | 2 | `/api/v1/completed-orders/*` | 业绩搜索、详情、确定处理 |
| Billings | 2 | `/api/v1/billings/*` | 账单搜索、详情、PDF发布 |
| Base Accounts | 2 | `/api/v1/base-accounts/*` | 基地账户管理 |
| Action History | 1 | `/api/v1/action-history/*` | 操作历史搜索 |
| Uploads | 2 | `/api/v1/uploads/*` | CSV上传、历史管理 |
| **合计** | **18 API** | | |

## 认证方式

所有API需要Bearer Token认证：

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json
```

## 响应格式

所有API使用统一响应格式：

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "处理成功",
  "data": {
    // 实际数据
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

## 环境设置

| 环境 | URL | 说明 |
|------|-----|------|
| 生产 | `https://api.yamato-transport.co.jp/api/v1` | 生产环境 |
| 测试 | `https://api-test.yamato-transport.co.jp/api/v1` | 测试环境 |
| 开发 | `http://localhost:8080/api/v1` | 开发环境 |

## 代码生成

### TypeScript客户端生成
```bash
openapi-generator-cli generate \
  -i openapi-complete.yaml \
  -g typescript-axios \
  -o ./src/api/client
```

### Spring Boot服务端生成
```bash
openapi-generator-cli generate \
  -i openapi-complete.yaml \
  -g spring \
  -o ./src/main/java/com/yamato/api
```

## 相关文档

- [API设计总览](../01_API接口设计总览.md)
- [合作伙伴管理API](../02_パートナー管理API.md)
- [订单管理API](../03_発注管理API.md)
- [业绩账单管理API](../04_実績・請求管理API.md)
- [文件上传审计日志API](../05_ファイルアップロード・監査ログAPI.md)
- [基地账户主数据管理API](../06_ベースアカウント・マスタ管理API.md)
- [OpenAPI 3.0 接口定义](../07_OpenAPI_3.0_インターフェース定義.md)

## 版本管理

| 版本 | 日期 | 变更内容 |
|------------|------|----------|
| v1.0.0 | 2026-02-05 | 初始发布 |

## 许可证

大贺运输新系统 内部使用

---
**最后更新**: 2026-02-05  
**部门**: IT推进部  
**状态**: 运行中