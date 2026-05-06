CREATE OR REPLACE PROCEDURE ds.fill_account_turnover_f (i_OnDate DATE)
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
            'fill_account_turnover_f',
            'STARTED',
            NOW(),
            'Calculate dm.dm_account_turnover_f for date ' || i_OnDate
        )
        RETURNING log_id INTO v_log_id;

        DELETE FROM dm.dm_account_turnover_f
        WHERE on_date = i_OnDate;

        WITH posting_totals AS (
            SELECT 
                COALESCE(credit_totals.credit_account_rk, debet_totals.debet_account_rk) AS account_rk,
                COALESCE(credit_totals.oper_date, debet_totals.oper_date) AS oper_date,
                COALESCE(credit_totals.sum_credit_amount, 0) AS credit_amount,
                COALESCE(debet_totals.sum_debet_amount, 0) AS debet_amount
            FROM (
                SELECT fpf.credit_account_rk, fpf.oper_date, SUM(fpf.credit_amount) AS sum_credit_amount
                FROM ds.ft_posting_f fpf
                WHERE fpf.oper_date = i_OnDate
                GROUP BY fpf.credit_account_rk, fpf.oper_date
            ) credit_totals
                FULL JOIN (
                    SELECT fpf.debet_account_rk, fpf.oper_date, SUM(fpf.debet_amount) AS sum_debet_amount
                    FROM ds.ft_posting_f fpf
                    WHERE fpf.oper_date = i_OnDate
                    GROUP BY fpf.debet_account_rk, fpf.oper_date
                ) debet_totals 
                ON credit_totals.oper_date = debet_totals.oper_date 
                    AND credit_totals.credit_account_rk = debet_totals.debet_account_rk
        )

        INSERT INTO dm.dm_account_turnover_f (
            on_date,
            account_rk,
            credit_amount,
            credit_amount_rub,
            debet_amount,
            debet_amount_rub
        )
        SELECT 
            i_OnDate,
            pt.account_rk, 
            pt.credit_amount,
            pt.credit_amount * COALESCE(merd.reduced_cource, 1),
            pt.debet_amount,
            pt.debet_amount * COALESCE(merd.reduced_cource, 1)
        FROM posting_totals pt
            JOIN ds.md_account_d mad ON pt.oper_date BETWEEN mad.data_actual_date AND mad.data_actual_end_date
                AND mad.account_rk = pt.account_rk
            LEFT JOIN ds.md_exchange_rate_d merd ON merd.currency_rk = mad.currency_rk 
                AND pt.oper_date >= merd.data_actual_date 
                AND (pt.oper_date <= merd.data_actual_end_date OR merd.data_actual_end_date IS NULL);

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