# 大贺运输新系统 API 统计报告

## 概览

| 分类 | 页面数 | API总数 | 唯一API |
|------|--------|---------|---------|
| B系列（ベース側） | 14页 | 54 APIs | 54 APIs |
| P系列（パートナー側） | 7页 | 42 APIs | 42 APIs |
| **共用API** | - | **15个** | - |
| **合计** | **21页** | **96 APIs** | **81 APIs** |

> 注：96个条目中有15个是B/P系列共用的API，实际后端只需实现81个唯一API端点。

---

## B系列 - ベース側（PC专用）

### b1-スタート (登录页面)
| # | API端点 | 方法 | 功能 | 共用 |
|---|---------|------|------|------|
| 1 | /api/v1/auth/callback | POST | AzureAD回调处理 | |
| 2 | /api/v1/auth/refresh | POST | 刷新Token | ✅ |
| 3 | /api/v1/auth/logout | POST | 登出 | |
| 4 | /api/v1/users/me | GET | 获取当前用户信息 | ✅ |

### b2-発注検索 (订单搜索)
| # | API端点 | 方法 | 功能 | 共用 |
|---|---------|------|------|------|
| 1 | /api/v1/orders/search | GET | 搜索订单 | ✅ |
| 2 | /api/v1/orders/{orderId} | GET | 获取订单详情 | ✅ |

### b3-発注詳細 (订单详情)
| # | API端点 | 方法 | 功能 | 共用 |
|---|---------|------|------|------|
| 1 | /api/v1/orders/{orderId} | GET | 获取订单详情 | ✅ |
| 2 | /api/v1/orders/{orderId}/update | PUT | 更新订单 | ✅ |
| 3 | /api/v1/orders/{orderId}/status | PUT | 更新状态 | ✅ |
| 4 | /api/v1/orders/{orderId}/cancel | POST | 取消订单 | |
| 5 | /api/v1/orders/{orderId}/history | GET | 获取操作历史 | |
| 6 | /api/v1/orders/{orderId}/documents | GET | 获取文档列表 | ✅ |

### b4-実績検索 (业绩搜索)
| # | API端点 | 方法 | 功能 | 共用 |
|---|---------|------|------|------|
| 1 | /api/v1/completed-orders/search | GET | 搜索实绩 | |
| 2 | /api/v1/completed-orders/{completedOrderId} | GET | 获取实绩详情 | ✅ |

### b5-実績詳細 (业绩详情)
| # | API端点 | 方法 | 功能 | 共用 |
|---|---------|------|------|------|
| 1 | /api/v1/completed-orders/{completedOrderId} | GET | 获取实绩详情 | ✅ |
| 2 | /api/v1/completed-orders/{completedOrderId}/update | PUT | 更新实绩 | |
| 3 | /api/v1/completed-orders/{completedOrderId}/confirm | POST | 确认实绩 | |
| 4 | /api/v1/completed-orders/{completedOrderId}/reject | POST | 拒绝实绩 | |
| 5 | /api/v1/completed-orders/{completedOrderId}/documents | GET | 获取文档 | |
| 6 | /api/v1/completed-orders/{completedOrderId}/documents/upload | POST | 上传文档 | |
| 7 | /api/v1/completed-orders/{completedOrderId}/documents/{docId} | DELETE | 删除文档 | |
| 8 | /api/v1/completed-orders/{completedOrderId}/history | GET | 获取历史 | |

### b6-被請求管理 (账单管理)
| # | API端点 | 方法 | 功能 | 共用 |
|---|---------|------|------|------|
| 1 | /api/v1/billings/search | GET | 搜索账单 | |
| 2 | /api/v1/billings/{billingId} | GET | 获取账单详情 | ✅ |
| 3 | /api/v1/billings/{billingId}/update | PUT | 更新账单 | ✅ |
| 4 | /api/v1/billings/{billingId}/status | PUT | 更新状态 | ✅ |
| 5 | /api/v1/billings/{billingId}/approve | POST | 批准账单 | |
| 6 | /api/v1/billings/{billingId}/reject | POST | 拒绝账单 | |

