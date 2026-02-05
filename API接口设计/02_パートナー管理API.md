# パートナー管理モジュールAPI設計書

## 📋 ドキュメント情報

| 項目 | 内容 |
|------|------|
| **モジュール名** | パートナー管理 |
| **APIバージョン** | v1.0 |
| **ベースパス** | /api/v1/partners |
| **ドキュメントバージョン** | v1.0 |
| **作成日** | 2026-02-XX|

---

## 1. API一覧

| No. | エンドポイント | メソッド | 機能 | 画面 |
|-----|---------------|---------|------|------|
| 1 | /api/v1/partners/search | GET | パートナー検索 | b11 |
| 2 | /api/v1/partners/{companyId} | GET | パートナー詳細取得 | b12 |
| 3 | /api/v1/partners/{companyId} | PUT | パートナー情報更新 | b12 |
| 4 | /api/v1/partners/{companyId}/users | GET | 利用者一覧取得 | b12 |
| 5 | /api/v1/partners/{companyId}/users/{userId} | GET | 利用者詳細取得 | b13 |
| 6 | /api/v1/partners/{companyId}/users/{userId} | PUT | 利用者情報更新 | b13 |
| 7 | /api/v1/partners/{companyId}/users | POST | 利用者新規作成 | b13 |

---

## 2. パートナー検索API

### 2.1 エンドポイント

```
GET /api/v1/partners/search
```

### 2.2 リクエストパラメータ

| パラメータ | タイプ | 必須 | 説明 |
|-----------|--------|------|------|
| companyCode | string | No | 会社コード（部分一致） |
| companyName | string | No | 会社名（部分一致） |
| phone | string | No | 電話番号（部分一致） |
| systemUse | boolean | No | システム利用フラグ |
| page | number | No | ページ番号（デフォルト: 1） |
| pageSize | number | No | 1ページ件数（デフォルト: 20） |
| sort | string | No | 並び替えフィールド |
| sortOrder | string | No | asc \| desc |

### 2.3 リクエスト例

```http
GET /api/v1/partners/search?companyName=大賀&systemUse=true&page=1&pageSize=20
Authorization: Bearer {token}
```

