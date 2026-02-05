-- ============================================================
-- 大賀輸送新システム - PostgreSQL データベースDDLスクリプト
-- バージョン: v1.0
-- 日付: 2026-02-xx
-- ============================================================

-- ============================================================
-- 第1部分: 共通モジュールテーブル
-- ============================================================

-- 1.1 m_screen (画面テーブル)
DROP TABLE IF EXISTS m_screen CASCADE;
CREATE TABLE m_screen (
    id BIGSERIAL PRIMARY KEY,
    screen_id VARCHAR(20) NOT NULL UNIQUE,
    screen_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    description TEXT,
    route_path VARCHAR(100),
    component_name VARCHAR(100),
    device_pc BOOLEAN DEFAULT FALSE,
    device_sp BOOLEAN DEFAULT FALSE,
    sort_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(50),
    updated_at TIMESTAMP,
    updated_by VARCHAR(50),
    
    CONSTRAINT uk_m_screen_id UNIQUE (screen_id)
);

COMMENT ON TABLE m_screen IS '画面テーブル';
COMMENT ON COLUMN m_screen.screen_id IS '画面ID';
COMMENT ON COLUMN m_screen.screen_name IS '画面名称';
COMMENT ON COLUMN m_screen.category IS 'カテゴリー';
COMMENT ON COLUMN m_screen.device_pc IS 'PC対応フラグ';
COMMENT ON COLUMN m_screen.device_sp IS 'SP対応フラグ';

CREATE INDEX idx_m_screen_category ON m_screen(category);
CREATE INDEX idx_m_screen_route ON m_screen(route_path);

-- 1.2 m_permission (権限テーブル)
DROP TABLE IF EXISTS m_permission CASCADE;
CREATE TABLE m_permission (
    id BIGSERIAL PRIMARY KEY,
    role_id VARCHAR(20) NOT NULL,
    screen_id VARCHAR(20) NOT NULL,
    access_level INTEGER NOT NULL DEFAULT 0 CHECK (access_level IN (0, 1, 2)),
    can_read BOOLEAN DEFAULT FALSE,
    can_write BOOLEAN DEFAULT FALSE,
    can_delete BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uk_m_permission_role_screen UNIQUE (role_id, screen_id)
);

COMMENT ON TABLE m_permission IS '権限テーブル';
COMMENT ON COLUMN m_permission.role_id IS 'ロールID';
COMMENT ON COLUMN m_permission.screen_id IS '画面ID';
COMMENT ON COLUMN m_permission.access_level IS 'アクセスレベル: 0-無, 1-参照のみ, 2-参照更新';

CREATE INDEX idx_m_permission_role ON m_permission(role_id);
CREATE INDEX idx_m_permission_screen ON m_permission(screen_id);

-- 1.3 m_role (ロールテーブル)
DROP TABLE IF EXISTS m_role CASCADE;
CREATE TABLE m_role (
    id BIGSERIAL PRIMARY KEY,
    role_id VARCHAR(20) NOT NULL UNIQUE,
    role_name VARCHAR(50) NOT NULL,
    role_name_ja VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE m_role IS 'ロールテーブル';

-- ============================================================
-- 第2部分: パートナーモジュールテーブル
-- ============================================================

-- 2.1 partner_companies (パートナー会社テーブル)
DROP TABLE IF EXISTS partner_companies CASCADE;
CREATE TABLE partner_companies (
    id BIGSERIAL PRIMARY KEY,
    company_id VARCHAR(50) NOT NULL UNIQUE,
    company_name VARCHAR(200) NOT NULL,
    company_phone VARCHAR(20) NOT NULL,
    system_use BOOLEAN NOT NULL DEFAULT TRUE,
    instruction_text VARCHAR(20) NOT NULL DEFAULT '文言1',
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    memo TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100),
    updated_by VARCHAR(100)
);

COMMENT ON TABLE partner_companies IS 'パートナー会社テーブル';
COMMENT ON COLUMN partner_companies.company_id IS '会社ID';
COMMENT ON COLUMN partner_companies.company_name IS '会社名';
COMMENT ON COLUMN partner_companies.company_phone IS '会社電話番号';
COMMENT ON COLUMN partner_companies.system_use IS 'システム利用フラグ';
COMMENT ON COLUMN partner_companies.instruction_text IS '指示書表示文言';
COMMENT ON COLUMN partner_companies.status IS 'ステータス: active-有効, inactive-無効';

CREATE INDEX idx_partner_companies_name ON partner_companies(company_name);
CREATE INDEX idx_partner_companies_status ON partner_companies(status);
CREATE INDEX idx_partner_companies_system_use ON partner_companies(system_use);

