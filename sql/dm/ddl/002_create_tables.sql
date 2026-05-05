-- =====================
-- TABLE: dm.dm_account_turnover_f
-- =====================

CREATE TABLE IF NOT EXISTS dm.dm_account_turnover_f (
	on_date DATE,
	account_rk NUMERIC,
	credit_amount NUMERIC(23, 8),
	credit_amount_rub NUMERIC(23, 8),
	debet_amount NUMERIC(23, 8),
	debet_amount_rub NUMERIC(23, 8)
);

COMMENT ON TABLE dm.dm_account_turnover_f IS 'Обороты по лицевым счетам';
COMMENT ON COLUMN dm.dm_account_turnover_f.on_date IS 'Дата (за которую актуальны обороты)';
COMMENT ON COLUMN dm.dm_account_turnover_f.account_rk IS 'Идентификатор счета';
COMMENT ON COLUMN dm.dm_account_turnover_f.credit_amount IS 'Кредитовый оборот в валюте счета';
COMMENT ON COLUMN dm.dm_account_turnover_f.credit_amount_rub IS 'Кредитовый оборот в рублях';
COMMENT ON COLUMN dm.dm_account_turnover_f.debet_amount IS 'Дебетовый оборот в валюте счета';
COMMENT ON COLUMN dm.dm_account_turnover_f.debet_amount_rub IS 'Дебетовый оборот в рублях';

-- =====================
-- TABLE: dm.dm_account_balance_f
-- =====================

CREATE TABLE IF NOT EXISTS dm.dm_account_balance_f (
	on_date DATE,
	account_rk NUMERIC,
	balance_out NUMERIC(23, 8),
	balance_out_rub NUMERIC(23, 8)
);

COMMENT ON TABLE dm.dm_account_balance_f IS 'Остатки по лицевым счетам';
COMMENT ON COLUMN dm.dm_account_balance_f.on_date IS 'Дата (за которую актуальны обороты)';
COMMENT ON COLUMN dm.dm_account_balance_f.account_rk IS 'Идентификатор счета';
COMMENT ON COLUMN dm.dm_account_balance_f.balance_out IS 'Остаток в валюте счета';
COMMENT ON COLUMN dm.dm_account_balance_f.balance_out_rub IS 'Остаток в рублях';