### 2.4 レスポンス

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "パートナー一覧を取得しました",
  "data": {
    "partners": [
      {
        "companyId": "C001",
        "companyName": "大賀輸送株式会社",
        "companyPhone": "03-1234-5678",
        "systemUse": true,
        "instructionText": "文言1",
        "userCount": 5,
        "lastLoginAt": "2026-02-03T10:30:00Z"
      }
    ],
    "pagination": {
      "currentPage": 1,
      "pageSize": 20,
      "totalItems": 100,
      "totalPages": 5,
      "hasNext": true,
      "hasPrevious": false
    },
    "summary": {
      "totalCount": 100,
      "systemUseCount": 80,
      "systemNotUseCount": 20
    }
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

## 3. パートナー詳細取得API

### 3.1 エンドポイント

```
GET /api/v1/partners/{companyId}
```

### 3.2 パスパラメータ

| パラメータ | タイプ | 必須 | 説明 |
|-----------|--------|------|------|
| companyId | string | Yes | 会社ID |

### 3.3 レスポンス

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "パートナー詳細を取得しました",
  "data": {
    "companyId": "C001",
    "companyName": "大賀輸送株式会社",
    "companyPhone": "03-1234-5678",
    "companyCodes": ["ABC001", "ABC002"],
    "systemUse": true,
    "instructionText": "文言1",
    "users": [
      {
        "userId": "U001",
        "email": "user1@ohga.co.jp",
        "accountType": "main",
        "branchName": null,
        "accountStatus": "active",
        "lastLoginAt": "2026-02-03T10:30:00Z"
      },
      {
        "userId": "U002",
        "email": "user2@ohga.co.jp",
        "accountType": "sub",
        "branchName": "東京支社",
        "accountStatus": "active",
        "lastLoginAt": "2026-02-02T15:45:00Z"
      }
    ],
    "createdAt": "2024-01-15T09:00:00Z",
    "updatedAt": "2026-02-xxT08:30:00Z"
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

## 4. パートナー情報更新API

### 4.1 エンドポイント

```
PUT /api/v1/partners/{companyId}
```

### 4.2 リクエストボディ

```json
{
  "updateData": {
    "companyName": "大賀輸送株式会社",
    "companyPhone": "03-1234-5678",
    "companyCodes": ["ABC001", "ABC002", "ABC003"],
    "systemUse": true,
    "instructionText": "文言2",
    "memo": "備考情報"
  }
}
```

### 4.3 フィールド仕様

| フィールド | タイプ | 必須 | バリデーション |
|-----------|--------|------|---------------|
| companyName | string | No | 最大200文字 |
| companyPhone | string | No | 10-11桁の数字 |
| companyCodes | string[] | No | 半角英数字、カンマ区切り |
| systemUse | boolean | No | true \| false |
| instructionText | string | No | 文言1 \| 文言2 \| 文言3 |
| memo | string | No | 最大1000文字 |

### 4.4 レスポンス

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "パートナー情報を更新しました",
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

## 5. 利用者一覧取得API

### 5.1 エンドポイント

```
GET /api/v1/partners/{companyId}/users
```

### 5.2 リクエストパラメータ

| パラメータ | タイプ | 必須 | 説明 |
|-----------|--------|------|------|
| companyId | string | Yes | 会社ID |
| accountStatus | string | No | active \| inactive |
| accountType | string | No | main \| sub |
| page | number | No | ページ番号 |
| pageSize | number | No | 1ページ件数 |

### 5.3 レスポンス

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "利用者一覧を取得しました",
  "data": {
    "users": [
      {
        "userId": "U001",
        "email": "user1@ohga.co.jp",
        "accountType": "main",
        "branchName": null,
        "accountStatus": "active",
        "createdAt": "2024-01-15T09:00:00Z"
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

## 6. 利用者詳細取得API

### 6.1 エンドポイント

```
GET /api/v1/partners/{companyId}/users/{userId}
```

### 6.2 レスポンス

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "利用者詳細を取得しました",
  "data": {
    "userId": "U001",
    "companyId": "C001",
    "email": "user1@ohga.co.jp",
    "personalSms": "090-1234-5678",
    "notificationTarget": "mail",
    "accountType": "main",
    "subAccountNotification": "yes",
    "branchName": null,
    "accountStatus": "active",
    "createdAt": "2024-01-15T09:00:00Z",
    "updatedAt": "2026-02-xxT08:30:00Z"
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

## 7. 利用者情報更新API

### 7.1 エンドポイント

```
PUT /api/v1/partners/{companyId}/users/{userId}
```

### 7.2 リクエストボディ

```json
{
  "updateData": {
    "notificationTarget": "sms",
    "accountType": "sub",
    "subAccountNotification": "no",
    "branchName": "大阪支社",
    "accountStatus": "active"
  }
}
```

### 7.3 フィールド仕様

| フィールド | タイプ | 必須 | バリデーション |
|-----------|--------|------|---------------|
| notificationTarget | string | No | mail \| sms |
| accountType | string | No | main \| sub |
| subAccountNotification | string | No | accountType=mainの場合必須: yes \| no |
| branchName | string | No | accountType=subの場合必須, 最大200文字 |
| accountStatus | string | No | active \| inactive |

### 7.4 ビジネスルール

1. **メイン→サブへの変更時**:
   - `subAccountNotification` は NULL に設定
   - `branchName` は必須

2. **サブ→メインへの変更時**:
   - `branchName` は NULL に設定
   - `subAccountNotification` は必須

3. **最後の管理者の無効化**:
   - 会社が持つ最後のメインアカウントは無効化不可

---

## 8. 利用者新規作成API

### 8.1 エンドポイント

```
POST /api/v1/partners/{companyId}/users
```

### 8.2 リクエストボディ

```json
{
  "userId": "U003",
  "notificationTarget": "mail",
  "accountType": "sub",
  "subAccountNotification": null,
  "branchName": "福岡支社",
  "accountStatus": "active"
}
```

### 8.3 レスポンス

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "利用者を新規作成しました",
  "data": {
    "userId": "U003",
    "createdAt": "2026-02-xxT10:30:00Z"
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

## 9. エラーコード

| エラーコード | HTTPステータス | 説明 |
|-------------|--------------|------|
| PARTNER_NOT_FOUND | 404 | パートナーが見つかりません |
| USER_NOT_FOUND | 404 | ユーザーが見つかりません |
| DUPLICATE_USER | 409 | ユーザーが既に存在します |
| INVALID_PHONE_NUMBER | 400 | 電話番号の形式が正しくありません |
| INVALID_EMAIL | 400 | メールアドレスの形式が正しくありません |
| LAST_ADMIN_ERROR | 400 | 最後の管理者は無効化できません |
| INVALID_REQUEST | 400 | リクエストが無効です |

---

## 10. 変更ログ

| 日付 | バージョン | 変更内容 | 作成者 |
|------|------|---------|------|
| 2026-02-XX| v1.0 | 初期バージョン | - |

---

**ドキュメント作成**: -  
**作成日時**: 2026-02-XX 
**適用範囲**: パートナー管理モジュールAPI設計
