-- Show related transactions, accounts, account_types records (up to 20).
SELECT t0."txn_id" AS "transactions_txn_id",
       t0."occurred_at" AS "transactions_occurred_at",
       t1."account_id" AS "accounts_account_id",
       t1."account_ref" AS "accounts_account_ref",
       t2."type_id" AS "account_types_type_id",
       t2."type_code" AS "account_types_type_code"
FROM portfolio."transactions" t0
JOIN portfolio."accounts" t1 ON t0."account_id" = t1."account_id"
JOIN portfolio."account_types" t2 ON t1."type_id" = t2."type_id"
ORDER BY t0."txn_id", t1."account_id", t2."type_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."txn_id" AS "transactions_txn_id",
       t0."occurred_at" AS "transactions_occurred_at",
       t1."account_id" AS "accounts_account_id",
       t1."account_ref" AS "accounts_account_ref",
       t2."type_id" AS "account_types_type_id",
       t2."type_code" AS "account_types_type_code"
FROM portfolio."transactions" t0
JOIN portfolio."accounts" t1 ON t0."account_id" = t1."account_id"
JOIN portfolio."account_types" t2 ON t1."type_id" = t2."type_id"
ORDER BY t0."txn_id", t1."account_id", t2."type_id"
LIMIT 20;

-- Find transactions records where occurred_at matches "2025-02-01T10:30:00Z" (up to 20).
SELECT * FROM portfolio."transactions"
WHERE "occurred_at" IS NOT DISTINCT FROM '2025-02-01T10:30:00Z'
ORDER BY "txn_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."transactions"
WHERE "occurred_at" IS NOT DISTINCT FROM '2025-02-01T10:30:00Z'
ORDER BY "txn_id"
LIMIT 20;

-- Count transactions records for each account_id (up to 20 groups).
SELECT "account_id", count(*) AS record_count
FROM portfolio."transactions"
GROUP BY "account_id"
ORDER BY record_count DESC, "account_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "account_id", count(*) AS record_count
FROM portfolio."transactions"
GROUP BY "account_id"
ORDER BY record_count DESC, "account_id" NULLS LAST
LIMIT 20;
