# 発注モジュールAPI設計書

## 📋 ドキュメント情報

| 項目 | 内容 |
|------|------|
| **モジュール名** | 発注管理 |
| **APIバージョン** | v1.0 |
| **ベースパス** | /api/v1/orders |
| **ドキュメントバージョン** | v1.0 |
| **作成日** | 2026-02-XX|

---

## 1. API一覧

| No. | エンドポイント | メソッド | 機能 | 画面 |
|-----|---------------|---------|------|------|
| 1 | /api/v1/orders/search | GET | 発注検索 | b2 |
| 2 | /api/v1/orders/{orderId} | GET | 発注詳細取得 | b3 |
| 3 | /api/v1/orders/{orderId} | PUT | 発注情報更新 | b3 |
| 4 | /api/v1/orders/{orderId}/instructions | GET | 運行指示書一覧取得 | b3 |
| 5 | /api/v1/orders/{orderId}/instructions | PUT | 運行指示書更新 | b3 |
| 6 | /api/v1/orders/{orderId}/send | POST | 指示書送付 | b3 |
| 7 | /api/v1/orders/{orderId}/accept | POST | 承諾 | p3 |
| 8 | /api/v1/orders/{orderId}/reject | POST | 拒否 | p3 |
| 9 | /api/v1/orders/{orderId}/messages | GET | メッセージ一覧取得 | b3, p3 |
| 10 | /api/v1/orders/{orderId}/messages | POST | メッセージ送信 | b3, p3 |
| 11 | /api/v1/orders/{orderId}/history | GET | アクション履歴取得 | b3 |
| 12 | /api/v1/partner/orders/search | GET | パートナー発注検索 | p2 |
| 13 | /api/v1/partner/orders/{orderId} | GET | パートナー発注詳細取得 | p3 |

---

## 2. 発注検索API（ベース）

### 2.1 エンドポイント

```
GET /api/v1/orders/search
```

### 2.2 リクエストパラメータ

| パラメータ | タイプ | 必須 | 説明 |
|-----------|--------|------|------|
| companyId | string | No | 会社ID |
| companyCode | string | No | 会社コード（部分一致） |
| orderYearMonth | string | No | 発注年月 (YYYY-MM) |
| status | string | No | pending \| accepted \| rejected |
| requestDateFrom | string | No | 依頼日（開始） |
| requestDateTo | string | No | 依頼日（終了） |
| page | number | No | ページ番号 |
| pageSize | number | No | 1ページ件数 |