-- 2.2 partner_company_codes (会社コードテーブル)
DROP TABLE IF EXISTS partner_company_codes CASCADE;
CREATE TABLE partner_company_codes (
    id BIGSERIAL PRIMARY KEY,
    company_id VARCHAR(50) NOT NULL,
    company_code VARCHAR(50) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    effective_date DATE,
    expiration_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uk_partner_company_code UNIQUE (company_id, company_code),
    FOREIGN KEY (company_id) REFERENCES partner_companies(company_id) ON DELETE CASCADE
);

COMMENT ON TABLE partner_company_codes IS '会社コードテーブル';
COMMENT ON COLUMN partner_company_codes.company_id IS '会社ID';
COMMENT ON COLUMN partner_company_codes.company_code IS '会社コード';
COMMENT ON COLUMN partner_company_codes.is_primary IS '主コードフラグ';
COMMENT ON COLUMN partner_company_codes.effective_date IS '有効開始日';
COMMENT ON COLUMN partner_company_codes.expiration_date IS '有効終了日';

CREATE INDEX idx_partner_company_codes_code ON partner_company_codes(company_code);

-- 2.3 partner_users (パートナーユーザーテーブル)
DROP TABLE IF EXISTS partner_users CASCADE;
CREATE TABLE partner_users (
    id BIGSERIAL PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL UNIQUE,
    company_id VARCHAR(50) NOT NULL,
    email VARCHAR(200) NOT NULL,
    personal_sms VARCHAR(20) NOT NULL,
    notification_target VARCHAR(10) NOT NULL DEFAULT 'mail' CHECK (notification_target IN ('mail', 'sms')),
    account_type VARCHAR(10) NOT NULL DEFAULT 'sub' CHECK (account_type IN ('main', 'sub')),
    sub_account_notification VARCHAR(10) CHECK (sub_account_notification IN ('yes', 'no')),
    branch_name VARCHAR(200),
    account_status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (account_status IN ('active', 'inactive')),
    password_hash VARCHAR(255),
    last_login_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_partner_users_company FOREIGN KEY (company_id) 
        REFERENCES partner_companies(company_id) ON DELETE CASCADE,
    CONSTRAINT uk_partner_users_email UNIQUE (email)
);

COMMENT ON TABLE partner_users IS 'パートナーユーザーテーブル';
COMMENT ON COLUMN partner_users.user_id IS 'ユーザーID';
COMMENT ON COLUMN partner_users.company_id IS '所属会社ID';
COMMENT ON COLUMN partner_users.email IS 'メールアドレス';
COMMENT ON COLUMN partner_users.personal_sms IS '個人電話番号';
COMMENT ON COLUMN partner_users.notification_target IS '通知送付先: mail-メール, sms-SMS';
COMMENT ON COLUMN partner_users.account_type IS 'アカウント区分: main-メイン, sub-サブ';
COMMENT ON COLUMN partner_users.sub_account_notification IS 'サブアカウント連絡受領: yes-する, no-しない';
COMMENT ON COLUMN partner_users.branch_name IS '支店・営業所名';
COMMENT ON COLUMN partner_users.account_status IS 'アカウント状態: active-有効, inactive-無効';

CREATE INDEX idx_partner_users_company ON partner_users(company_id);
CREATE INDEX idx_partner_users_status ON partner_users(account_status);
CREATE INDEX idx_partner_users_type ON partner_users(account_type);

-- ============================================================
-- 第3部分: ベースアカウントモジュールテーブル
-- ============================================================

-- 3.1 base_accounts (ベースアカウントテーブル)
DROP TABLE IF EXISTS base_accounts CASCADE;
CREATE TABLE base_accounts (
    id BIGSERIAL PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL UNIQUE,
    user_name VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL UNIQUE,
    affiliation VARCHAR(200) NOT NULL,
    permission VARCHAR(20) NOT NULL DEFAULT 'operator' 
        CHECK (permission IN ('admin', 'operator', 'dispatcher', 'accountant')),
    account_status VARCHAR(20) NOT NULL DEFAULT 'active' 
        CHECK (account_status IN ('active', 'inactive')),
    azure_ad_id VARCHAR(100),
    roles TEXT[],
    permissions TEXT[],
    last_login_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100),
    updated_by VARCHAR(100)
);

COMMENT ON TABLE base_accounts IS 'ベースアカウントテーブル';
COMMENT ON COLUMN base_accounts.user_id IS 'ユーザーID';
COMMENT ON COLUMN base_accounts.user_name IS 'ユーザー名';
COMMENT ON COLUMN base_accounts.affiliation IS '所属';
COMMENT ON COLUMN base_accounts.permission IS '権限: admin-管理者, operator-役割者, dispatcher-配車担当者, accountant-計上担当者';
COMMENT ON COLUMN base_accounts.account_status IS 'アカウント状態: active-有効, inactive-無効';
COMMENT ON COLUMN base_accounts.azure_ad_id IS 'AzureADオブジェクトID';

