# ファイルアップロード・監査ログモジュールAPI設計書

## 📋 ドキュメント情報

| 項目 | 内容 |
|------|------|
| **モジュール名** | ファイルアップロード・監査ログ |
| **APIバージョン** | v1.0 |
| **ドキュメントバージョン** | v1.0 |
| **作成日** | 2026-02-XX|

---

## 1. ファイルアップロードAPI

### 1.1 アップロードAPI（ベース）

**エンドポイント**
```
POST /api/v1/uploads
```

**リクエスト（multipart/form-data）**

| パラメータ | タイプ | 必須 | 説明 |
|-----------|--------|------|------|
| file | File | Yes | アップロードファイル |
| uploadMode | string | No | add \| overwrite（デフォルト: add） |
| errorHandling | string | No | stop \| continue（デフォルト: stop） |
| memo | string | No | 備考 |

**リクエスト例**

```http
POST /api/v1/uploads
Authorization: Bearer {token}
Content-Type: multipart/form-data

file=@data.csv&uploadMode=add&errorHandling=stop&memo=2026年1月度データ
```

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "ファイルをアップロードしました",
  "data": {
    "uploadId": "UPL-2026-001",
    "fileName": "data.csv",
    "fileSize": 1024000,
    "status": "pending",
    "uploadedAt": "2026-02-xxT10:00:00Z"
  },
  "timestamp": "2026-02-xxT10:00:00Z"
}
```

---

### 1.2 アップロード履歴検索API

**エンドポイント**
```
GET /api/v1/uploads/history
```

**リクエストパラメータ**

| パラメータ | タイプ | 必須 | 説明 |
|-----------|--------|------|------|
| startDate | string | No | アップロード日（開始） |
| endDate | string | No | アップロード日（終了） |
| status | string | No | pending \| validating \| processing \| success \| failed |
| page | number | No | ページ番号 |
| pageSize | number | No | 1ページ件数 |

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "アップロード履歴を取得しました",
  "data": {
    "uploads": [
      {
        "uploadId": "UPL-2026-001",
        "fileName": "data.csv",
        "fileType": "csv",
        "fileSize": 1024000,
        "uploadMode": "add",
        "status": "success",
        "recordCount": 1000,
        "successCount": 998,
        "failedCount": 2,
        "uploadedAt": "2026-02-xxT10:00:00Z",
        "processedAt": "2026-02-xxT10:05:00Z",
        "processingTime": 300
      }
    ],
    "pagination": {
      "currentPage": 1,
      "pageSize": 20,
      "totalItems": 50,
      "totalPages": 3,
      "hasNext": true,
      "hasPrevious": false
    }
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

### 1.3 アップロード詳細取得API

**エンドポイント**
```
GET /api/v1/uploads/{uploadId}
```

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "アップロード詳細を取得しました",
  "data": {
    "uploadId": "UPL-2026-001",
    "fileName": "data.csv",
    "fileType": "csv",
    "fileSize": 1024000,
    "uploadMode": "add",
    "errorHandling": "stop",
    "status": "success",
    "recordCount": 1000,
    "successCount": 998,
    "failedCount": 2,
    "memo": "2026年1月度データ",
    "uploadedAt": "2026-02-xxT10:00:00Z",
    "processedAt": "2026-02-xxT10:05:00Z",
    "processingTime": 300,
    "errorDetails": [
      {
        "row": 500,
        "column": "amount",
        "errorType": "INVALID_FORMAT",
        "errorMessage": "金額は数値を入力してください",
        "originalValue": "abc"
      },
      {
        "row": 750,
        "column": "date",
        "errorType": "INVALID_DATE",
        "errorMessage": "日付形式が正しくありません",
        "originalValue": "2026-13-01"
      }
    ]
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

### 1.4 テンプレートダウンロードAPI

**エンドポイント**
```
GET /api/v1/uploads/templates/{templateType}
```

**パスパラメータ**

| パラメータ | タイプ | 必須 | 説明 |
|-----------|--------|------|------|
| templateType | string | Yes | completed-order \| order |

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "テンプレートをダウンロードできます",
  "data": {
    "templateId": "TPL-001",
    "fileName": "template_completed_order.xlsx",
    "downloadUrl": "https://storage.example.com/templates/xxx.xlsx",
    "expiresAt": "2026-02-xxT11:00:00Z"
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

### 1.5 パートナー：アップロードAPI

**エンドポイント**
```
POST /api/v1/partner/uploads
```

**リクエスト（multipart/form-data）**

| パラメータ | タイプ | 必須 | 説明 |
|-----------|--------|------|------|
| file | File | Yes | アップロードファイル |
| uploadMode | string | No | add \| overwrite |
| errorHandling | string | No | stop \| continue |
| memo | string | No | 備考 |

---

### 1.6 パートナー：アップロード履歴検索API

**エンドポイント**
```
GET /api/v1/partner/uploads/history
```

---

## 2. アクション履歴API

### 2.1 アクション履歴検索API

**エンドポイント**
```
GET /api/v1/action-history/search
```

**リクエストパラメータ**

| パラメータ | タイプ | 必須 | 説明 |
|-----------|--------|------|------|
| companyId | string | No | 会社ID |
| companyCode | string | No | 会社コード（部分一致） |
| companyName | string | No | 会社名（部分一致） |
| actionYearMonth | string | No | アクション年月 (YYYY-MM) |
| actionDateFrom | string | No | 日時（開始） |
| actionDateTo | string | No | 日時（終了） |
| actionType | string | No | アクションタイプ |
| performedBy | string | No | 実行者 |
| page | number | No | ページ番号 |
| pageSize | number | No | 1ページ件数 |

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "アクション履歴を取得しました",
  "data": {
    "history": [
      {
        "historyId": "HIST-001",
        "companyId": "C001",
        "companyCode": "ABC001",
        "companyName": "大賀輸送株式会社",
        "actionYearMonth": "2026-02",
        "actionDate": "2026-02-xxT10:30:00Z",
        "actionType": "ORDER_ACCEPTED",
        "actionDetail": "発注がパートナーに承諾されました",
        "performedBy": "佐藤次郎",
        "orderId": "ORD-2026-001",
        "remarks": null
      },
      {
        "historyId": "HIST-002",
        "companyId": "C001",
        "companyCode": "ABC001",
        "companyName": "大賀輸送株式会社",
        "actionYearMonth": "2026-02",
        "actionDate": "2026-02-xxT09:00:00Z",
        "actionType": "INSTRUCTION_SENT",
        "actionDetail": "運行指示書を送付しました（v1）",
        "performedBy": "田中太郎",
        "orderId": "ORD-2026-001",
        "remarks": null
      }
    ],
    "pagination": {
      "currentPage": 1,
      "pageSize": 20,
      "totalItems": 100,
      "totalPages": 5,
      "hasNext": true,
      "hasPrevious": false
    }
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

### 2.2 アクションタイプ一覧API

**エンドポイント**
```
GET /api/v1/action-history/types
```

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "アクションタイプ一覧を取得しました",
  "data": {
    "types": [
      {
        "type": "ORDER_CREATED",
        "name": "発注作成",
        "category": "order"
      },
      {
        "type": "INSTRUCTION_SENT",
        "name": "指示書送付",
        "category": "order"
      },
      {
        "type": "ORDER_ACCEPTED",
        "name": "発注承諾",
        "category": "order"
      },
      {
        "type": "ORDER_REJECTED",
        "name": "発注拒否",
        "category": "order"
      },
      {
        "type": "COMPLETED_ORDER_SENT",
        "name": "実績送付",
        "category": "completed-order"
      },
      {
        "type": "COMPLETED_ORDER_UPDATED",
        "name": "実績更新",
        "category": "completed-order"
      },
      {
        "type": "COMPLETED_ORDER_CONFIRMED",
        "name": "実績確定",
        "category": "completed-order"
      },
      {
        "type": "COMPLETED_ORDER_REJECTED",
        "name": "実績差戻し",
        "category": "completed-order"
      },
      {
        "type": "BILLING_ISSUED",
        "name": "請求発行",
        "category": "billing"
      },
      {
        "type": "BILLING_PAID",
        "name": "入金確認",
        "category": "billing"
      }
    ]
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

### 2.3 アクション履歴エクスポートAPI

**エンドポイント**
```
POST /api/v1/action-history/export
```

**リクエストボディ**

```json
{
  "companyId": "C001",
  "actionYearMonth": "2026-02",
  "format": "csv",
  "columns": [
    "companyCode",
    "companyName",
    "actionDate",
    "actionType",
    "actionDetail",
    "performedBy"
  ]
}
```

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "エクスポートを開始しました",
  "data": {
    "exportId": "EXP-001",
    "status": "processing",
    "downloadUrl": null,
    "estimatedCompletionTime": "2026-02-xxT10:35:00Z"
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

## 3. 外部システム連携API

### 3.1 AzureADユーザー情報取得API

**エンドポイント**
```
GET /api/v1/external/azure-ad/users/{userId}
```

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "AzureADユーザー情報を取得しました",
  "data": {
    "userId": "U001",
    "userName": "山田太郎",
    "email": "taro.yamada@company.co.jp",
    "department": "輸送部",
    "jobTitle": "部長",
    "azureAdId": "xxx-xxx-xxx",
    "lastLoginAt": "2026-02-xxT08:00:00Z"
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

### 3.2 AzureADユーザー検索API

**エンドポイント**
```
GET /api/v1/external/azure-ad/users/search
```

**リクエストパラメータ**

| パラメータ | タイプ | 必須 | 説明 |
|-----------|--------|------|------|
| query | string | No | 検索クエリ |
| department | string | No | 部署 |
| page | number | No | ページ番号 |
| pageSize | number | No | 1ページ件数 |

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "AzureADユーザーを検索しました",
  "data": {
    "users": [
      {
        "userId": "U001",
        "userName": "山田太郎",
        "email": "taro.yamada@company.co.jp",
        "department": "輸送部",
        "jobTitle": "部長"
      }
    ],
    "pagination": {
      "currentPage": 1,
      "pageSize": 20,
      "totalItems": 1,
      "totalPages": 1
    }
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

## 4. エラーコード

| エラーコード | HTTPステータス | 説明 |
|-------------|--------------|------|
| UPLOAD_FILE_EMPTY | 400 | ファイルが選択されていません |
| UPLOAD_FILE_TOO_LARGE | 400 | ファイルサイズ上限を超えています |
| UPLOAD_INVALID_FILE_TYPE | 400 | サポートされていないファイル形式です |
| UPLOAD_NOT_FOUND | 404 | アップロード履歴が見つかりません |
| UPLOAD_PROCESSING | 400 | 処理中のアップロードです |
| ACTION_HISTORY_NOT_FOUND | 404 | アクション履歴が見つかりません |
| EXPORT_IN_PROGRESS | 400 | エクスポート処理中です |
| EXTERNAL_SERVICE_ERROR | 500 | 外部システムエラーが発生しました |

---

## 5. アクションタイプ一覧

| アクションタイプ | 日本語名 | カテゴリー |
|-----------------|---------|-----------|
| ORDER_CREATED | 発注作成 | order |
| ORDER_UPDATED | 発注更新 | order |
| ORDER_SENT | 発注送付 | order |
| INSTRUCTION_SENT | 指示書送付 | order |
| INSTRUCTION_UPDATED | 指示書更新 | order |
| ORDER_ACCEPTED | 発注承諾 | order |
| ORDER_REJECTED | 発注拒否 | order |
| ORDER_EXPIRED | 発注期限切れ | order |
| COMPLETED_ORDER_SENT | 実績送付 | completed-order |
| COMPLETED_ORDER_UPDATED | 実績更新 | completed-order |
| COMPLETED_ORDER_CONFIRMED | 実績確定 | completed-order |
| COMPLETED_ORDER_REJECTED | 実績差戻し | completed-order |
| BILLING_CREATED | 請求作成 | billing |
| BILLING_ISSUED | 請求発行 | billing |
| BILLING_PAID | 入金確認 | billing |
| BILLING_CANCELLED | 請求取消 | billing |
| USER_CREATED | ユーザー作成 | user |
| USER_UPDATED | ユーザー更新 | user |
| USER_STATUS_CHANGED | ユーザー状態変更 | user |

---

## 6. 変更ログ

| 日付 | バージョン | 変更内容 | 作成者 |
|------|------|---------|------|
| 2026-02-XX| v1.0 | 初期バージョン | - |

---

**ドキュメント作成**: -  
**作成日時**: 2026-02-XX 
**適用範囲**: ファイルアップロード・監査ログモジュールAPI設計