### 2.3 レスポンス

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "発注一覧を取得しました",
  "data": {
    "orders": [
      {
        "orderId": "ORD-2026-001",
        "companyId": "C001",
        "companyCode": "ABC001",
        "companyName": "大賀輸送株式会社",
        "orderYearMonth": "2026-02",
        "status": "pending",
        "requestDate": "2026-02-01",
        "deadline": "2026-02-10",
        "version": 1,
        "sentAt": null,
        "acceptedAt": null
      }
    ],
    "pagination": {
      "currentPage": 1,
      "pageSize": 20,
      "totalItems": 50,
      "totalPages": 3,
      "hasNext": true,
      "hasPrevious": false
    },
    "summary": {
      "totalCount": 50,
      "pendingCount": 30,
      "acceptedCount": 15,
      "rejectedCount": 5
    }
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

## 3. 発注詳細取得API

### 3.1 エンドポイント

```
GET /api/v1/orders/{orderId}
```

### 3.2 レスポンス

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "発注詳細を取得しました",
  "data": {
    "orderId": "ORD-2026-001",
    "companyId": "C001",
    "companyCode": "ABC001",
    "companyName": "大賀輸送株式会社",
    "orderYearMonth": "2026-02",
    "status": "pending",
    "requestDetail": "2月度輸送依頼",
    "requestDate": "2026-02-01",
    "deadline": "2026-02-10",
    "version": 1,
    "partnerMemo": null,
    "sentAt": "2026-02-01T09:00:00Z",
    "acceptedAt": null,
    "rejectedAt": null,
    "rejectedReason": null,
    "createdAt": "2026-02-01T08:00:00Z",
    "updatedAt": "2026-02-01T09:00:00Z",
    "instructions": [
      {
        "version": 1,
        "status": "pending",
        "sentAt": "2026-02-01T09:00:00Z",
        "confirmedAt": null,
        "scheduleCount": 28
      }
    ]
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

## 4. 発注情報更新API

### 4.1 エンドポイント

```
PUT /api/v1/orders/{orderId}
```

### 4.2 リクエストボディ

```json
{
  "updateData": {
    "requestDetail": "2月度輸送依頼（修正版）",
    "deadline": "2026-02-15"
  }
}
```

### 4.3 レスポンス

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "発注情報を更新しました",
  "data": {
    "orderId": "ORD-2026-001",
    "version": 2,
    "updatedAt": "2026-02-xxT11:00:00Z"
  },
  "timestamp": "2026-02-xxT11:00:00Z"
}
```

---

## 5. 運行指示書一覧取得API

### 5.1 エンドポイント

```
GET /api/v1/orders/{orderId}/instructions
```

### 5.2 レスポンス

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "運行指示書一覧を取得しました",
  "data": {
    "orderId": "ORD-2026-001",
    "currentVersion": 2,
    "instructions": [
      {
        "version": 1,
        "status": "rejected",
        "sentAt": "2026-02-01T09:00:00Z",
        "confirmedAt": null,
        "confirmedBy": null,
        "changeCount": 5,
        "schedules": [
          {
            "scheduleId": "SCH-001",
            "lineCode": "L001",
            "lineName": "東京-大阪線",
            "branchName": "東京支社",
            "scheduleDate": "2026-02-02",
            "morningFlag": true,
            "afternoonFlag": false,
            "weekMonday": true,
            "weekTuesday": true,
            "weekWednesday": true,
            "weekThursday": true,
            "weekFriday": true,
            "weekSaturday": false,
            "weekSunday": false,
            "isHoliday": false,
            "changeFlag": false
          }
        ]
      },
      {
        "version": 2,
        "status": "pending",
        "sentAt": null,
        "confirmedAt": null,
        "confirmedBy": null,
        "changeCount": 3,
        "schedules": [
          {
            "scheduleId": "SCH-002",
            "lineCode": "L001",
            "lineName": "東京-大阪線",
            "branchName": "東京支社",
            "scheduleDate": "2026-02-02",
            "morningFlag": true,
            "afternoonFlag": false,
            "weekMonday": true,
            "weekTuesday": true,
            "weekWednesday": true,
            "weekThursday": true,
            "weekFriday": true,
            "weekSaturday": false,
            "weekSunday": false,
            "isHoliday": false,
            "changeFlag": true,
            "changeDetail": "AM便に追加便を設定"
          }
        ]
      }
    ]
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

## 6. 運行指示書更新API

### 6.1 エンドポイント

```
PUT /api/v1/orders/{orderId}/instructions
```

### 6.2 リクエストボディ

```json
{
  "version": 2,
  "changes": [
    {
      "scheduleId": "SCH-002",
      "morningFlag": false,
      "afternoonFlag": true,
      "changeDetail": "午後に変更"
    }
  ]
}
```

### 6.3 レスポンス

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "運行指示書を更新しました",
  "data": {
    "orderId": "ORD-2026-001",
    "version": 2,
    "changedCount": 1,
    "updatedAt": "2026-02-xxT11:00:00Z"
  },
  "timestamp": "2026-02-xxT11:00:00Z"
}
```

---

## 7. 指示書送付API

### 7.1 エンドポイント

```
POST /api/v1/orders/{orderId}/send
```

### 7.2 リクエストボディ

```json
{
  "version": 2,
  "notifyPartner": true
}
```

### 7.3 レスポンス

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "指示書を送付しました",
  "data": {
    "orderId": "ORD-2026-001",
    "version": 2,
    "sentAt": "2026-02-xxT11:00:00Z",
    "notificationSent": true
  },
  "timestamp": "2026-02-xxT11:00:00Z"
}
```

---

## 8. パートナー：承諾API

### 8.1 エンドポイント

```
POST /api/v1/partner/orders/{orderId}/accept
```

### 8.2 リクエストボディ

```json
{
  "memo": "承諾しました"
}
```

### 8.3 レスポンス

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "発注を承諾しました",
  "data": {
    "orderId": "ORD-2026-001",
    "status": "accepted",
    "acceptedAt": "2026-02-xxT12:00:00Z"
  },
  "timestamp": "2026-02-xxT12:00:00Z"
}
```

---

## 9. パートナー：拒否API

### 9.1 エンドポイント

```
POST /api/v1/partner/orders/{orderId}/reject
```

### 9.2 リクエストボディ

```json
{
  "reason": "スケジュールが合わないため"
}
```

