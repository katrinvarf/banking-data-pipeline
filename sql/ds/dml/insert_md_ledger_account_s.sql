INSERT INTO ds.md_ledger_account_s (
    chapter,
    chapter_name,
    section_number,
    section_name,
    subsection_name,
    ledger1_account,
    ledger1_account_name,
    ledger_account,
    ledger_account_name,
    characteristic,
    start_date,
    end_date
)
SELECT mlas."CHAPTER"::CHAR(1),
	mlas."CHAPTER_NAME"::VARCHAR(16),
	mlas."SECTION_NUMBER"::INTEGER,
	mlas."SECTION_NAME"::VARCHAR(22),
	mlas."SUBSECTION_NAME"::VARCHAR(21),
	mlas."LEDGER1_ACCOUNT"::INTEGER,
	mlas."LEDGER1_ACCOUNT_NAME"::VARCHAR(47),
	mlas."LEDGER_ACCOUNT"::INTEGER,
	mlas."LEDGER_ACCOUNT_NAME"::VARCHAR(153),
	mlas."CHARACTERISTIC"::CHAR(1),
    to_date(mlas."START_DATE", 'YYYY-MM-DD'),
    to_date(mlas."END_DATE", 'YYYY-MM-DD')
FROM stage.md_ledger_account_s mlas
WHERE mlas."LEDGER_ACCOUNT" IS NOT NULL
	AND mlas."START_DATE" IS NOT NULL;