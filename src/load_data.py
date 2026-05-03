import os

import psycopg2
import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine


DS_TABLES = [
    "ft_balance_f",
    "ft_posting_f",
    "md_account_d",
    "md_currency_d",
    "md_exchange_rate_d",
    "md_ledger_account_s"
]


load_dotenv()


def get_engine():
    return create_engine(
        f"postgresql+psycopg2://{os.getenv('DB_USER')}:{os.getenv('DB_PASSWORD')}"
        f"@{os.getenv('DB_HOST')}:{os.getenv('DB_PORT')}/{os.getenv('DB_NAME')}"
    )


def get_connection():
    return psycopg2.connect(
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT"),
        dbname=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD")
    )


def execute_sql_file(conn, file_path):
    with open(file_path, "r", encoding="utf-8") as file:
        sql = file.read()
    with conn.cursor() as cur:
        cur.execute(sql)
        return cur.rowcount


def load_to_stage(table_name):
    df = pd.read_csv(f"data/raw/{table_name}.csv", delimiter=";", encoding_errors="replace")
    engine = get_engine()
    df.to_sql(table_name, engine, schema="stage", if_exists="replace", index=False)
    return len(df)


def load_to_ds(conn, table_name):
    with conn.cursor() as cur:
        cur.execute(f"TRUNCATE TABLE ds.{table_name};")

    rows_inserted = execute_sql_file(conn, f"sql/ds/dml/insert_{table_name}.sql")
    return rows_inserted


def main():
    with get_connection() as conn:
        for table_name in DS_TABLES:
            stage_rows = load_to_stage(table_name)
            ds_rows = load_to_ds(conn, table_name)
            conn.commit()
            print(table_name, stage_rows, ds_rows)


if __name__ == "__main__":
    main()
