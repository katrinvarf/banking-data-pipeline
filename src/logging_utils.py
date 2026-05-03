from datetime import datetime


def start_log(conn, process_name, description=None):
    with conn.cursor() as cur:
        cur.execute('''
            INSERT INTO logs.process_log (
                process_name, status, start_time, description
            )
            VALUES (%s, %s, %s, %s)
            RETURNING log_id;
        ''', (process_name, 'STARTED', datetime.now(), description))

        return cur.fetchone()[0]


def finish_log_success(conn, log_id, rows_processed=None):
    with conn.cursor() as cur:
        cur.execute('''
            UPDATE logs.process_log
            SET status = %s,
                end_time = %s,
                rows_processed = %s
            WHERE log_id = %s;
        ''', ('SUCCESS', datetime.now(), rows_processed, log_id))


def finish_log_failed(conn, log_id, error_message):
    with conn.cursor() as cur:
        cur.execute('''
            UPDATE logs.process_log
            SET status = %s,
                end_time = %s,
                error_message = %s
            WHERE log_id = %s;
        ''', ('FAILED', datetime.now(), error_message, log_id))
