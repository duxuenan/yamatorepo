# OpenAPI 3.0 インターフェース定義書

## 📋 ドキュメント情報

| 項目 | 内容 |
|------|------|
| **プロジェクト名** | 大賀輸送新システム |
| **OpenAPIバージョン** | 3.0.0 |
| **ドキュメントバージョン** | v1.0 |
| **作成日** | 2026-02-XX|
| **ステータス** | ✅ ドラフト |

---

## 1. OpenAPI仕様概要

OpenAPI 3.0仕様に基づくAPIインターフェース定義書は、個別ファイルとして分割管理されています。

### 1.1 OpenAPI定義ファイル一覧

| ファイル名 | モジュール | | パス |
|------------|-----------|---|------|
| openapi-common.yaml | 共通 | /api/v1/common | 認証、共通データ |
| openapi-auth.yaml | 認証 | /api/v1/auth | ログイン、トークン管理 |
| openapi-partners.yaml | パートナー管理 | /api/v1/partners | パートナー検索、詳細 |
| openapi-orders.yaml | 発注管理 | /api/v1/orders | 発注検索、詳細、送付 |
| openapi-completed-orders.yaml | 実績管理 | /api/v1/completed-orders | 実績検索、詳細、確定 |
| openapi-billings.yaml | 請求管理 | /api/v1/billings | 請求検索、発行、ダウンロード |
| openapi-uploads.yaml | ファイルアップロード | /api/v1/uploads | アップロード、履歴 |
| openapi-action-history.yaml | アクション履歴 | /api/v1/action-history | 履歴検索、タイプ一覧 |
| openapi-base-accounts.yaml | ベースアカウント | /api/v1/base-accounts | アカウント管理 |
| openapi-master.yaml | マスタ管理 | /api/v1/master | ベース一覧、ライン一覧 |
| openapi-partner.yaml | パートナー向け | /api/v1/partner | パートナー専用API |
| openapi-external.yaml | 外部連携 | /api/v1/external | AzureAD連携 |

---

## 2. openapi.yaml（メインファイル）

```yaml
openapi: 3.0.0
info:
  title: 大賀輸送新システム API
  description: |
    大賀輸送新システムのWebアプリケーションAPI定義書
    
    ## 認証
    すべてのAPIはBearer Token認証が必要です。
    AuthorizationヘッダーにJWTトークンを設定してください。
    
    ## レスポンス形式
    すべてのAPIは統一されたレスポンス形式を使用します。
    
    ## エラーハンドリング
    エラー時はsuccess: falseとなり、codeとmessageに詳細が含まれます。
  version: 1.0.0
  contact:
    name: 大賀輸送 IT推進部
    email: it-support@ohga.co.jp

servers:
  - url: https://api.yamato-transport.co.jp/api/v1
    description: 本番環境
  - url: https://api-test.yamato-transport.co.jp/api/v1
    description: テスト環境
  - url: http://localhost:8080/api/v1
    description: 開発環境

tags:
  - name: Authentication
    description: 認証関連API
  - name: Partners
    description: パートナー管理API
  - name: Orders
    description: 発注管理API
  - name: Completed Orders
    description: 実績管理API
  - name: Billings
    description: 請求管理API
  - name: Uploads
    description: ファイルアップロードAPI
  - name: Action History
    description: アクション履歴API
  - name: Base Accounts
    description: ベースアカウントAPI
  - name: Master Data
    description: マスタデータAPI
  - name: External
    description: 外部システム連携API

paths:
  /auth/login:
    $ref: './paths/auth/login.yaml'
  /auth/logout:
    $ref: './paths/auth/logout.yaml'
  /auth/refresh:
    $ref: './paths/auth/refresh.yaml'
  
  /partners/search:
    $ref: './paths/partners/search.yaml'
  /partners/{companyId}:
    $ref: './paths/partners/{companyId}.yaml'
  /partners/{companyId}/users:
    $ref: './paths/partners/{companyId}/users.yaml'
  
  /orders/search:
    $ref: './paths/orders/search.yaml'
  /orders/{orderId}:
    $ref: './paths/orders/{orderId}.yaml'
  /orders/{orderId}/instructions:
    $ref: './paths/orders/{orderId}/instructions.yaml'
  
  /completed-orders/search:
    $ref: './paths/completed-orders/search.yaml'
  /completed-orders/{completedOrderId}:
    $ref: './paths/completed-orders/{completedOrderId}.yaml'
  
  /billings/search:
    $ref: './paths/billings/search.yaml'
  /billings/{billingId}:
    $ref: './paths/billings/{billingId}.yaml'
  
  /base-accounts/search:
    $ref: './paths/base-accounts/search.yaml'
  /base-accounts/{userId}:
    $ref: './paths/base-accounts/{userId}.yaml'
  
  /action-history/search:
    $ref: './paths/action-history/search.yaml'
  
  /uploads:
    $ref: './paths/uploads/upload.yaml'
  /uploads/history:
    $ref: './paths/uploads/history.yaml'

components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
      description: JWT Bearer Token認証
  
  schemas:
    SuccessResponse:
      type: object
      properties:
        success:
          type: boolean
          example: true
        code:
          type: string
          example: SUCCESS
        message:
          type: string
          example: "処理が成功しました"
        timestamp:
          type: string
          format: date-time
          example: "2026-02-xxT10:30:00Z"
    
    ErrorResponse:
      type: object
      properties:
        success:
          type: boolean
          example: false
        code:
          type: string
          example: VALIDATION_ERROR
        message:
          type: string
          example: "バリデーションエラーが発生しました"
        errors:
          type: array
          items:
            type: object
            properties:
              field:
                type: string
              message:
                type: string
        timestamp:
          type: string
          format: date-time
          example: "2026-02-xxT10:30:00Z"
    
    PaginationRequest:
      type: object
      properties:
        page:
          type: integer
          minimum: 1
          default: 1
        pageSize:
          type: integer
          minimum: 1
          maximum: 100
          default: 20
        sort:
          type: string
        sortOrder:
          type: string
          enum: [asc, desc]
    
    PaginationResponse:
      type: object
      properties:
        currentPage:
          type: integer
          example: 1
        pageSize:
          type: integer
          example: 20
        totalItems:
          type: integer
          example: 100
        totalPages:
          type: integer
          example: 5
        hasNext:
          type: boolean
          example: true
        hasPrevious:
          type: boolean
          example: false

security:
  - bearerAuth: []
```

