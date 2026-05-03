INSERT INTO ds.md_exchange_rate_d (
    data_actual_date,
    data_actual_end_date,
    currency_rk,
    reduced_cource,
    code_iso_num
)
SELECT DISTINCT to_date(merd."DATA_ACTUAL_DATE", 'YYYY-MM-DD'),
    to_date(merd."DATA_ACTUAL_END_DATE", 'YYYY-MM-DD'),
	merd."CURRENCY_RK"::NUMERIC,
	merd."REDUCED_COURCE"::NUMERIC(23, 8),
	merd."CODE_ISO_NUM"::VARCHAR(3)
FROM stage.md_exchange_rate_d merd
WHERE merd."DATA_ACTUAL_DATE" IS NOT NULL
	AND merd."CURRENCY_RK" IS NOT NULL
ON CONFLICT (data_actual_date, currency_rk)
DO UPDATE SET
    data_actual_end_date = EXCLUDED.data_actual_end_date,
    reduced_cource = EXCLUDED.reduced_cource,
    code_iso_num = EXCLUDED.code_iso_num;