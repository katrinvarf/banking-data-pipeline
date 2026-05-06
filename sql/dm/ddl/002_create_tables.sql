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

-- =====================
-- TABLE: dm.dm_f101_round_f
-- =====================

CREATE TABLE IF NOT EXISTS dm.dm_f101_round_f (
	from_date DATE,
	to_date DATE,
	chapter CHAR(1),
	ledger_account CHAR(5),
	characteristic CHAR(1),
	balance_in_rub NUMERIC(23, 8),
	balance_in_val NUMERIC(23, 8),
	balance_in_total NUMERIC(23, 8),
	turn_deb_rub NUMERIC(23, 8),
	turn_deb_val NUMERIC(23, 8),
	turn_deb_total NUMERIC(23, 8),
	turn_cre_rub NUMERIC(23, 8),
	turn_cre_val NUMERIC(23, 8),
	turn_cre_total NUMERIC(23, 8),
	balance_out_rub NUMERIC(23, 8),
	balance_out_val NUMERIC(23, 8),
	balance_out_total NUMERIC(23, 8)
);

COMMENT ON TABLE dm.dm_f101_round_f IS 'Витрина с данными по 101 форме';
COMMENT ON COLUMN dm.dm_f101_round_f.from_date IS 'Начало интервала расчета';
COMMENT ON COLUMN dm.dm_f101_round_f.to_date IS 'Конец интервала расчета';
COMMENT ON COLUMN dm.dm_f101_round_f.chapter IS 'Глава баланса';
COMMENT ON COLUMN dm.dm_f101_round_f.ledger_account IS 'Балансовый счет';
COMMENT ON COLUMN dm.dm_f101_round_f.characteristic IS 'Характеристика счета';
COMMENT ON COLUMN dm.dm_f101_round_f.balance_in_rub IS 'Входящий остаток для рублевых счетов';
COMMENT ON COLUMN dm.dm_f101_round_f.balance_in_val IS 'Входящий остаток для счетов в валюте и драг. Металлах';
COMMENT ON COLUMN dm.dm_f101_round_f.balance_in_total IS 'Входящий остаток – итого';
COMMENT ON COLUMN dm.dm_f101_round_f.turn_deb_rub IS 'Сумма дебетовых оборотов для рублевых счетов';
COMMENT ON COLUMN dm.dm_f101_round_f.turn_deb_val IS 'Сумма дебетовых оборотов для счетов в валюте и драг. Металлах';
COMMENT ON COLUMN dm.dm_f101_round_f.turn_deb_total IS 'Сумма дебетовых оборотов – итого';
COMMENT ON COLUMN dm.dm_f101_round_f.turn_cre_rub IS 'Сумма кредитовых оборотов для рублевых счетов';
COMMENT ON COLUMN dm.dm_f101_round_f.turn_cre_val IS 'Сумма кредитовых оборотов для счетов в валюте и драг. Металлах';
COMMENT ON COLUMN dm.dm_f101_round_f.turn_cre_total IS 'Сумма кредитовых оборотов – итого';
COMMENT ON COLUMN dm.dm_f101_round_f.balance_out_rub IS 'Сумма исходящего остатка для рублевых счетов';
COMMENT ON COLUMN dm.dm_f101_round_f.balance_out_val IS 'Сумма исходящего остатка для счетов в валюте и драг. металлах';
COMMENT ON COLUMN dm.dm_f101_round_f.balance_out_total IS 'Сумма исходящего остатка - итого';

-- =====================
-- TABLE: dm.dm_f101_round_f_v2
-- =====================

CREATE TABLE IF NOT EXISTS dm.dm_f101_round_f_v2 (
	LIKE dm.dm_f101_round_f INCLUDING ALL
);