---

## 3. パスパラメータ定義

### 3.1 認証

```yaml
# paths/auth/login.yaml
post:
  tags:
    - Authentication
  summary: ログイン
  description: メールアドレスとパスワードでログインし、JWTトークンを取得します
  requestBody:
    required: true
    content:
      application/json:
        schema:
          type: object
          required:
            - email
            - password
          properties:
            email:
              type: string
              format: email
              description: メールアドレス
              example: "tanaka@company.co.jp"
            password:
              type: string
              format: password
              description: パスワード
              example: "password123"
  responses:
    '200':
      description: ログイン成功
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/LoginResponse'
    '401':
      description: 認証エラー
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ErrorResponse'
```

### 3.2 パートナー検索

```yaml
# paths/partners/search.yaml
get:
  tags:
    - Partners
  summary: パートナー検索
  description: パートナー会社の一覧を検索条件で取得します
  parameters:
    - name: companyCode
      in: query
      schema:
        type: string
      description: 会社コード（部分一致）
    - name: companyName
      in: query
      schema:
        type: string
      description: 会社名（部分一致）
    - name: systemUse
      in: query
      schema:
        type: boolean
      description: システム利用フラグ
    - $ref: '#/components/parameters/PageParam'
    - $ref: '#/components/parameters/PageSizeParam'
  responses:
    '200':
      description: 検索成功
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/PartnerSearchResponse'
```

---

## 4. スキーマ定義

### 4.1 パートナー

```yaml
# components/schemas/Partner.yaml
Partner:
  type: object
  properties:
    companyId:
      type: string
      description: 会社ID
      example: "C001"
    companyName:
      type: string
      description: 会社名
      example: "大賀輸送株式会社"
    companyPhone:
      type: string
      description: 電話番号
      example: "03-1234-5678"
    systemUse:
      type: boolean
      description: システム利用フラグ
      example: true
    instructionText:
      type: string
      description: 指示書表示文言
      example: "文言1"
    userCount:
      type: integer
      description: ユーザー数
      example: 5
    lastLoginAt:
      type: string
      format: date-time
      description: 最終ログイン日時
      example: "2026-02-xxT10:30:00Z"

PartnerDetail:
  type: object
  allOf:
    - $ref: '#/components/schemas/Partner'
    - type: object
      properties:
        companyCodes:
          type: array
          items:
            type: string
          description: 会社コードリスト
          example: ["ABC001", "ABC002"]
        users:
          type: array
          items:
            $ref: '#/components/schemas/PartnerUser'
          description: ユーザーリスト
```

### 4.2 発注

