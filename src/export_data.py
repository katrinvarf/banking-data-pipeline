import os

import psycopg2
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


def export_f101(conn):
    log_id = start_log(
        conn, 
        process_name="export_f101",
        description="Export dm.dm_f101_round_f to CSV"
    )
    conn.commit()

    try:
        os.makedirs("data/exports", exist_ok=True)

        with conn.cursor() as cur:
            query = "COPY dm.dm_f101_round_f TO STDOUT WITH CSV HEADER DELIMITER ';'"
            with open("data/exports/f101.csv", "w", encoding="utf-8") as file:
                cur.copy_expert(query, file)

        finish_log_success(conn, log_id)
        conn.commit()

    except Exception as error:
        conn.rollback()
        finish_log_failed(conn, log_id, error)
        conn.commit()
        raise


def import_f101_v2(conn):
    log_id = start_log(
        conn, 
        process_name="import_f101_v2",
        description="Import CSV to dm.dm_f101_round_f_v2"
    )
    conn.commit()

    try:
        with conn.cursor() as cur:
            cur.execute("TRUNCATE TABLE dm.dm_f101_round_f_v2;")
            with open("data/exports/f101.csv", "r", encoding="utf-8") as file:
                query = "COPY dm.dm_f101_round_f_v2 FROM STDIN WITH CSV HEADER DELIMITER ';'"
                cur.copy_expert(query, file)

        finish_log_success(conn, log_id)
        conn.commit()

    except Exception as error:
        conn.rollback()
        finish_log_failed(conn, log_id, error)
        conn.commit()
        raise


def main():
    with get_connection() as conn:
        export_f101(conn)
        print("[EXPORT] F101 exported to CSV")

        import_f101_v2(conn)
        conn.commit()
        print("[IMPORT] F101 imported to dm.dm_f101_round_f_v2")


if __name__ == "__main__":
    main()
