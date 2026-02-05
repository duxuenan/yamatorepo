# ベースアカウント・マスタ管理モジュールAPI設計書

## 📋 ドキュメント情報

| 項目 | 内容 |
|------|------|
| **モジュール名** | ベースアカウント・マスタ管理 |
| **APIバージョン** | v1.0 |
| **ドキュメントバージョン** | v1.0 |
| **作成日** | 2026-02-XX|

---

## 1. ベースアカウント管理API

### 1.1 ベースアカウント検索API

**エンドポイント**
```
GET /api/v1/base-accounts/search
```

**リクエストパラメータ**

| パラメータ | タイプ | 必須 | 説明 |
|-----------|--------|------|------|
| userId | string | No | ユーザーID（部分一致） |
| email | string | No | メールアドレス（部分一致） |
| userName | string | No | ユーザー名（部分一致） |
| affiliation | string | No | 所属（部分一致） |
| permission | string | No | admin \| operator \| dispatcher \| accountant |
| accountStatus | string | No | active \| inactive |
| page | number | No | ページ番号 |
| pageSize | number | No | 1ページ件数 |
| sort | string | No | 並び替えフィールド |
| sortOrder | string | No | asc \| desc |

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "ベースアカウント一覧を取得しました",
  "data": {
    "accounts": [
      {
        "userId": "BA001",
        "userName": "田中太郎",
        "email": "tanaka@company.co.jp",
        "affiliation": "東京ベース",
        "permission": "admin",
        "accountStatus": "active",
        "lastLoginAt": "2026-02-xxT08:00:00Z"
      },
      {
        "userId": "BA002",
        "userName": "鈴木一郎",
        "email": "suzuki@company.co.jp",
        "affiliation": "大阪ベース",
        "permission": "operator",
        "accountStatus": "active",
        "lastLoginAt": "2026-02-03T17:30:00Z"
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
      "adminCount": 5,
      "operatorCount": 25,
      "dispatcherCount": 15,
      "accountantCount": 5
    }
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

### 1.2 ベースアカウント詳細取得API

**エンドポイント**
```
GET /api/v1/base-accounts/{userId}
```

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "ベースアカウント詳細を取得しました",
  "data": {
    "userId": "BA001",
    "userName": "田中太郎",
    "email": "tanaka@company.co.jp",
    "affiliation": "東京ベース",
    "permission": "admin",
    "accountStatus": "active",
    "roles": ["ROLE_ADMIN", "ROLE_USER"],
    "permissions": ["READ_ALL", "WRITE_ALL"],
    "azureAdId": "xxx-xxx-xxx",
    "permissionMatrix": {
      "権限付与": "編集可",
      "承認": "編集可",
      "マスタ管理": "編集可",
      "発注": "閲覧のみ",
      "計上": "閲覧のみ"
    },
    "lastLoginAt": "2026-02-xxT08:00:00Z",
    "createdAt": "2024-01-15T09:00:00Z",
    "updatedAt": "2026-02-xxT08:00:00Z"
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

### 1.3 ベースアカウント情報更新API

**エンドポイント**
```
PUT /api/v1/base-accounts/{userId}
```

**リクエストボディ**

```json
{
  "updateData": {
    "affiliation": "東京本社",
    "permission": "admin",
    "accountStatus": "active",
    "roles": ["ROLE_ADMIN", "ROLE_USER", "ROLE_OPERATOR"]
  }
}
```

**フィールド仕様**

| フィールド | タイプ | 必須 | バリデーション |
|-----------|--------|------|---------------|
| affiliation | string | No | 最大200文字 |
| permission | string | No | admin \| operator \| dispatcher \| accountant |
| accountStatus | string | No | active \| inactive |
| roles | string[] | No | 有効なロールID |

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "ベースアカウント情報を更新しました",
  "data": {
    "userId": "BA001",
    "updatedAt": "2026-02-xxT11:00:00Z"
  },
  "timestamp": "2026-02-xxT11:00:00Z"
}
```

---

### 1.4 ベースアカウント新規作成API

**エンドポイント**
```
POST /api/v1/base-accounts
```

**リクエストボディ**

```json
{
  "userId": "BA003",
  "email": "watanabe@company.co.jp",
  "userName": "渡辺花子",
  "affiliation": "名古屋ベース",
  "permission": "operator",
  "accountStatus": "active",
  "roles": ["ROLE_USER"]
}
```

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "ベースアカウントを新規作成しました",
  "data": {
    "userId": "BA003",
    "createdAt": "2026-02-xxT11:00:00Z"
  },
  "timestamp": "2026-02-xxT11:00:00Z"
}
```

---

## 2. マスタ管理API

### 2.1 ベース一覧取得API

**エンドポイント**
```
GET /api/v1/master/bases
```

**リクエストパラメータ**

| パラメータ | タイプ | 必須 | 説明 |
|-----------|--------|------|------|
| baseType | string | No | base \| headquarters |
| isActive | boolean | No | true \| false |

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "ベース一覧を取得しました",
  "data": {
    "bases": [
      {
        "baseId": "BASE001",
        "baseName": "東京ベース",
        "baseType": "base",
        "address": "東京都墨田区押上1-1-1",
        "phone": "03-1234-5678",
        "isActive": true,
        "sortOrder": 1
      },
      {
        "baseId": "BASE002",
        "baseName": "大阪ベース",
        "baseType": "base",
        "address": "大阪市北区梅田1-1-1",
        "phone": "06-1234-5678",
        "isActive": true,
        "sortOrder": 2
      },
      {
        "baseId": "HQ001",
        "baseName": "本社",
        "baseType": "headquarters",
        "address": "東京都中央区日本橋1-1-1",
        "phone": "03-1111-1111",
        "isActive": true,
        "sortOrder": 0
      }
    ]
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

### 2.2 ベース新規作成API

**エンドポイント**
```
POST /api/v1/master/bases
```

**リクエストボディ**

```json
{
  "baseId": "BASE003",
  "baseName": "名古屋ベース",
  "baseType": "base",
  "address": "名古屋市中区栄1-1-1",
  "phone": "052-123-4567",
  "sortOrder": 3
}
```

---

### 2.3 ベース更新API

**エンドポイント**
```
PUT /api/v1/master/bases/{baseId}
```

---

### 2.4 ベース削除API

**エンドポイント**
```
DELETE /api/v1/master/bases/{baseId}
```

---

## 3. 認証API

### 3.1 ログインAPI

**エンドポイント**
```
POST /api/v1/auth/login
```

**リクエストボディ**

```json
{
  "email": "tanaka@company.co.jp",
  "password": "password123"
}
```

**レスポンス**

```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "ログインしました",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "tokenType": "Bearer",
    "expiresIn": 3600,
    "user": {
      "userId": "BA001",
      "userName": "田中太郎",
      "email": "tanaka@company.co.jp",
      "affiliation": "東京ベース",
      "permission": "admin",
      "companyId": null,
      "type": "base"
    }
  },
  "timestamp": "2026-02-xxT10:30:00Z"
}
```

---

### 3.2 トークン再発行API

**エンドポイント**
```
POST /api/v1/auth/refresh
```

**リクエストボディ**

```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

### 3.3 ログアウトAPI

**エンドポイント**
```
POST /api/v1/auth/logout
```

---

## 4. 権限マトリクス

### 4.1 ベース権限定義

| 権限区分 | 権限付与 | 承認 | マスタ管理 | 発注 | 計上 |
|----------|----------|------|------------|------|------|
| 管理者 | 編集可 | 編集可 | 編集可 | 閲覧のみ | 閲覧のみ |
| 役割者 | 閲覧不可 | 閲覧のみ | 編集可 | 編集可 | 閲覧不可 |
| 配車担当者 | 閲覧不可 | 閲覧のみ | 閲覧不可 | 編集可 | 閲覧のみ |
| 計上担当者 | 閲覧不可 | 閲覧のみ | 閲覧不可 | 閲覧不可 | 編集可 |

---

## 5. エラーコード

| エラーコード | HTTPステータス | 説明 |
|-------------|--------------|------|
| ACCOUNT_NOT_FOUND | 404 | アカウントが見つかりません |
| DUPLICATE_ACCOUNT | 409 | アカウントが既に存在します |
| INVALID_CREDENTIALS | 401 | メールアドレスまたはパスワードが正しくありません |
| ACCOUNT_DISABLED | 403 | アカウントが無効です |
| TOKEN_EXPIRED | 401 | トークンの有効期限が切れています |
| PERMISSION_DENIED | 403 | この操作を実行する権限がありません |
| BASE_NOT_FOUND | 404 | ベースが見つかりません |
| INVALID_BASE_TYPE | 400 | ベースタイプが無効です |
| LAST_ADMIN_ERROR | 400 | 最後の管理者は無効化できません |

---

## 6. 変更ログ

| 日付 | バージョン | 変更内容 | 作成者 |
|------|------|---------|------|
| 2026-02-XX| v1.0 | 初期バージョン | - |

---

**ドキュメント作成**: -  
**作成日時**: 2026-02-XX 
**適用範囲**: ベースアカウント・マスタ管理モジュールAPI設計