CREATE INDEX idx_base_accounts_email ON base_accounts(email);
CREATE INDEX idx_base_accounts_affiliation ON base_accounts(affiliation);
CREATE INDEX idx_base_accounts_permission ON base_accounts(permission);
CREATE INDEX idx_base_accounts_status ON base_accounts(account_status);

-- 3.2 base_list (ベースリストテーブル)
DROP TABLE IF EXISTS base_list CASCADE;
CREATE TABLE base_list (
    id BIGSERIAL PRIMARY KEY,
    base_id VARCHAR(50) NOT NULL UNIQUE,
    base_name VARCHAR(200) NOT NULL,
    base_type VARCHAR(20) NOT NULL CHECK (base_type IN ('base', 'headquarters')),
    address TEXT,
    phone VARCHAR(20),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

COMMENT ON TABLE base_list IS 'ベースリストテーブル';
COMMENT ON COLUMN base_list.base_type IS 'ベースタイプ: base-ベース, headquarters-本社';

CREATE INDEX idx_base_list_type ON base_list(base_type);
CREATE INDEX idx_base_list_active ON base_list(is_active);

-- ============================================================
-- 第4部分: 発注モジュールテーブル
-- ============================================================

-- 4.1 orders (発注マスタテーブル)
DROP TABLE IF EXISTS orders CASCADE;
CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL UNIQUE,
    company_id VARCHAR(50) NOT NULL,
    order_year_month VARCHAR(7) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending' 
        CHECK (status IN ('pending', 'accepted', 'rejected', 'expired', 'cancelled')),
    request_detail TEXT,
    request_date DATE NOT NULL,
    deadline DATE,
    partner_memo TEXT,
    sent_at TIMESTAMP,
    accepted_at TIMESTAMP,
    rejected_at TIMESTAMP,
    rejected_reason TEXT,
    version INTEGER DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    
    CONSTRAINT fk_orders_company FOREIGN KEY (company_id) 
        REFERENCES partner_companies(company_id) ON DELETE RESTRICT
);

COMMENT ON TABLE orders IS '発注マスタテーブル';
COMMENT ON COLUMN orders.order_id IS '発注ID';
COMMENT ON COLUMN orders.company_id IS '会社ID';
COMMENT ON COLUMN orders.order_year_month IS '発注年月(YYYY-MM)';
COMMENT ON COLUMN orders.status IS '発注ステータス: pending-待処理, accepted-承諾済, rejected-拒否済, expired-期限切, cancelled-取消';
COMMENT ON COLUMN orders.request_detail IS '依頼詳細';
COMMENT ON COLUMN orders.request_date IS '依頼日';
COMMENT ON COLUMN orders.deadline IS '期限日';
COMMENT ON COLUMN orders.partner_memo IS 'パートナーメモ';
COMMENT ON COLUMN orders.sent_at IS '送付日時';
COMMENT ON COLUMN orders.accepted_at IS '承諾日時';
COMMENT ON COLUMN orders.rejected_at IS '拒否日時';
COMMENT ON COLUMN orders.rejected_reason IS '拒否理由';
COMMENT ON COLUMN orders.version IS 'バージョン';

CREATE INDEX idx_orders_company ON orders(company_id);
CREATE INDEX idx_orders_year_month ON orders(order_year_month);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_date ON orders(request_date);
CREATE INDEX idx_orders_company_status ON orders(company_id, status);

-- 4.2 order_details (発注明细テーブル)
DROP TABLE IF EXISTS order_details CASCADE;
CREATE TABLE order_details (
    id BIGSERIAL PRIMARY KEY,
    detail_id VARCHAR(50) NOT NULL UNIQUE,
    order_id VARCHAR(50) NOT NULL,
    branch_code VARCHAR(20) NOT NULL,
    branch_name VARCHAR(100) NOT NULL,
    line_code VARCHAR(20) NOT NULL,
    line_name VARCHAR(100),
    route_type VARCHAR(50),
    warehouse_location VARCHAR(200),
    warehouse_time TIME,
    vehicle_type VARCHAR(100),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'rejected')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_order_details_order FOREIGN KEY (order_id) 
        REFERENCES orders(order_id) ON DELETE CASCADE
);