### b7-被請求詳細 (账单详情)
| # | API端点 | 方法 | 功能 | 共用 |
|---|---------|------|------|------|
| 1 | /api/v1/billings/{billingId} | GET | 获取账单详情 | ✅ |
| 2 | /api/v1/billings/{billingId}/update | PUT | 更新账单 | ✅ |
| 3 | /api/v1/billings/{billingId}/status | PUT | 更新状态 | ✅ |
| 4 | /api/v1/billings/{billingId}/items | GET | 获取账单项目 | |
| 5 | /api/v1/billings/{billingId}/documents | GET | 获取文档 | |

### b8-CSVアップロード (CSV上传)
| # | API端点 | 方法 | 功能 | 共用 |
|---|---------|------|------|------|
| 1 | /api/v1/csv/upload | POST | 上传CSV文件 | |
| 2 | /api/v1/csv/upload/validate | POST | 验证CSV数据 | |
| 3 | /api/v1/csv/upload/{uploadId}/status | GET | 获取上传状态 | |
| 4 | /api/v1/csv/upload/{uploadId}/errors | GET | 获取错误列表 | |
| 5 | /api/v1/csv/upload/{uploadId}/confirm | POST | 确认导入 | |
| 6 | /api/v1/csv/upload/{uploadId}/cancel | POST | 取消上传 | |

### b9-アクション履歴 (操作历史)
| # | API端点 | 方法 | 功能 | 共用 |
|---|---------|------|------|------|
| 1 | /api/v1/actions/history | GET | 获取操作历史 | |

### b11-輸送パートナーマスタ検索 (合作伙伴搜索)
| # | API端点 | 方法 | 功能 | 共用 |
|---|---------|------|------|------|
| 1 | /api/v1/partners/search | GET | 搜索合作伙伴 | |
| 2 | /api/v1/partners/{partnerId} | GET | 获取合作伙伴详情 | ✅ |

### b12-輸送パートナーマスタ詳細（会社）(合作伙伴公司详情)
| # | API端点 | 方法 | 功能 | 共用 |
|---|---------|------|------|------|
| 1 | /api/v1/partners/{partnerId} | GET | 获取公司详情 | ✅ |
| 2 | /api/v1/partners/{partnerId}/update | PUT | 更新公司信息 | |
| 3 | /api/v1/partners/{partnerId}/users | GET | 获取公司用户列表 | |

### b13-輸送パートナー詳細（ユーザー）(合作伙伴用户详情)
| # | API端点 | 方法 | 功能 | 共用 |
|---|---------|------|------|------|
| 1 | /api/v1/partners/{partnerId}/users/{userId} | GET | 获取用户详情 | |
| 2 | /api/v1/partners/{partnerId}/users/{userId}/update | PUT | 更新用户信息 | |
| 3 | /api/v1/partners/{partnerId}/users/{userId}/reset-password | POST | 重置密码 | |

### b14-ベースアカウントマスタ検索 (基础账户搜索)
| # | API端点 | 方法 | 功能 | 共用 |
|---|---------|------|------|------|
| 1 | /api/v1/accounts/search | GET | 搜索基础账户 | |
| 2 | /api/v1/accounts/{accountId} | GET | 获取账户详情 | ✅ |
| 3 | /api/v1/accounts/{accountId}/permissions | GET | 获取权限列表 | |

### b15-ベースアカウントマスタ詳細 (基础账户详情)
| # | API端点 | 方法 | 功能 | 共用 |
|---|---------|------|------|------|
| 1 | /api/v1/accounts/{accountId} | GET | 获取账户详情 | ✅ |
| 2 | /api/v1/accounts/{accountId}/update | PUT | 更新账户信息 | |
| 3 | /api/v1/accounts/{accountId}/roles | PUT | 更新角色 | |
| 4 | /api/v1/accounts/{accountId}/activate | POST | 激活账户 | |
| 5 | /api/v1/accounts/{accountId}/deactivate | POST | 停用账户 | |

