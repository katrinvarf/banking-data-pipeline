-- ======================
-- TABLE: ds.ft_balance_f
-- ======================

CREATE TABLE IF NOT EXISTS ds.ft_balance_f (
	on_date DATE NOT NULL,
	account_rk NUMERIC NOT NULL,
	currency_rk NUMERIC,
	balance_out NUMERIC(23, 8),

	CONSTRAINT pk_ft_balance_f PRIMARY KEY (on_date, account_rk)
);

COMMENT ON TABLE ds.ft_balance_f IS 'Остатки на лицевых счетах';
COMMENT ON COLUMN ds.ft_balance_f.on_date IS 'Дата, за которую актуален остаток';
COMMENT ON COLUMN ds.ft_balance_f.account_rk IS 'Идентификатор счета';
COMMENT ON COLUMN ds.ft_balance_f.currency_rk IS 'Идентификатор валюты счета';
COMMENT ON COLUMN ds.ft_balance_f.balance_out IS 'Остаток в валюте счета';

-- ======================
-- TABLE: ds.ft_posting_f
-- ======================

CREATE TABLE IF NOT EXISTS ds.ft_posting_f (
	oper_date DATE NOT NULL,
	credit_account_rk NUMERIC NOT NULL,
	debet_account_rk NUMERIC NOT NULL,
	credit_amount NUMERIC(23, 8),
	debet_amount NUMERIC(23, 8)
);

COMMENT ON TABLE ds.ft_posting_f IS 'Проводки';
COMMENT ON COLUMN ds.ft_posting_f.oper_date IS 'Дата проводки';
COMMENT ON COLUMN ds.ft_posting_f.credit_account_rk IS 'Ссылка на счет по кредиту';
COMMENT ON COLUMN ds.ft_posting_f.debet_account_rk IS 'Ссылка на счет по дебету';
COMMENT ON COLUMN ds.ft_posting_f.credit_amount IS 'Сумма в валюте счета кредита';
COMMENT ON COLUMN ds.ft_posting_f.debet_amount IS 'Сумма в валюте счета дебета';

-- ======================
-- TABLE: ds.md_account_d
-- ======================

CREATE TABLE IF NOT EXISTS ds.md_account_d (
	data_actual_date DATE NOT NULL,
	data_actual_end_date DATE NOT NULL,
	account_rk NUMERIC NOT NULL,
	account_number VARCHAR(20) NOT NULL,
	char_type CHAR(1) NOT NULL,
	currency_rk NUMERIC NOT NULL,
	currency_code VARCHAR(3) NOT NULL,

	CONSTRAINT pk_md_account_d PRIMARY KEY (data_actual_date, account_rk)
);

COMMENT ON TABLE ds.md_account_d IS 'Лицевой счет';
COMMENT ON COLUMN ds.md_account_d.data_actual_date IS 'Дата начала актуальности бизнес данных';
COMMENT ON COLUMN ds.md_account_d.data_actual_end_date IS 'Дата окончания актуальности бизнес данных';
COMMENT ON COLUMN ds.md_account_d.account_rk IS 'Идентификатор счета';
COMMENT ON COLUMN ds.md_account_d.account_number IS 'Номер счета';
COMMENT ON COLUMN ds.md_account_d.char_type IS 'Характеристика счета ("А" – активный ; "П" – пассивный)';
COMMENT ON COLUMN ds.md_account_d.currency_rk IS 'Идентификатор валюты счета';
COMMENT ON COLUMN ds.md_account_d.currency_code IS 'Код валюты';

-- =======================
-- TABLE: ds.md_currency_d
-- =======================

CREATE TABLE IF NOT EXISTS ds.md_currency_d (
	currency_rk NUMERIC NOT NULL,
	data_actual_date DATE NOT NULL,
	data_actual_end_date DATE,
	currency_code VARCHAR(3),
	code_iso_char VARCHAR(3),

	CONSTRAINT pk_md_currency_d PRIMARY KEY (currency_rk, data_actual_date)
);

