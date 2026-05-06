import os

import psycopg2
import pandas as pd
from dotenv import load_dotenv
from logging_utils import start_log, finish_log_success, finish_log_failed


load_dotenv()


def get_connection():
    return psycopg2.connect(
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT"),
        dbname=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD")
    )


def load_account_turnover(conn, process_date):
    with conn.cursor() as cur:
        cur.execute("CALL ds.fill_account_turnover_f(%s);", (process_date,))


def init_account_balance(conn):
    process_date = "2017-12-31"
    log_id = start_log(
        conn, 
        process_name="init_account_balance",
        description=f"Init account balance for date {process_date}"
    )
    conn.commit()

    try:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM dm.dm_account_balance_f WHERE on_date = %s;", (process_date,))
            cur.execute('''
                INSERT INTO dm.dm_account_balance_f (
                    on_date,
                    account_rk,
                    balance_out,
                    balance_out_rub
                )
                SELECT
                    fbf.on_date,
                    fbf.account_rk,
                    fbf.balance_out,
                    fbf.balance_out * COALESCE(merd.reduced_cource, 1)
                FROM ds.ft_balance_f fbf
                    LEFT JOIN ds.md_exchange_rate_d merd ON merd.currency_rk = fbf.currency_rk 
                        AND %s >= merd.data_actual_date 
                        AND (%s <= merd.data_actual_end_date OR merd.data_actual_end_date IS NULL)
                WHERE fbf.on_date = %s
            ''', (process_date, process_date, process_date))
            rows_inserted = cur.rowcount

        finish_log_success(conn, log_id, rows_processed=rows_inserted)
        conn.commit()

        print(f"[DM] Initialized balance for {process_date}")

    except Exception as error:
        conn.rollback()
        finish_log_failed(conn, log_id, error)
        conn.commit()
        raise


def load_account_balance(conn, process_date):
    with conn.cursor() as cur:
        cur.execute("CALL ds.fill_account_balance_f(%s);", (process_date,))


def main():
    with get_connection() as conn:
        init_account_balance(conn)
        for dt in pd.date_range("2018-01-01", "2018-01-31"):
            process_date = dt.date()

            load_account_turnover(conn, process_date)
            load_account_balance(conn, process_date)

            conn.commit()

            print(f"[DM] {process_date}: turnover + balance calculated")


if __name__ == "__main__":
    main()