---

## P系列 - パートナー側（PC/SP响应式）

### p0-共通ナビゲーション (公共导航)
| # | API端点 | 方法 | 功能 | 共用 |
|---|---------|------|------|------|
| 1 | /api/v1/navigation/menu | GET | 获取导航菜单 | |
| 2 | /api/v1/notifications | GET | 获取通知列表 | |

### p1-スタート (登录页面)
| # | API端点 | 方法 | 功能 | 共用 |
|---|---------|------|------|------|
| 1 | /api/v1/auth/login | POST | 合作伙伴登录 | |
| 2 | /api/v1/auth/refresh | POST | 刷新Token | ✅ |
| 3 | /api/v1/users/me | GET | 获取当前用户信息 | ✅ |

### p2-発注検索 (订单搜索)
| # | API端点 | 方法 | 功能 | 共用 |
|---|---------|------|------|------|
| 1 | /api/v1/orders/search | GET | 搜索订单 | ✅ |
| 2 | /api/v1/orders/{orderId} | GET | 获取订单详情 | ✅ |
| 3 | /api/v1/orders/{orderId}/accept | POST | 接受订单 | |
| 4 | /api/v1/orders/{orderId}/decline | POST | 拒绝订单 | |

### p3-発注詳細 (订单详情)
| # | API端点 | 方法 | 功能 | 共用 |
|---|---------|------|------|------|
| 1 | /api/v1/orders/{orderId} | GET | 获取订单详情 | ✅ |
| 2 | /api/v1/orders/{orderId}/update | PUT | 更新订单 | |
| 3 | /api/v1/orders/{orderId}/status | PUT | 更新状态 | |
| 4 | /api/v1/orders/{orderId}/complete | POST | 完成订单 | |
| 5 | /api/v1/orders/{orderId}/documents | GET | 获取文档 | ✅ |
| 6 | /api/v1/orders/{orderId}/documents/upload | POST | 上传文档 | |
| 7 | /api/v1/orders/{orderId}/messages | GET | 获取消息 | |

### p4-実績確認 (业绩确认)
| # | API端点 | 方法 | 功能 | 共用 |
|---|---------|------|------|------|
| 1 | /api/v1/partners/results | GET | 获取业绩列表 | |
| 2 | /api/v1/partners/results/{resultId}/daily-costs | GET | 获取日別傭車費 | |
| 3 | /api/v1/partners/results/{resultId}/daily-costs/{costId} | PUT | 更新日別傭車費 | |
| 4 | /api/v1/partners/results/{resultId}/instructions | GET | 获取指示書 | |
| 5 | /api/v1/partners/results/{resultId}/confirm | POST | 确认业绩 | |
| 6 | /api/v1/partners/results/{resultId}/inquiry | POST | 确认请求 | |
| 7 | /api/v1/partners/results/{resultId}/messages | GET | 获取消息 | |
| 8 | /api/v1/partners/results/{resultId}/messages | POST | 发送消息 | |
| 9 | /api/v1/partners/results/{resultId}/pdf | GET | 下载PDF | |

### p5-請求検索 (账单搜索)
| # | API端点 | 方法 | 功能 | 共用 |
|---|---------|------|------|------|
| 1 | /api/v1/partners/billings/search | GET | 搜索账单 | |
| 2 | /api/v1/partners/billings/{billingId} | GET | 获取账单详情 | |
| 3 | /api/v1/partners/billings/{billingId}/download | GET | 下载账单 | |
| 4 | /api/v1/partners/billings/export | POST | 导出账单 | |

