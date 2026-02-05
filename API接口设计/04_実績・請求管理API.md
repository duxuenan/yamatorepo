# 実績・請求モジュールAPI設計書

## 📋 ドキュメント情報

| 項目 | 内容 |
|------|------|
| **モジュール名** | 実績・請求管理 |
| **APIバージョン** | v1.0 |
| **ドキュメントバージョン** | v1.0 |
| **作成日** | 2026-02-XX|

---

## 1. 実績管理API

### 1.1 ベース：実績検索API

**エンドポイント**
```
GET /api/v1/completed-orders/search
```

**リクエストパラメータ**

| パラメータ | タイプ | 必須 | 説明 |
|-----------|--------|------|------|
| companyId | string | No | 会社ID |
| companyCode | string | No | 会社コード（部分一致） |
| completedOrderYearMonth | string | No | 実績年月 (YYYY-MM) |
| status | string | No | pending \| confirmed \| rejected |
| page | number | No | ページ番号 |
| pageSize | number | No | 1ページ件数 |

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "実績一覧を取得しました",
  "data": {
    "completedOrders": [
      {
        "completedOrderId": "PERF-2026-001",
        "orderId": "ORD-2026-001",
        "companyId": "C001",
        "companyCode": "ABC001",
        "companyName": "大賀輸送株式会社",
        "completedOrderYearMonth": "2026-01",
        "totalAmount": 1500000,
        "status": "confirmed",
        "version": 1,
        "sentAt": "2026-02-01T09:00:00Z",
        "confirmedAt": "2026-02-03T10:00:00Z"
      }
    ],
    "pagination": {
      "currentPage": 1,
      "pageSize": 20,
      "totalItems": 30,
      "totalPages": 2,
      "hasNext": true,
      "hasPrevious": false
    },
    "summary": {
      "totalCount": 30,
      "pendingCount": 10,
      "confirmedCount": 18,
      "rejectedCount": 2,
      "totalAmount": 45000000
    }
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

### 1.2 ベース：実績詳細取得API

**エンドポイント**
```
GET /api/v1/completedOrders/{completedOrderId}
```

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "実績詳細を取得しました",
  "data": {
    "completedOrderId": "PERF-2026-001",
    "orderId": "ORD-2026-001",
    "companyId": "C001",
    "companyName": "大賀輸送株式会社",
    "completedOrderYearMonth": "2026-01",
    "totalAmount": 1500000,
    "status": "confirmed",
    "version": 2,
    "sentAt": "2026-02-01T09:00:00Z",
    "confirmedAt": "2026-02-03T10:00:00Z",
    "acceptedAt": "2026-02-03T15:00:00Z",
    "dailyRates": [
      {
        "rateId": "RATE-001",
        "lineCode": "L001",
        "lineName": "東京-大阪線",
        "version": 2,
        "amountMonday": 50000,
        "amountTuesday": 50000,
        "amountWednesday": 50000,
        "amountThursday": 50000,
        "amountFriday": 50000,
        "amountSaturday": 0,
        "amountSunday": 0,
        "status": "confirmed"
      }
    ],
    "createdAt": "2026-02-01T08:00:00Z",
    "updatedAt": "2026-02-03T10:00:00Z"
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

### 1.3 ベース：日別傭車費更新API

**エンドポイント**
```
PUT /api/v1/completedOrders/{completedOrderId}/daily-costs
```

**リクエストボディ**

```json
{
  "version": 2,
  "changes": [
    {
      "rateId": "RATE-001",
      "amountMonday": 55000,
      "changeDetail": "単価改定により"
    }
  ]
}
```

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "日別傭車費を更新しました",
  "data": {
    "completedOrderId": "PERF-2026-001",
    "version": 2,
    "changedCount": 1,
    "totalAmount": 1550000,
    "updatedAt": "2026-02-xxT11:00:00Z"
  },
  "timestamp": "2026-02-xxT11:00:00Z"
}
```

---

### 1.4 ベース：実績送付API

**エンドポイント**
```
POST /api/v1/completedOrders/{completedOrderId}/send
```

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "実績を送付しました",
  "data": {
    "completedOrderId": "PERF-2026-001",
    "status": "pending",
    "version": 2,
    "sentAt": "2026-02-xxT11:00:00Z"
  },
  "timestamp": "2026-02-xxT11:00:00Z"
}
```

---

### 1.5 ベース：差戻しAPI

**エンドポイント**
```
POST /api/v1/completedOrders/{completedOrderId}/reject
```

**リクエストボディ**

```json
{
  "reason": "単価に相違があります",
  "details": [
    {
      "rateId": "RATE-001",
      "field": "amountMonday",
      "expectedValue": 45000,
      "actualValue": 50000
    }
  ]
}
```

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "実績を差戻ししました",
  "data": {
    "completedOrderId": "PERF-2026-001",
    "status": "rejected",
    "rejectedAt": "2026-02-xxT11:00:00Z"
  },
  "timestamp": "2026-02-xxT11:00:00Z"
}
```

---

### 1.6 パートナー：実績確認API

**エンドポイント**
```
GET /api/v1/partner/completedOrders/{completedOrderId}
```

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "実績詳細を取得しました",
  "data": {
    "completedOrderId": "PERF-2026-001",
    "baseName": "東京ベース",
    "completedOrderYearMonth": "2026-01",
    "totalAmount": 1500000,
    "status": "confirmed",
    "version": 2,
    "sentAt": "2026-02-01T09:00:00Z",
    "dailyRates": [
      {
        "lineCode": "L001",
        "lineName": "東京-大阪線",
        "amountMonday": 50000,
        "amountTuesday": 50000,
        "amountWednesday": 50000,
        "amountThursday": 50000,
        "amountFriday": 50000,
        "amountSaturday": 0,
        "amountSunday": 0,
        "totalAmount": 250000,
        "status": "confirmed"
      }
    ],
    "acceptedAt": "2026-02-03T15:00:00Z"
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

## 2. 請求管理API

### 2.1 ベース：請求検索API

**エンドポイント**
```
GET /api/v1/billings/search
```

**リクエストパラメータ**

| パラメータ | タイプ | 必須 | 説明 |
|-----------|--------|------|------|
| companyId | string | No | 会社ID |
| companyCode | string | No | 会社コード（部分一致） |
| billingYearMonth | string | No | 請求年月 (YYYY-MM) |
| status | string | No | pending \| issued \| paid \| cancelled |
| issueDateFrom | string | No | 発行日（開始） |
| issueDateTo | string | No | 発行日（終了） |
| page | number | No | ページ番号 |
| pageSize | number | No | 1ページ件数 |

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "請求一覧を取得しました",
  "data": {
    "billings": [
      {
        "billingId": "BILL-2026-001",
        "companyId": "C001",
        "companyCode": "ABC001",
        "companyName": "大賀輸送株式会社",
        "billingYearMonth": "2026-01",
        "amount": 1500000,
        "status": "issued",
        "issueDate": "2026-02-05",
        "dueDate": "2026-02-28"
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
      "pendingCount": 10,
      "issuedCount": 30,
      "paidCount": 8,
      "cancelledCount": 2,
      "totalAmount": 75000000
    }
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

### 2.2 ベース：請求詳細取得API

**エンドポイント**
```
GET /api/v1/billings/{billingId}
```

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "請求詳細を取得しました",
  "data": {
    "billingId": "BILL-2026-001",
    "companyId": "C001",
    "companyCode": "ABC001",
    "companyName": "大賀輸送株式会社",
    "billingYearMonth": "2026-01",
    "baseName": "東京ベース",
    "amount": 1500000,
    "status": "issued",
    "issueDate": "2026-02-05",
    "dueDate": "2026-02-28",
    "paidDate": null,
    "memo": "2026年1月度輸送費用",
    "details": [
      {
        "detailId": "DET-001",
        "lineCode": "L001",
        "lineName": "東京-大阪線",
        "dailyRate": 50000,
        "days": 20,
        "amount": 1000000
      },
      {
        "detailId": "DET-002",
        "lineCode": "L002",
        "lineName": "東京-名古屋線",
        "dailyRate": 25000,
        "days": 20,
        "amount": 500000
      }
    ],
    "createdAt": "2026-02-05T08:00:00Z",
    "updatedAt": "2026-02-05T08:00:00Z"
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

### 2.3 ベース：請求発行API

**エンドポイント**
```
POST /api/v1/billings/{billingId}/issue
```

**リクエストボディ**

```json
{
  "issueDate": "2026-02-05",
  "dueDate": "2026-02-28",
  "memo": "2026年1月度輸送費用"
}
```

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "請求を発行しました",
  "data": {
    "billingId": "BILL-2026-001",
    "status": "issued",
    "issueDate": "2026-02-05",
    "dueDate": "2026-02-28",
    "issuedAt": "2026-02-05T08:00:00Z"
  },
  "timestamp": "2026-02-05T08:00:00Z"
}
```

