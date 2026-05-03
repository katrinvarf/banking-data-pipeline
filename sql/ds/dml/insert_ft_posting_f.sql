INSERT INTO ds.ft_posting_f (
    oper_date,
    credit_account_rk,
    debet_account_rk,
    credit_amount,
    debet_amount
)
SELECT to_date(fpf."OPER_DATE", 'DD-MM-YYYY'),
    fpf."CREDIT_ACCOUNT_RK"::NUMERIC,
    fpf."DEBET_ACCOUNT_RK"::NUMERIC,
    fpf."CREDIT_AMOUNT"::NUMERIC(23, 8),
    fpf."DEBET_AMOUNT"::NUMERIC(23, 8)
FROM stage.ft_posting_f fpf
WHERE fpf."OPER_DATE" IS NOT NULL
    AND fpf."CREDIT_ACCOUNT_RK" IS NOT NULL
    AND fpf."DEBET_ACCOUNT_RK" IS NOT NULL;