```yaml
# components/schemas/Order.yaml
Order:
  type: object
  properties:
    orderId:
      type: string
      description: 発注ID
      example: "ORD-2026-001"
    companyId:
      type: string
      description: 会社ID
      example: "C001"
    companyName:
      type: string
      description: 会社名
      example: "大賀輸送株式会社"
    orderYearMonth:
      type: string
      description: 発注年月
      example: "2026-02"
    status:
      type: string
      enum: [pending, accepted, rejected, expired, cancelled]
      description: 発注ステータス
      example: "pending"
    requestDate:
      type: string
      format: date
      description: 依頼日
      example: "2026-02-01"
    version:
      type: integer
      description: バージョン
      example: 1
```

### 4.3 実績

```yaml
# components/schemas/CompletedOrder.yaml
CompletedOrder:
  type: object
  properties:
    completedOrderId:
      type: string
      description: 実績ID
      example: "PERF-2026-001"
    orderId:
      type: string
      description: 関連発注ID
      example: "ORD-2026-001"
    companyId:
      type: string
      description: 会社ID
      example: "C001"
    totalAmount:
      type: number
      format: decimal
      description: 合計金額
      example: 1500000
    status:
      type: string
      enum: [pending, confirmed, rejected]
      description: ステータス
      example: "confirmed"
```

### 4.4 請求

```yaml
# components/schemas/Billing.yaml
Billing:
  type: object
  properties:
    billingId:
      type: string
      description: 請求ID
      example: "BILL-2026-001"
    companyId:
      type: string
      description: 会社ID
      example: "C001"
    amount:
      type: number
      format: decimal
      description: 請求金額
      example: 1500000
    status:
      type: string
      enum: [pending, issued, paid, cancelled]
      description: 請求ステータス
      example: "issued"
    issueDate:
      type: string
      format: date
      description: 発行日
      example: "2026-02-05"
    dueDate:
      type: string
      format: date
      description: 支払期限
      example: "2026-02-28"
```

---

## 5. セキュリティ定義

### 5.1 JWTペイロード

```yaml
# components/schemas/JWTPayload.yaml
JWTPayload:
  type: object
  properties:
    sub:
      type: string
      description: ユーザーID
      example: "BA001"
    type:
      type: string
      enum: [partner, base]
      description: ユーザータイプ
      example: "base"
    permissions:
      type: array
      items:
        type: string
      description: 権限リスト
      example: ["READ_ALL", "WRITE_ALL"]
    companyId:
      type: string
      description: 会社ID（パートナー場合）
      example: "C001"
    baseId:
      type: string
      description: ベースID（ベース場合）
      example: "BASE001"
    iat:
      type: integer
      description: 発行時刻（Unixタイムスタンプ）
      example: 1644061800
    exp:
      type: integer
      description: 有効期限（Unixタイムスタンプ）
      example: 1644065400
```

---

## 6. ドキュメント構成

```
APIインターフェース設計/
├── openapi.yaml                    # メインOpenAPI定義
├── components/
│   ├── schemas/                   # スキーマ定義
│   │   ├── common.yaml           # 共通スキーマ
│   │   ├── auth.yaml            # 認証スキーマ
│   │   ├── partners.yaml        # パートナースキーマ
│   │   ├── orders.yaml         # 発注スキーマ
│   │   ├── completed_orders.yaml    # 実績スキーマ
│   │   ├── billings.yaml       # 請求スキーマ
│   │   └── ...
│   ├── parameters/              # パラメータ定義
│   └── responses/               # レスポンス定義
└── paths/                        # パスパラメータ定義
    ├── auth/
    ├── partners/
    ├── orders/
    ├── completed_orders/
    ├── billings/
    └── ...
```

---

## 7. OpenAPIツール対応

### 7.1 コード生成

```bash
# OpenAPI GeneratorでTypeScriptクライアントを生成
openapi-generator-cli generate \
  -i openapi.yaml \
  -g typescript-axios \
  -o ./src/api/client

# Spring Bootサーバーを生成
openapi-generator-cli generate \
  -i openapi.yaml \
  -g spring \
  -o ./src/main/java/com/yamato/api
```

### 7.2 ドキュメント閲覧

生成されたOpenAPI定義書は以下のツールで確認できます：

- **Swagger UI**: `/api-docs` エンドポイント
- **Redoc**: `/api-docs/redoc` エンドポイント
- **Stoplight**: Web IDE

---

## 8. 変更ログ

| 日付 | バージョン | 変更内容 | 作成者 |
|------|------|---------|------|
| 2026-02-XX| v1.0 | 初期バージョン | - |

---

**ドキュメント作成**: -  
**作成日時**: 2026-02-XX 
**適用範囲**: 大賀輸送新システム OpenAPI 3.0 インターフェース定義
