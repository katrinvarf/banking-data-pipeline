import os

import psycopg2
from dotenv import load_dotenv


load_dotenv()


def get_connection():
    return psycopg2.connect(
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT"),
        dbname=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD")
    )


def load_f101(conn, process_date):
    with conn.cursor() as cur:
        cur.execute("CALL dm.fill_f101_round_f(%s);", (process_date,))


def main():
    with get_connection() as conn:
        process_date = "2018-02-01"
        load_f101(conn, process_date)
        conn.commit()


if __name__ == "__main__":
    main()