COMMENT ON TABLE order_details IS '発注明细テーブル';
COMMENT ON COLUMN order_details.detail_id IS '明细ID';
COMMENT ON COLUMN order_details.order_id IS '発注ID';
COMMENT ON COLUMN order_details.branch_code IS '支点コード';
COMMENT ON COLUMN order_details.branch_name IS '支点・営業所名';
COMMENT ON COLUMN order_details.line_code IS '線便コード';
COMMENT ON COLUMN order_details.line_name IS '線便名';
COMMENT ON COLUMN order_details.route_type IS '系統';
COMMENT ON COLUMN order_details.warehouse_location IS '入庫場所';
COMMENT ON COLUMN order_details.warehouse_time IS '入庫時間';
COMMENT ON COLUMN order_details.vehicle_type IS '使用車両';
COMMENT ON COLUMN order_details.status IS '承認ステータス: pending-未承認, confirmed-承認済, rejected-差戻';

CREATE INDEX idx_order_details_order ON order_details(order_id);
CREATE INDEX idx_order_details_line ON order_details(line_code);

-- 4.3 order_schedules (運行指示日程テーブル)
DROP TABLE IF EXISTS order_schedules CASCADE;
CREATE TABLE order_schedules (
    id BIGSERIAL PRIMARY KEY,
    schedule_id VARCHAR(50) NOT NULL UNIQUE,
    order_id VARCHAR(50) NOT NULL,
    detail_id VARCHAR(50),
    version INTEGER NOT NULL DEFAULT 1,
    schedule_date DATE NOT NULL,
    morning_flag BOOLEAN DEFAULT FALSE,
    afternoon_flag BOOLEAN DEFAULT FALSE,
    week_monday BOOLEAN DEFAULT FALSE,
    week_tuesday BOOLEAN DEFAULT FALSE,
    week_wednesday BOOLEAN DEFAULT FALSE,
    week_thursday BOOLEAN DEFAULT FALSE,
    week_friday BOOLEAN DEFAULT FALSE,
    week_saturday BOOLEAN DEFAULT FALSE,
    week_sunday BOOLEAN DEFAULT FALSE,
    is_holiday BOOLEAN DEFAULT FALSE,
    change_flag BOOLEAN DEFAULT FALSE,
    change_detail TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_order_schedules_order FOREIGN KEY (order_id) 
        REFERENCES orders(order_id) ON DELETE CASCADE
);

COMMENT ON TABLE order_schedules IS '運行指示日程テーブル';
COMMENT ON COLUMN order_schedules.schedule_id IS '日程ID';
COMMENT ON COLUMN order_schedules.order_id IS '発注ID';
COMMENT ON COLUMN order_schedules.schedule_date IS '日程日';
COMMENT ON COLUMN order_schedules.morning_flag IS 'AM発';
COMMENT ON COLUMN order_schedules.afternoon_flag IS '着';
COMMENT ON COLUMN order_schedules.week_monday IS '月';
COMMENT ON COLUMN order_schedules.week_tuesday IS '火';
COMMENT ON COLUMN order_schedules.week_wednesday IS '水';
COMMENT ON COLUMN order_schedules.week_thursday IS '木';
COMMENT ON COLUMN order_schedules.week_friday IS '金';
COMMENT ON COLUMN order_schedules.week_saturday IS '土';
COMMENT ON COLUMN order_schedules.week_sunday IS '日';
COMMENT ON COLUMN order_schedules.is_holiday IS '祝';
COMMENT ON COLUMN order_schedules.change_flag IS '変更';
COMMENT ON COLUMN order_schedules.change_detail IS '変更内容';

CREATE INDEX idx_order_schedules_order ON order_schedules(order_id);
CREATE INDEX idx_order_schedules_date ON order_schedules(schedule_date);
CREATE INDEX idx_order_schedules_version ON order_schedules(order_id, version);

-- ============================================================
-- 第5部分: 実績モジュールテーブル
-- ============================================================

-- 5.1 completed_orders (実績マスタテーブル)
DROP TABLE IF EXISTS completed_orders CASCADE;
CREATE TABLE completed_orders (
    id BIGSERIAL PRIMARY KEY,
    completed_order_id VARCHAR(50) NOT NULL UNIQUE,
    order_id VARCHAR(50) NOT NULL,
    company_id VARCHAR(50) NOT NULL,
    completed_order_year_month VARCHAR(7) NOT NULL,
    total_amount DECIMAL(12, 2) NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'pending' 
        CHECK (status IN ('pending', 'confirmed', 'rejected')),
    confirmed_at TIMESTAMP,
    sent_at TIMESTAMP,
    accepted_at TIMESTAMP,
    version INTEGER DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    
    CONSTRAINT fk_completed_orders_order FOREIGN KEY (order_id) 
        REFERENCES orders(order_id) ON DELETE RESTRICT,
    CONSTRAINT fk_completed_orders_company FOREIGN KEY (company_id) 
        REFERENCES partner_companies(company_id) ON DELETE RESTRICT
);