COMMENT ON TABLE ds.md_currency_d IS 'Валюта';
COMMENT ON COLUMN ds.md_currency_d.currency_rk IS 'Идентификатор валюты счета';
COMMENT ON COLUMN ds.md_currency_d.data_actual_date IS 'Дата начала актуальности бизнес данных';
COMMENT ON COLUMN ds.md_currency_d.data_actual_end_date IS 'Дата окончания актуальности бизнес данных';
COMMENT ON COLUMN ds.md_currency_d.currency_code IS 'Код валюты';
COMMENT ON COLUMN ds.md_currency_d.code_iso_char IS 'Буквенный код ISO';

-- ============================
-- TABLE: ds.md_exchange_rate_d
-- ============================

CREATE TABLE IF NOT EXISTS ds.md_exchange_rate_d (
	data_actual_date DATE NOT NULL,
	data_actual_end_date DATE,
	currency_rk NUMERIC NOT NULL,
	reduced_cource NUMERIC(23, 8),
	code_iso_num VARCHAR(3),

	CONSTRAINT pk_md_exchange_rate_d PRIMARY KEY (data_actual_date, currency_rk)
);

COMMENT ON TABLE ds.md_exchange_rate_d IS 'Курсы валют';
COMMENT ON COLUMN ds.md_exchange_rate_d.data_actual_date IS 'Дата начала актуальности бизнес данных';
COMMENT ON COLUMN ds.md_exchange_rate_d.data_actual_end_date IS 'Дата окончания актуальности бизнес данных';
COMMENT ON COLUMN ds.md_exchange_rate_d.currency_rk IS 'Идентификатор валюты счета';
COMMENT ON COLUMN ds.md_exchange_rate_d.reduced_cource IS 'Курс';
COMMENT ON COLUMN ds.md_exchange_rate_d.code_iso_num IS 'Числовой код валюты';

-- =============================
-- TABLE: ds.md_ledger_account_s
-- =============================

CREATE TABLE IF NOT EXISTS ds.md_ledger_account_s (
	chapter CHAR(1),
	chapter_name VARCHAR(16),
	section_number INTEGER,
	section_name VARCHAR(22),
	subsection_name VARCHAR(21),
	ledger1_account INTEGER,
	ledger1_account_name VARCHAR(47),
	ledger_account INTEGER NOT NULL,
	ledger_account_name VARCHAR(153),
	characteristic CHAR(1),
	start_date DATE NOT NULL,
	end_date DATE,

	CONSTRAINT pk_md_ledger_account_s PRIMARY KEY (ledger_account, start_date)
);

COMMENT ON TABLE ds.md_ledger_account_s IS 'Справочник балансовых счетов';
COMMENT ON COLUMN ds.md_ledger_account_s.chapter IS 'Глава';
COMMENT ON COLUMN ds.md_ledger_account_s.chapter_name IS 'Наименование главы';
COMMENT ON COLUMN ds.md_ledger_account_s.section_number IS 'Номер раздела';
COMMENT ON COLUMN ds.md_ledger_account_s.section_name IS 'Наименование раздела';
COMMENT ON COLUMN ds.md_ledger_account_s.subsection_name IS 'Наименование подраздела';
COMMENT ON COLUMN ds.md_ledger_account_s.ledger1_account IS 'Счет первого порядка';
COMMENT ON COLUMN ds.md_ledger_account_s.ledger1_account_name IS 'Наименование счета первого порядка';
COMMENT ON COLUMN ds.md_ledger_account_s.ledger_account IS 'Счет второго порядка';
COMMENT ON COLUMN ds.md_ledger_account_s.ledger_account_name IS 'Наименование счета второго порядка';
COMMENT ON COLUMN ds.md_ledger_account_s.characteristic IS 'Характеристика счета ("А" – активный ; "П" – пассивный)';
COMMENT ON COLUMN ds.md_ledger_account_s.start_date IS 'Дата начала действия записи';
COMMENT ON COLUMN ds.md_ledger_account_s.end_date IS 'Дата окончания действия записи';