INSERT INTO ds.ft_balance_f (
    on_date,
    account_rk,
    currency_rk,
    balance_out 
)
SELECT to_date(fbf."ON_DATE" , 'DD.MM.YYYY') AS on_date,
    fbf."ACCOUNT_RK"::NUMERIC,
    fbf."CURRENCY_RK"::NUMERIC,
    fbf."BALANCE_OUT"::NUMERIC(23, 8)
FROM stage.ft_balance_f fbf
WHERE fbf."ON_DATE" IS NOT NULL
    AND fbf."ACCOUNT_RK" IS NOT NULL
ON CONFLICT (on_date, account_rk)
DO UPDATE SET
    currency_rk = EXCLUDED.currency_rk,
    balance_out = EXCLUDED.balance_out;