### 9.3 レスポンス

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "発注を拒否しました",
  "data": {
    "orderId": "ORD-2026-001",
    "status": "rejected",
    "rejectedAt": "2026-02-xxT12:00:00Z",
    "rejectedReason": "スケジュールが合わないため"
  },
  "timestamp": "2026-02-xxT12:00:00Z"
}
```

---

## 10. メッセージ一覧取得API

### 10.1 エンドポイント

```
GET /api/v1/orders/{orderId}/messages
```

### 10.2 レスポンス

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "メッセージ一覧を取得しました",
  "data": {
    "messages": [
      {
        "messageId": "MSG-001",
        "senderId": "U001",
        "senderType": "base",
        "senderName": "田中太郎",
        "content": "指示書を送付しましたのでご確認ください",
        "isRead": true,
        "createdAt": "2026-02-xxT09:00:00Z"
      },
      {
        "messageId": "MSG-002",
        "senderId": "U100",
        "senderType": "partner",
        "senderName": "佐藤次郎",
        "content": "確認しました。承諾します",
        "isRead": false,
        "createdAt": "2026-02-xxT12:00:00Z"
      }
    ],
    "unreadCount": 1
  },
  "timestamp": "2026-02-xxT12:30:00Z"
}
```

---

## 11. メッセージ送信API

### 11.1 エンドポイント

```
POST /api/v1/orders/{orderId}/messages
```

### 11.2 リクエストボディ

```json
{
  "content": "メッセージ内容",
  "attachments": [
    {
      "fileName": "document.pdf",
      "fileUrl": "https://storage.example.com/files/xxx"
    }
  ]
}
```

### 11.3 レスポンス

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "メッセージを送信しました",
  "data": {
    "messageId": "MSG-003",
    "createdAt": "2026-02-xxT12:30:00Z"
  },
  "timestamp": "2026-02-xxT12:30:00Z"
}
```

---

## 12. アクション履歴取得API

### 12.1 エンドポイント

```
GET /api/v1/orders/{orderId}/history
```

### 12.2 レスポンス

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "アクション履歴を取得しました",
  "data": {
    "history": [
      {
        "historyId": "HIST-001",
        "actionType": "ORDER_CREATED",
        "actionDetail": "発注が作成されました",
        "performedBy": "田中太郎",
        "performedAt": "2026-02-01T08:00:00Z"
      },
      {
        "historyId": "HIST-002",
        "actionType": "INSTRUCTION_SENT",
        "actionDetail": "運行指示書を送付しました（v1）",
        "performedBy": "システム",
        "performedAt": "2026-02-01T09:00:00Z"
      },
      {
        "historyId": "HIST-003",
        "actionType": "ORDER_ACCEPTED",
        "actionDetail": "パートナーに承諾されました",
        "performedBy": "佐藤次郎",
        "performedAt": "2026-02-xxT12:00:00Z"
      }
    ]
  },
  "timestamp": "2026-02-xxT12:30:00Z"
}
```

---

## 13. パートナー：発注検索API

### 13.1 エンドポイント

```
GET /api/v1/partner/orders/search
```

### 13.2 レスポンス

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "パートナー発注一覧を取得しました",
  "data": {
    "orders": [
      {
        "orderId": "ORD-2026-001",
        "baseName": "東京ベース",
        "orderYearMonth": "2026-02",
        "status": "accepted",
        "requestDetail": "2月度輸送依頼",
        "requestDate": "2026-02-01",
        "deadline": "2026-02-10",
        "sentAt": "2026-02-01T09:00:00Z",
        "acceptedAt": "2026-02-xxT12:00:00Z"
      }
    ],
    "pagination": {
      "currentPage": 1,
      "pageSize": 20,
      "totalItems": 10,
      "totalPages": 1,
      "hasNext": false,
      "hasPrevious": false
    }
  },
  "timestamp": "2026-02-xxT12:30:00Z"
}
```

---

## 14. エラーコード

| エラーコード | HTTPステータス | 説明 |
|-------------|--------------|------|
| ORDER_NOT_FOUND | 404 | 発注が見つかりません |
| INVALID_VERSION | 400 | バージョンが一致しません |
| INVALID_STATUS_TRANSITION | 400 | ステータス遷移が無効です |
| INSTRUCTION_ALREADY_SENT | 400 | 既に送付済みです |
| ORDER_EXPIRED | 400 | 発注期限切れです |
| ACCEPTANCE_WINDOW_CLOSED | 400 | 承諾期間外です |
| PERMISSION_DENIED | 403 | この発注にアクセス権限がありません |

---

## 15. ステータス遷移

```
【ベース側】
pending ──更新──► pending
    │
    ├──送付──► pending（送付済）
    │
    └──取消──► cancelled

【パートナー側】
pending（送付済）──承諾──► accepted
    │
    └──拒否──► rejected

【ベース側（承認後）】
accepted ──差戻し──► pending（送付済）
```

---

## 16. 変更ログ

| 日付 | バージョン | 変更内容 | 作成者 |
|------|------|---------|------|
| 2026-02-XX| v1.0 | 初期バージョン | - |

---

**ドキュメント作成**: -  
**作成日時**: 2026-02-XX 
**適用範囲**: 発注管理モジュールAPI設計
