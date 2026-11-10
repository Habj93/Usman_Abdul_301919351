# Banking and Fintech Transaction Processing Platform — SQL queries

## 1. Show related transactions, accounts, account_types records (up to 20).

```sql
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
```

| transactions_txn_id | transactions_occurred_at | accounts_account_id | accounts_account_ref | account_types_type_id | account_types_type_code |
| --- | --- | --- | --- | --- | --- |
| 301 | 2025-02-01T10:30:00+00:00 | 201 | SYN-ACCOUNT-001 | 101 | PERSONAL |

## 2. Find transactions records where occurred_at matches "2025-02-01T10:30:00Z" (up to 20).

```sql
SELECT * FROM portfolio."transactions"
WHERE "occurred_at" IS NOT DISTINCT FROM '2025-02-01T10:30:00Z'
ORDER BY "txn_id"
LIMIT 20;
```

| txn_id | account_id | occurred_at | amount | direction | status | external_ref |
| --- | --- | --- | --- | --- | --- | --- |
| 301 | 201 | 2025-02-01T10:30:00+00:00 | 125.5 | inflow | posted | SYN-REQUEST-001 |

## 3. Count transactions records for each account_id (up to 20 groups).

```sql
SELECT "account_id", count(*) AS record_count
FROM portfolio."transactions"
GROUP BY "account_id"
ORDER BY record_count DESC, "account_id" NULLS LAST
LIMIT 20;
```

| account_id | record_count |
| --- | --- |
| 201 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 2.454 | 2.454, 2.424, 2.565 | Sort → Seq Scan | 274 |
| After index | 0.322 | 0.336, 0.303, 0.322 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 2.454 ms to 0.322 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.42..2.423 rows=50 loops=1)
  Seq Scan on transactions (actual time=0.015..2.382 rows=50 loops=1)
Planning Time: 0.328 ms
Execution Time: 2.454 ms
```

### Before index, run 2

```text
Sort (actual time=2.395..2.398 rows=50 loops=1)
  Seq Scan on transactions (actual time=0.032..2.356 rows=50 loops=1)
Planning Time: 0.332 ms
Execution Time: 2.424 ms
```

### Before index, run 3

```text
Sort (actual time=2.525..2.528 rows=50 loops=1)
  Seq Scan on transactions (actual time=0.016..2.485 rows=50 loops=1)
Planning Time: 0.341 ms
Execution Time: 2.565 ms
```

### After index, run 1

```text
Sort (actual time=0.281..0.284 rows=50 loops=1)
  Bitmap Heap Scan on transactions (actual time=0.033..0.21 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=50 loops=1)
Planning Time: 0.534 ms
Execution Time: 0.336 ms
```

### After index, run 2

```text
Sort (actual time=0.247..0.25 rows=50 loops=1)
  Bitmap Heap Scan on transactions (actual time=0.033..0.208 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=50 loops=1)
Planning Time: 0.677 ms
Execution Time: 0.303 ms
```

### After index, run 3

```text
Sort (actual time=0.266..0.269 rows=50 loops=1)
  Bitmap Heap Scan on transactions (actual time=0.032..0.227 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=50 loops=1)
Planning Time: 0.525 ms
Execution Time: 0.322 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Usman_Abdul_301919351_P2_Queries.sql, then Usman_Abdul_301919351_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Usman_Abdul_301919351_P2_QueryResults.png) · [Index comparison](screenshots/Usman_Abdul_301919351_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

