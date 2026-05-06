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


def export_f101(conn):
    os.makedirs("data/exports", exist_ok=True)
    with conn.cursor() as cur:
        query = "COPY dm.dm_f101_round_f TO STDOUT WITH CSV HEADER DELIMITER ';'"
        with open("data/exports/f101.csv", "w", encoding="utf-8") as file:
            cur.copy_expert(query, file)


def import_f101_v2(conn):
    with conn.cursor() as cur:
        cur.execute("TRUNCATE TABLE dm.dm_f101_round_f_v2;")
        with open("data/exports/f101.csv", "r", encoding="utf-8") as file:
            query = "COPY dm.dm_f101_round_f_v2 FROM STDIN WITH CSV HEADER DELIMITER ';'"
            cur.copy_expert(query, file)


def main():
    with get_connection() as conn:
        export_f101(conn)
        import_f101_v2(conn)
        conn.commit()


if __name__ == "__main__":
    main()