COMMENT ON TABLE completed_orders IS '実績マスタテーブル';
COMMENT ON COLUMN completed_orders.completed_order_id IS '実績ID';
COMMENT ON COLUMN completed_orders.order_id IS '関連発注ID';
COMMENT ON COLUMN completed_orders.company_id IS '会社ID';
COMMENT ON COLUMN completed_orders.completed_order_year_month IS '実績年月(YYYY-MM)';
COMMENT ON COLUMN completed_orders.total_amount IS '合計金額';
COMMENT ON COLUMN completed_orders.status IS 'ステータス: pending-未確定, confirmed-確定済, rejected-差戻';

CREATE INDEX idx_completed_orders_order ON completed_orders(order_id);
CREATE INDEX idx_completed_orders_company ON completed_orders(company_id);
CREATE INDEX idx_completed_orders_year_month ON completed_orders(completed_order_year_month);
CREATE INDEX idx_completed_orders_status ON completed_orders(status);

-- 5.2 daily_rates (日別傭車費テーブル)
DROP TABLE IF EXISTS daily_rates CASCADE;
CREATE TABLE daily_rates (
    id BIGSERIAL PRIMARY KEY,
    rate_id VARCHAR(50) NOT NULL UNIQUE,
    completed_order_id VARCHAR(50) NOT NULL,
    line_code VARCHAR(20) NOT NULL,
    line_name VARCHAR(100) NOT NULL,
    version INTEGER DEFAULT 1,
    amount_monday DECIMAL(10, 2) DEFAULT 0,
    amount_tuesday DECIMAL(10, 2) DEFAULT 0,
    amount_wednesday DECIMAL(10, 2) DEFAULT 0,
    amount_thursday DECIMAL(10, 2) DEFAULT 0,
    amount_friday DECIMAL(10, 2) DEFAULT 0,
    amount_saturday DECIMAL(10, 2) DEFAULT 0,
    amount_sunday DECIMAL(10, 2) DEFAULT 0,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'rejected')),
    rejection_reason TEXT,
    change_flag BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_daily_rates_completed_order FOREIGN KEY (completed_order_id) 
        REFERENCES completed_orders(completed_order_id) ON DELETE CASCADE
);

COMMENT ON TABLE daily_rates IS '日別傭車費テーブル';
COMMENT ON COLUMN daily_rates.rate_id IS '費用ID';
COMMENT ON COLUMN daily_rates.completed_order_id IS '実績ID';
COMMENT ON COLUMN daily_rates.line_code IS '線便コード';
COMMENT ON COLUMN daily_rates.line_name IS '線便名';
COMMENT ON COLUMN daily_rates.amount_monday IS '月';
COMMENT ON COLUMN daily_rates.amount_tuesday IS '火';
COMMENT ON COLUMN daily_rates.amount_wednesday IS '水';
COMMENT ON COLUMN daily_rates.amount_thursday IS '木';
COMMENT ON COLUMN daily_rates.amount_friday IS '金';
COMMENT ON COLUMN daily_rates.amount_saturday IS '土';
COMMENT ON COLUMN daily_rates.amount_sunday IS '日';
COMMENT ON COLUMN daily_rates.status IS '承認ステータス: pending-未承認, confirmed-承認済, rejected-差戻';
COMMENT ON COLUMN daily_rates.rejection_reason IS '差戻し理由';

CREATE INDEX idx_daily_rates_completed_order ON daily_rates(completed_order_id);
CREATE INDEX idx_daily_rates_line ON daily_rates(line_code);
CREATE INDEX idx_daily_rates_version ON daily_rates(completed_order_id, version);

-- ============================================================
-- 第6部分: 請求モジュールテーブル
-- ============================================================

-- 6.1 billings (請求マスタテーブル)
DROP TABLE IF EXISTS billings CASCADE;
CREATE TABLE billings (
    id BIGSERIAL PRIMARY KEY,
    billing_id VARCHAR(50) NOT NULL UNIQUE,
    billing_year_month VARCHAR(7) NOT NULL,
    company_id VARCHAR(50) NOT NULL,
    amount DECIMAL(12, 2) NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'pending' 
        CHECK (status IN ('pending', 'issued', 'paid', 'cancelled')),
    issue_date DATE NOT NULL,
    due_date DATE,
    paid_date DATE,
    base_name VARCHAR(200) NOT NULL,
    memo TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    
    CONSTRAINT fk_billings_company FOREIGN KEY (company_id) 
        REFERENCES partner_companies(company_id) ON DELETE RESTRICT
);

