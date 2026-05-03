INSERT INTO ds.md_account_d (
    data_actual_date,
    data_actual_end_date,
    account_rk,
    account_number,
    char_type,
    currency_rk,
    currency_code   
)
SELECT to_date(mad."DATA_ACTUAL_DATE", 'YYYY-MM-DD'),
	to_date(mad."DATA_ACTUAL_END_DATE", 'YYYY-MM-DD'),
	mad."ACCOUNT_RK"::NUMERIC,
	mad."ACCOUNT_NUMBER"::VARCHAR(20),
	mad."CHAR_TYPE"::CHAR(1),
	mad."CURRENCY_RK"::NUMERIC,
	mad."CURRENCY_CODE"::VARCHAR(3)
FROM stage.md_account_d mad
WHERE mad."DATA_ACTUAL_DATE" IS NOT NULL
	AND mad."DATA_ACTUAL_END_DATE" IS NOT NULL
	AND mad."ACCOUNT_RK" IS NOT NULL
	AND mad."ACCOUNT_NUMBER" IS NOT NULL
	AND mad."CHAR_TYPE" IS NOT NULL
	AND mad."CURRENCY_RK" IS NOT NULL
	AND mad."CURRENCY_CODE" IS NOT NULL;