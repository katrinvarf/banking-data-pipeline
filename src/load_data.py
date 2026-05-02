import os
from dotenv import load_dotenv
import pandas as pd
from sqlalchemy import create_engine


load_dotenv()

DS_TABLES = [
    "ft_balance_f",
    "ft_posting_f",
    "md_account_d",
    "md_currency_d",
    "md_exchange_rate_d",
    "md_ledger_account_s"
]


def get_engine():
    return create_engine(
        f"postgresql+psycopg2://{os.getenv('DB_USER')}:{os.getenv('DB_PASSWORD')}"
        f"@{os.getenv('DB_HOST')}:{os.getenv('DB_PORT')}/{os.getenv('DB_NAME')}"
    )

def load_to_stage(table_name):
    df = pd.read_csv(f"data/raw/{table_name}.csv", delimiter=";", encoding_errors="replace")
    engine = get_engine()
    df.to_sql(table_name, engine, schema="stage", if_exists="replace", index=False)

if __name__ == "__main__":
    for table_name in DS_TABLES:
        load_to_stage(table_name)