COMMENT ON TABLE billings IS '請求マスタテーブル';
COMMENT ON COLUMN billings.billing_id IS '請求ID';
COMMENT ON COLUMN billings.billing_year_month IS '請求年月(YYYY-MM)';
COMMENT ON COLUMN billings.company_id IS '会社ID';
COMMENT ON COLUMN billings.amount IS '請求金額';
COMMENT ON COLUMN billings.status IS '請求ステータス: pending-未発行, issued-発行済, paid-支払済, cancelled-取消';
COMMENT ON COLUMN billings.issue_date IS '発行日';
COMMENT ON COLUMN billings.due_date IS '支払期限';
COMMENT ON COLUMN billings.paid_date IS '支払日';
COMMENT ON COLUMN billings.base_name IS 'ベース名';

CREATE INDEX idx_billings_company ON billings(company_id);
CREATE INDEX idx_billings_year_month ON billings(billing_year_month);
CREATE INDEX idx_billings_status ON billings(status);
CREATE INDEX idx_billings_issue_date ON billings(issue_date);
CREATE INDEX idx_billings_company_status ON billings(company_id, status);

-- 6.2 billing_details (請求明细テーブル)
DROP TABLE IF EXISTS billing_details CASCADE;
CREATE TABLE billing_details (
    id BIGSERIAL PRIMARY KEY,
    detail_id VARCHAR(50) NOT NULL UNIQUE,
    billing_id VARCHAR(50) NOT NULL,
    line_code VARCHAR(20) NOT NULL,
    line_name VARCHAR(100) NOT NULL,
    daily_rate DECIMAL(10, 2) NOT NULL,
    days INTEGER NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    description TEXT,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_billing_details_billing FOREIGN KEY (billing_id) 
        REFERENCES billings(billing_id) ON DELETE CASCADE
);

COMMENT ON TABLE billing_details IS '請求明细テーブル';
COMMENT ON COLUMN billing_details.detail_id IS '明细ID';
COMMENT ON COLUMN billing_details.billing_id IS '請求ID';
COMMENT ON COLUMN billing_details.line_code IS '線便コード';
COMMENT ON COLUMN billing_details.line_name IS '線便名';
COMMENT ON COLUMN billing_details.daily_rate IS '日別傭車費';
COMMENT ON COLUMN billing_details.days IS '日数';
COMMENT ON COLUMN billing_details.amount IS '金額';

CREATE INDEX idx_billing_details_billing ON billing_details(billing_id);
CREATE INDEX idx_billing_details_line ON billing_details(line_code);

-- ============================================================
-- 第7部分: ファイルアップロードモジュールテーブル
-- ============================================================

-- 7.1 upload_history (アップロード履歴テーブル)
DROP TABLE IF EXISTS upload_history CASCADE;
CREATE TABLE upload_history (
    id BIGSERIAL PRIMARY KEY,
    upload_id VARCHAR(50) NOT NULL UNIQUE,
    company_id VARCHAR(50) NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_type VARCHAR(20) NOT NULL CHECK (file_type IN ('csv', 'excel')),
    file_size BIGINT NOT NULL,
    upload_mode VARCHAR(20) NOT NULL DEFAULT 'add' CHECK (upload_mode IN ('add', 'overwrite')),
    error_handling VARCHAR(20) NOT NULL DEFAULT 'stop' CHECK (error_handling IN ('stop', 'continue')),
    status VARCHAR(20) NOT NULL DEFAULT 'pending' 
        CHECK (status IN ('pending', 'validating', 'processing', 'success', 'partial_success', 'failed')),
    record_count INTEGER DEFAULT 0,
    success_count INTEGER DEFAULT 0,
    failed_count INTEGER DEFAULT 0,
    error_message TEXT,
    memo TEXT,
    uploaded_by VARCHAR(100) NOT NULL,
    uploaded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    processed_at TIMESTAMP,
    processing_time INTEGER,
    
    CONSTRAINT fk_upload_history_company FOREIGN KEY (company_id) 
        REFERENCES partner_companies(company_id) ON DELETE RESTRICT
);

COMMENT ON TABLE upload_history IS 'ファイルアップロード履歴テーブル';
COMMENT ON COLUMN upload_history.upload_id IS 'アップロードID';
COMMENT ON COLUMN upload_history.file_name IS 'ファイル名';
COMMENT ON COLUMN upload_history.file_type IS 'ファイルタイプ: csv, excel';
COMMENT ON COLUMN upload_history.upload_mode IS 'アップロードモード: add-追加, overwrite-上書き';
COMMENT ON COLUMN upload_history.error_handling IS 'エラー処理: stop-停止, continue-継続';
COMMENT ON COLUMN upload_history.status IS '処理ステータス: pending-待機中, validating-検証中, processing-処理中, success-完了, partial_success-部分成功, failed-失敗';
COMMENT ON COLUMN upload_history.record_count IS '総レコード数';
COMMENT ON COLUMN upload_history.success_count IS '成功件数';
COMMENT ON COLUMN upload_history.failed_count IS '失敗件数';
COMMENT ON COLUMN upload_history.uploaded_by IS 'アップロード者';
COMMENT ON COLUMN upload_history.uploaded_at IS 'アップロード日時';
COMMENT ON COLUMN upload_history.processed_at IS '処理完了日時';
COMMENT ON COLUMN upload_history.processing_time IS '処理時間(秒)';

