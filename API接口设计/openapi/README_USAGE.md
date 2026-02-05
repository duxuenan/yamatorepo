# OpenAPI ドキュメント使用ガイド

## 📖 クイックスタート

### ステップ1: ドキュメントを開く
以下のいずれかのファイルをブラウザで開いてください：

1. **インタラクティブ版（推奨）**: `openapi-interactive.html`
   - APIサーバーが稼働している場合、実際にAPIをテストできます
   - サーバー切り替え機能付き
   - トークン認証対応

2. **静的版**: `openapi-full-viewer.html`
   - すべてのAPI仕様を閲覧可能
   - オフラインで使用可能
   - 実際のAPI呼び出しはできません

### ステップ2: サーバーを確認
APIをテストするには、APIサーバーが稼働している必要があります：

| 環境 | URL | 説明 |
|------|-----|------|
| 開発 | `http://localhost:8080/api/v1` | ローカルでSpring Bootを起動 |
| テスト | `https://api-test.yamato-transport.co.jp/api/v1` | テストサーバー |
| 本番 | `https://api.yamato-transport.co.jp/api/v1` | 本番サーバー |

### ステップ3: トークンを取得
ほとんどのAPIは認証が必要です：

1. `Authentication` タブを開く
2. `POST /auth/login` を選択
3. `Try it out` をクリック
4. メールアドレスとパスワードを入力
5. `Execute` をクリック
6. レスポンスから `token` をコピー

### ステップ4: トークンを設定
1. 画面右上の「Authorize」ボタンをクリック
2. `Bearer {token}` 形式でトークンを入力
3. 「Authorize」をクリック
4. 「Close」をクリック

### ステップ5: APIをテスト
任意のAPIを選択し、`Try it out` → パラメータ入力 → `Execute` の順で実行できます。

## 🔧 トラブルシューティング

### Q: APIを呼び出すとエラーになる
**A**: 以下を確認してください：
1. APIサーバーが稼働しているか
2. 正しい環境（開発/テスト/本番）が選択されているか
3. トークンが有効か（期限切れの場合は再取得してください）
4. ブラウザのコンソールにエラーがないか

### Q: CORSエラーが発生する
**A**: 以下を試してください：
1. 開発環境を使用する（ローカルサーバー）
2. またはブラウザのCORS制限を解除する（開発用のみ）
3. APIサーバーのCORS設定を確認

### Q: サーバーが見つからない
**A**: 以下を確認してください：
1. 開発環境の場合：Spring Bootアプリケーションが `localhost:8080` で稼働しているか
   ```bash
   # Spring Bootを起動
   mvn spring-boot:run
   
   # または
   java -jar target/your-app.jar
   ```
2. テスト/本番環境の場合：ネットワーク接続とファイアウォール設定を確認

### Q: トークンの有効期限が切れた
**A**: 以下の手順で再取得してください：
1. `POST /auth/login` で再ログイン
2. または `POST /auth/refresh` でリフレッシュ（まだ有効なリフレッシュトークンがある場合）

## 📚 APIモジュール詳細

### Authentication (認証)
- `POST /auth/login` - ログイン（認証不要）
- `POST /auth/logout` - ログアウト（認証必要）
- `POST /auth/refresh` - トークン更新（認証不要）

### Partners (パートナー管理)
- `GET /partners/search` - 検索（認証必要）
- `GET /partners/{companyId}` - 詳細（認証必要）
- `PUT /partners/{companyId}` - 更新（認証必要）

### Orders (発注管理)
- `GET /orders/search` - 検索（認証必要）
- `GET /orders/{orderId}` - 詳細（認証必要）
- `PUT /orders/{orderId}` - 更新（認証必要）

### Completed Orders (実績管理)
- `GET /completed-orders/search` - 検索（認証必要）
- `GET /completed-orders/{id}` - 詳細（認証必要）

### Billings (請求管理)
- `GET /billings/search` - 検索（認証必要）
- `GET /billings/{id}` - 詳細（認証必要）

### Base Accounts (ベースアカウント)
- `GET /base-accounts/search` - 検索（認証必要）
- `GET /base-accounts/{userId}` - 詳細（認証必要）

### Action History (アクション履歴)
- `GET /action-history/search` - 検索（認証必要）

### Uploads (ファイルアップロード)
- `POST /uploads` - アップロード（認証必要）
- `GET /uploads/history` - 履歴（認証必要）

## 💡 ヒント

1. **開発環境のセットアップ**:
   ```bash
   # Spring Bootを起動
   cd backend
   mvn spring-boot:run
   
   # APIドキュメントを開く
   open ../API接口设计/openapi-interactive.html
   ```

2. **トークンの保存**:
   - トークンはブラウザのローカルストレージに保存されます
   - ページを更新しても保持されます
   - 手動で削除するには「Logout」ボタンを使用

3. **レスポンスの確認**:
   - レスポンスはJSON形式で表示されます
   - ステータスコードとメッセージを確認
   - エラーの場合は`success: false`で詳細が表示されます

4. **検索機能**:
   - 右上の検索ボックスでAPIを検索できます
   - タグでフィルタリングも可能です

## 🎯 次のステップ

1. 開発環境でAPIサーバーを起動
2. `openapi-interactive.html` を開く
3. ログインしてトークンを取得
4. 各種APIをテスト

## 📞 サポート

問題がある場合は、以下のリソースを参照してください：
- [API設計総覧](../01_API接口设计总览.md)
- [OpenAPI 3.0 定義](../07_OpenAPI_3.0_インターフェース定義.md)
- 技術サポート: it-support@ohga.co.jp

---
**最終更新**: 2026-02-05