---

### 2.4 ベース：請求取消API

**エンドポイント**
```
POST /api/v1/billings/{billingId}/cancel
```

**リクエストボディ**

```json
{
  "reason": "請求内容に誤りがありました"
}
```

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "請求を取消しました",
  "data": {
    "billingId": "BILL-2026-001",
    "status": "cancelled",
    "cancelledAt": "2026-02-05T09:00:00Z"
  },
  "timestamp": "2026-02-05T09:00:00Z"
}
```

---

### 2.5 パートナー：請求検索API

**エンドポイント**
```
GET /api/v1/partner/billings/search
```

**リクエストパラメータ**

| パラメータ | タイプ | 必須 | 説明 |
|-----------|--------|------|------|
| billingYearMonth | string | No | 請求年月 (YYYY-MM) |
| status | string | No | pending \| issued \| paid |
| page | number | No | ページ番号 |
| pageSize | number | No | 1ページ件数 |

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "パートナー請求一覧を取得しました",
  "data": {
    "billings": [
      {
        "billingId": "BILL-2026-001",
        "billingYearMonth": "2026-01",
        "baseName": "東京ベース",
        "amount": 1500000,
        "status": "issued",
        "issueDate": "2026-02-05",
        "dueDate": "2026-02-28"
      }
    ],
    "pagination": {
      "currentPage": 1,
      "pageSize": 20,
      "totalItems": 5,
      "totalPages": 1,
      "hasNext": false,
      "hasPrevious": false
    }
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

### 2.6 パートナー：請求詳細API

**エンドポイント**
```
GET /api/v1/partner/billings/{billingId}
```

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "パートナー請求詳細を取得しました",
  "data": {
    "billingId": "BILL-2026-001",
    "billingYearMonth": "2026-01",
    "baseName": "東京ベース",
    "amount": 1500000,
    "status": "issued",
    "issueDate": "2026-02-05",
    "dueDate": "2026-02-28",
    "details": [
      {
        "lineCode": "L001",
        "lineName": "東京-大阪線",
        "dailyRate": 50000,
        "days": 20,
        "amount": 1000000
      }
    ],
    "attachments": [
      {
        "attachmentId": "ATT-001",
        "fileName": "請求書_BILL-2026-001.pdf",
        "fileUrl": "https://storage.example.com/billings/xxx.pdf",
        "uploadedAt": "2026-02-05T08:00:00Z"
      }
    ]
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

### 2.7 パートナー：請求書ダウンロードAPI

**エンドポイント**
```
POST /api/v1/partner/billings/download
```

**リクエストボディ**

```json
{
  "billingIds": ["BILL-2026-001", "BILL-2026-002"]
}
```

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "請求書をダウンロードできます",
  "data": {
    "downloadUrl": "https://storage.example.com/downloads/xxx.zip",
    "expiresAt": "2026-02-xxT12:30:00Z",
    "fileName": "請求書_2026-01.zip",
    "fileSize": 1024000
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

## 3. エラーコード

| エラーコード | HTTPステータス | 説明 |
|-------------|--------------|------|
| COMPLETED_ORDER_NOT_FOUND | 404 | 実績が見つかりません |
| BILLING_NOT_FOUND | 404 | 請求が見つかりません |
| INVALID_VERSION | 400 | バージョンが一致しません |
| RATE_ALREADY_CONFIRMED | 400 | 既に確定済みです |
| BILLING_ALREADY_ISSUED | 400 | 既に発行済みです |
| BILLING_ALREADY_PAID | 400 | 既に支払済みです |
| INVALID_STATUS_TRANSITION | 400 | ステータス遷移が無効です |
| AMOUNT_MISMATCH | 400 | 金額に相違があります |

---

## 4. 変更ログ

| 日付 | バージョン | 変更内容 | 作成者 |
|------|------|---------|------|
| 2026-02-XX| v1.0 | 初期バージョン | - |

---

**ドキュメント作成**: -  
**作成日時**: 2026-02-XX 
**適用範囲**: 実績・請求管理モジュールAPI設計