CREATE INDEX idx_upload_history_company ON upload_history(company_id);
CREATE INDEX idx_upload_history_status ON upload_history(status);
CREATE INDEX idx_upload_history_uploaded_at ON upload_history(uploaded_at);

-- 7.2 upload_error_details (アップロードエラーデテールテーブル)
DROP TABLE IF EXISTS upload_error_details CASCADE;
CREATE TABLE upload_error_details (
    id BIGSERIAL PRIMARY KEY,
    error_id VARCHAR(50) NOT NULL UNIQUE,
    upload_id VARCHAR(50) NOT NULL,
    row_number INTEGER NOT NULL,
    column_name VARCHAR(100),
    error_type VARCHAR(50) NOT NULL,
    error_message TEXT NOT NULL,
    original_value TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_upload_error_details_upload FOREIGN KEY (upload_id) 
        REFERENCES upload_history(upload_id) ON DELETE CASCADE
);

COMMENT ON TABLE upload_error_details IS 'アップロードエラーデテールテーブル';
COMMENT ON COLUMN upload_error_details.error_id IS 'エラーID';
COMMENT ON COLUMN upload_error_details.upload_id IS 'アップロードID';
COMMENT ON COLUMN upload_error_details.row_number IS 'エラー行番号';
COMMENT ON COLUMN upload_error_details.column_name IS 'エラー列名';
COMMENT ON COLUMN upload_error_details.error_type IS 'エラータイプ';
COMMENT ON COLUMN upload_error_details.error_message IS 'エラー内容';
COMMENT ON COLUMN upload_error_details.original_value IS '元の値';

CREATE INDEX idx_upload_error_details_upload ON upload_error_details(upload_id);

-- ============================================================
-- 第8部分: 監査ログモジュールテーブル
-- ============================================================

-- 8.1 action_history (アクションハイストリアブル)
DROP TABLE IF EXISTS action_history CASCADE;
CREATE TABLE action_history (
    id BIGSERIAL PRIMARY KEY,
    history_id VARCHAR(50) NOT NULL UNIQUE,
    company_id VARCHAR(50),
    company_name VARCHAR(200),
    action_year_month VARCHAR(7),
    action_date TIMESTAMP NOT NULL,
    action_type VARCHAR(50) NOT NULL,
    action_detail TEXT,
    performed_by VARCHAR(100),
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_action_history_company FOREIGN KEY (company_id) 
        REFERENCES partner_companies(company_id) ON DELETE SET NULL
);

COMMENT ON TABLE action_history IS 'アクションハイストリアブル';
COMMENT ON COLUMN action_history.history_id IS '履歴ID';
COMMENT ON COLUMN action_history.company_id IS '会社ID';
COMMENT ON COLUMN action_history.company_name IS '会社名';
COMMENT ON COLUMN action_history.action_year_month IS 'アクションハイストリア年月(YYYY-MM)';
COMMENT ON COLUMN action_history.action_date IS 'アクション日時';
COMMENT ON COLUMN action_history.action_type IS 'アクションタイプ';
COMMENT ON COLUMN action_history.action_detail IS 'アクション詳細';
COMMENT ON COLUMN action_history.performed_by IS '実行者';

CREATE INDEX idx_action_history_company ON action_history(company_id);
CREATE INDEX idx_action_history_date ON action_history(action_date);
CREATE INDEX idx_action_history_year_month ON action_history(action_year_month);
CREATE INDEX idx_action_history_performed_by ON action_history(performed_by);

-- 8.2 partner_audit_log (パートナー監査ログテーブル)
DROP TABLE IF EXISTS partner_audit_log CASCADE;
CREATE TABLE partner_audit_log (
    id BIGSERIAL PRIMARY KEY,
    company_id VARCHAR(50) NOT NULL,
    user_id VARCHAR(50),
    action_type VARCHAR(50) NOT NULL,
    action_detail TEXT,
    before_value TEXT,
    after_value TEXT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    performed_by VARCHAR(100) NOT NULL,
    performed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_partner_audit_log_company FOREIGN KEY (company_id) 
        REFERENCES partner_companies(company_id) ON DELETE CASCADE
);