### p6-情報アップロード (信息上传)
| # | API端点 | 方法 | 功能 | 共用 |
|---|---------|------|------|------|
| 1 | /api/v1/partners/achievements/confirmed | GET | 获取已确认业绩 | |
| 2 | /api/v1/partners/bases | GET | 获取基地列表 | |
| 3 | /api/v1/partners/invoices/upload | POST | 上传请求书PDF | |
| 4 | /api/v1/partners/invoices | GET | 获取上传文件列表 | |
| 5 | /api/v1/partners/invoices/{invoiceId}/preview | GET | 获取预览URL | |
| 6 | /api/v1/partners/invoices/{invoiceId} | DELETE | 删除上传文件 | |
| 7 | /api/v1/partners/invoices/{invoiceId}/send | POST | 发送请求书 | |
| 8 | /api/v1/partners/invoices/{invoiceId}/download | GET | 下载请求书 | |
| 9 | /api/v1/partners/messages | GET | 获取消息历史 | |
| 10 | /api/v1/partners/messages | POST | 发送消息 | |
| 11 | /api/v1/partners/messages/attachments/{attachmentId}/download | GET | 下载附件 | |

---

## 共用API清单

以下API被B系列和P系列页面共用：

| # | API端点 | 方法 | 使用页面 |
|---|---------|------|---------|
| 1 | /api/v1/auth/refresh | POST | b1, p1 |
| 2 | /api/v1/users/me | GET | b1, p1 |
| 3 | /api/v1/orders/search | GET | b2, p2 |
| 4 | /api/v1/orders/{orderId} | GET | b2, b3, p2, p3 |
| 5 | /api/v1/orders/{orderId}/update | PUT | b3, p3 |
| 6 | /api/v1/orders/{orderId}/status | PUT | b3, p3 |
| 7 | /api/v1/orders/{orderId}/documents | GET | b3, p3 |
| 8 | /api/v1/completed-orders/{completedOrderId} | GET | b4, b5 |
| 9 | /api/v1/billings/{billingId} | GET | b6, b7 |
| 10 | /api/v1/billings/{billingId}/update | PUT | b6, b7 |
| 11 | /api/v1/billings/{billingId}/status | PUT | b6, b7 |
| 12 | /api/v1/partners/{partnerId} | GET | b11, b12 |
| 13 | /api/v1/accounts/{accountId} | GET | b14, b15 |

---

## API 分类统计

### 按HTTP方法分类
| 方法 | 数量 | 占比 |
|------|------|------|
| GET | 48 | 50% |
| POST | 26 | 27% |
| PUT | 18 | 19% |
| DELETE | 4 | 4% |

### 按功能模块分类
| 模块 | API数量 |
|------|---------|
| 认证授权 | 7 |
| 订单管理 | 22 |
| 业绩管理 | 16 |
| 账单管理 | 14 |
| 文件上传 | 12 |
| 合作伙伴管理 | 6 |
| 基础账户管理 | 6 |
| 导航通知 | 3 |
| 操作历史 | 2 |
| 其他 | 8 |

---

## 数据库表参考

### 主表
- `m_order` - 订单表
- `t_completed_order` - 实绩表
- `m_billing` - 账单表
- `m_partner` - 合作伙伴表
- `m_user` - 用户表
- `m_account` - 账户表

### 关联表
- `r_order_document` - 订单文档关联
- `t_completed_order_document` - 实绩文档关联
- `r_partner_user` - 合作伙伴用户关联
- `r_user_role` - 用户角色关联

### 历史表
- `h_action` - 操作历史表
- `h_billing_status` - 账单状态历史
- `h_order_status` - 订单状态历史

---

## 认证方式

- **Azure AD OAuth 2.0 / OIDC**
- Token类型: Bearer Token
- Token刷新机制: Refresh Token
- 权限控制: 基于角色的访问控制 (RBAC)

---

*生成时间: 2026-02-10*
*数据来源: 別紙_画面一覧_v151 各页面设计规范文档*
