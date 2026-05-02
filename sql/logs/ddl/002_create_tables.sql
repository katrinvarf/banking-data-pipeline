CREATE TABLE IF NOT EXISTS logs.process_log (
	log_id SERIAL PRIMARY KEY,
	process_name TEXT NOT NULL,
	status TEXT NOT NULL,
	start_time TIMESTAMP NOT NULL,
	end_time TIMESTAMP,
	description TEXT,
	rows_processed INTEGER,
	error_message TEXT,

	CONSTRAINT process_log_status_check 
	CHECK (status IN ('STARTED', 'SUCCESS', 'FAILED'))
);