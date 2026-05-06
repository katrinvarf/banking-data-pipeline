CREATE OR REPLACE PROCEDURE ds.fill_account_balance_f (i_OnDate DATE)
LANGUAGE plpgsql AS
$$
    DECLARE
        v_log_id INTEGER;
        v_rows_processed INTEGER;
    BEGIN
        INSERT INTO logs.process_log (
            process_name, status, start_time, description
        )
        VALUES (
            'fill_account_balance_f',
            'STARTED',
            NOW(),
            'Calculate dm.dm_account_balance_f for date ' || i_OnDate
        )
        RETURNING log_id INTO v_log_id;

        DELETE FROM dm.dm_account_balance_f
        WHERE on_date = i_OnDate;

        INSERT INTO dm.dm_account_balance_f (
            on_date,
            account_rk,
            balance_out,
            balance_out_rub
        )
        SELECT
            i_OnDate,
            mad.account_rk,
            CASE
                WHEN mad.char_type = 'А' 
                    THEN COALESCE(dabf.balance_out, 0) + COALESCE(datf.debet_amount, 0) - COALESCE(datf.credit_amount, 0)
                WHEN mad.char_type = 'П' 
                    THEN COALESCE(dabf.balance_out, 0) - COALESCE(datf.debet_amount, 0) + COALESCE(datf.credit_amount, 0)
            END AS balance_out,
            CASE
                WHEN mad.char_type = 'А' 
                    THEN COALESCE(dabf.balance_out_rub, 0) + COALESCE(datf.debet_amount_rub, 0) - COALESCE(datf.credit_amount_rub, 0)
                WHEN mad.char_type = 'П' 
                    THEN COALESCE(dabf.balance_out_rub, 0) - COALESCE(datf.debet_amount_rub, 0) + COALESCE(datf.credit_amount_rub, 0)
            END AS balance_out_rub
        FROM ds.md_account_d mad
            LEFT JOIN dm.dm_account_turnover_f datf ON datf.account_rk = mad.account_rk AND datf.on_date = i_OnDate
            LEFT JOIN dm.dm_account_balance_f dabf ON dabf.account_rk = mad.account_rk AND dabf.on_date = i_OnDate - 1
        WHERE i_OnDate BETWEEN mad.data_actual_date AND mad.data_actual_end_date;
        
        GET DIAGNOSTICS v_rows_processed = ROW_COUNT;

        UPDATE logs.process_log
        SET status = 'SUCCESS',
            end_time = NOW(),
            rows_processed = v_rows_processed
        WHERE log_id = v_log_id;

    EXCEPTION
        WHEN OTHERS THEN
            UPDATE logs.process_log
            SET status = 'FAILED',
                end_time = NOW(),
                error_message = SQLERRM
            WHERE log_id = v_log_id;

            RAISE;
    END;
$$;