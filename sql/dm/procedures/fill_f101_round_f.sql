CREATE OR REPLACE PROCEDURE dm.fill_f101_round_f (i_OnDate DATE)
LANGUAGE plpgsql AS
$$
    DECLARE
        v_from_date DATE := (DATE_TRUNC('month', i_OnDate - INTERVAL '1 month'))::DATE;
        v_to_date DATE := (v_from_date + INTERVAL '1 month' - INTERVAL '1 day')::DATE;
    BEGIN
        DELETE FROM dm.dm_f101_round_f
        WHERE from_date = v_from_date AND to_date = v_to_date;

        WITH account_char AS (
            SELECT DISTINCT
                SUBSTRING(mad.account_number, 1, 5)::INTEGER AS ledger_account,
                mad.char_type
            FROM ds.md_account_d mad
            WHERE mad.data_actual_date <= v_to_date AND mad.data_actual_end_date >= v_from_date
        ),
        balance_in_calc AS (
            SELECT
                SUBSTRING(mad.account_number, 1, 5)::INTEGER AS ledger_account,
                SUM(CASE WHEN mad.currency_code IN ('810', '643') THEN dabf.balance_out_rub ELSE 0 END) AS balance_in_rub,
                SUM(CASE WHEN mad.currency_code NOT IN ('810', '643') THEN dabf.balance_out_rub ELSE 0 END) AS balance_in_val
            FROM dm.dm_account_balance_f dabf
                JOIN ds.md_account_d mad ON mad.account_rk = dabf.account_rk
                    AND mad.data_actual_date <= v_to_date AND mad.data_actual_end_date >= v_from_date
            WHERE dabf.on_date = v_from_date - 1
            GROUP BY SUBSTRING(mad.account_number, 1, 5)::INTEGER
        ),
        balance_out_calc AS (
            SELECT
                SUBSTRING(mad.account_number, 1, 5)::INTEGER AS ledger_account,
                SUM(CASE WHEN mad.currency_code IN ('810', '643') THEN dabf.balance_out_rub ELSE 0 END) AS balance_out_rub,
                SUM(CASE WHEN mad.currency_code NOT IN ('810', '643') THEN dabf.balance_out_rub ELSE 0 END) AS balance_out_val
            FROM dm.dm_account_balance_f dabf
                JOIN ds.md_account_d mad ON mad.account_rk = dabf.account_rk
                    AND dabf.on_date BETWEEN mad.data_actual_date AND mad.data_actual_end_date
            WHERE dabf.on_date = v_to_date
            GROUP BY SUBSTRING(mad.account_number, 1, 5)::INTEGER
        ),
        turnover_calc AS (
            SELECT 
                SUBSTRING(mad.account_number, 1, 5)::INTEGER AS ledger_account,
                SUM(CASE WHEN mad.currency_code IN ('810', '643') THEN datf.debet_amount_rub ELSE 0 END) AS turn_deb_rub,
                SUM(CASE WHEN mad.currency_code NOT IN ('810', '643') THEN datf.debet_amount_rub ELSE 0 END) AS turn_deb_val,
                SUM(CASE WHEN mad.currency_code IN ('810', '643') THEN datf.credit_amount_rub ELSE 0 END) AS turn_cre_rub,
                SUM(CASE WHEN mad.currency_code NOT IN ('810', '643') THEN datf.credit_amount_rub ELSE 0 END) AS turn_cre_val
            FROM dm.dm_account_turnover_f datf
                JOIN ds.md_account_d mad ON mad.account_rk = datf.account_rk
                    AND datf.on_date BETWEEN mad.data_actual_date AND mad.data_actual_end_date
            WHERE datf.on_date BETWEEN v_from_date AND v_to_date
            GROUP BY SUBSTRING(mad.account_number, 1, 5)::INTEGER
        )

        INSERT INTO dm.dm_f101_round_f (
            from_date,
            to_date,
            chapter,
            ledger_account,
            characteristic,
            balance_in_rub,
            balance_in_val,
            balance_in_total,
            turn_deb_rub,
            turn_deb_val,
            turn_deb_total,
            turn_cre_rub,
            turn_cre_val,
            turn_cre_total,
            balance_out_rub,
            balance_out_val,
            balance_out_total
        )
        SELECT
            v_from_date,
            v_to_date,
            mlas.chapter,
            mlas.ledger_account,
            acc_char.char_type,
            COALESCE(bal_in.balance_in_rub, 0) AS balance_in_rub,
            COALESCE(bal_in.balance_in_val, 0) AS balance_in_val,
            COALESCE(bal_in.balance_in_rub, 0) + COALESCE(bal_in.balance_in_val, 0) AS balance_in_total,
            COALESCE(turn.turn_deb_rub, 0) AS turn_deb_rub,
            COALESCE(turn.turn_deb_val, 0) AS turn_deb_val,
            COALESCE(turn.turn_deb_rub, 0) + COALESCE(turn.turn_deb_val, 0) AS turn_deb_total,
            COALESCE(turn.turn_cre_rub, 0) AS turn_cre_rub,
            COALESCE(turn.turn_cre_val, 0) AS turn_cre_val,
            COALESCE(turn.turn_cre_rub, 0) + COALESCE(turn.turn_cre_val, 0) AS turn_cre_total,
            COALESCE(bal_out.balance_out_rub, 0) AS balance_out_rub,
            COALESCE(bal_out.balance_out_val, 0) AS balance_out_val,
            COALESCE(bal_out.balance_out_rub, 0) + COALESCE(bal_out.balance_out_val, 0) AS balance_out_total
        FROM ds.md_ledger_account_s mlas 
            JOIN account_char acc_char USING (ledger_account)
            LEFT JOIN balance_in_calc bal_in USING (ledger_account)
            LEFT JOIN balance_out_calc bal_out USING (ledger_account)
            LEFT JOIN turnover_calc turn USING (ledger_account)
        ORDER BY mlas.ledger_account;
    END;
$$;