COMMENT ON TABLE partner_audit_log IS 'パートナー監査ログテーブル';
COMMENT ON COLUMN partner_audit_log.company_id IS '会社ID';
COMMENT ON COLUMN partner_audit_log.user_id IS 'ユーザーID';
COMMENT ON COLUMN partner_audit_log.action_type IS 'アクションタイプ';
COMMENT ON COLUMN partner_audit_log.action_detail IS 'アクション詳細';
COMMENT ON COLUMN partner_audit_log.before_value IS '変更前値';
COMMENT ON COLUMN partner_audit_log.after_value IS '変更後値';
COMMENT ON COLUMN partner_audit_log.ip_address IS 'IPアドレス';
COMMENT ON COLUMN partner_audit_log.user_agent IS 'ユーザーエージェント';
COMMENT ON COLUMN partner_audit_log.performed_by IS '実行者';
COMMENT ON COLUMN partner_audit_log.performed_at IS '実行日時';

CREATE INDEX idx_partner_audit_log_company ON partner_audit_log(company_id);
CREATE INDEX idx_partner_audit_log_user ON partner_audit_log(user_id);
CREATE INDEX idx_partner_audit_log_time ON partner_audit_log(performed_at);

-- 8.3 base_account_audit_log (ベースアカウント監査ログテーブル)
DROP TABLE IF EXISTS base_account_audit_log CASCADE;
CREATE TABLE base_account_audit_log (
    id BIGSERIAL PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    changed_field VARCHAR(50) NOT NULL,
    before_value TEXT,
    after_value TEXT,
    change_reason TEXT,
    performed_by VARCHAR(100) NOT NULL,
    performed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_base_account_audit_log_user FOREIGN KEY (user_id) 
        REFERENCES base_accounts(user_id) ON DELETE CASCADE
);

COMMENT ON TABLE base_account_audit_log IS 'ベースアカウント監査ログテーブル';
COMMENT ON COLUMN base_account_audit_log.user_id IS 'ユーザーID';
COMMENT ON COLUMN base_account_audit_log.changed_field IS '変更フィールド';
COMMENT ON COLUMN base_account_audit_log.before_value IS '変更前値';
COMMENT ON COLUMN base_account_audit_log.after_value IS '変更後値';
COMMENT ON COLUMN base_account_audit_log.change_reason IS '変更理由';
COMMENT ON COLUMN base_account_audit_log.performed_by IS '実行者';
COMMENT ON COLUMN base_account_audit_log.performed_at IS '実行日時';

CREATE INDEX idx_base_account_audit_log_user ON base_account_audit_log(user_id);
CREATE INDEX idx_base_account_audit_log_time ON base_account_audit_log(performed_at);

-- ============================================================
-- 第9部分: メッセージモジュールテーブル
-- ============================================================

-- 9.1 messages (メッセージテーブル)
DROP TABLE IF EXISTS messages CASCADE;
CREATE TABLE messages (
    id BIGSERIAL PRIMARY KEY,
    message_id VARCHAR(50) NOT NULL UNIQUE,
    order_id VARCHAR(50),
    completed_order_id VARCHAR(50),
    sender_id VARCHAR(50) NOT NULL,
    sender_type VARCHAR(20) NOT NULL CHECK (sender_type IN ('partner', 'base')),
    content TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_messages_order FOREIGN KEY (order_id) 
        REFERENCES orders(order_id) ON DELETE CASCADE,
    CONSTRAINT fk_messages_completed_order FOREIGN KEY (completed_order_id) 
        REFERENCES completed_orders(completed_order_id) ON DELETE CASCADE
);

COMMENT ON TABLE messages IS 'メッセージテーブル';
COMMENT ON COLUMN messages.message_id IS 'メッセージID';
COMMENT ON COLUMN messages.order_id IS '関連発注ID';
COMMENT ON COLUMN messages.completed_order_id IS '関連実績ID';
COMMENT ON COLUMN messages.sender_id IS '送信者ID';
COMMENT ON COLUMN messages.sender_type IS '送信者タイプ: partner-パートナー, base-ベース';
COMMENT ON COLUMN messages.content IS 'メッセージ内容';
COMMENT ON COLUMN messages.is_read IS '既読フラグ';

CREATE INDEX idx_messages_order ON messages(order_id);
CREATE INDEX idx_messages_completed_order ON messages(completed_order_id);
CREATE INDEX idx_messages_sender ON messages(sender_id);

-- ============================================================
-- 終了マーク
-- ============================================================
-- DDLスクリプト実行完了
-- 含まれる: 17個のデータテーブル
-- 作成日時: 2026-02-xx
-- ============================================================
