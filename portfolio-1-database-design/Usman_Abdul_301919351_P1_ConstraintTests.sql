-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. reject account types pk. Expected: pk_account_types, SQLSTATE 23505.
INSERT INTO portfolio."account_types" ("type_id", "type_code", "description", "is_business")
VALUES (101, 'BUSINESS', 'Business account', TRUE);

-- 2. reject account types unique. Expected: uq_account_types_0, SQLSTATE 23505.
INSERT INTO portfolio."account_types" ("type_id", "type_code", "description", "is_business")
VALUES (102, 'PERSONAL', 'Duplicate type code', FALSE);

-- 3. reject account types type id null. Expected: type_id, SQLSTATE 23502.
INSERT INTO portfolio."account_types" ("type_id", "type_code", "description", "is_business")
VALUES (NULL, 'TYPE-NULL-ID', 'Test type', FALSE);

-- 4. reject account types type code null. Expected: type_code, SQLSTATE 23502.
INSERT INTO portfolio."account_types" ("type_id", "type_code", "description", "is_business")
VALUES (103, NULL, 'Test type', FALSE);

-- 5. reject account types description null. Expected: description, SQLSTATE 23502.
INSERT INTO portfolio."account_types" ("type_id", "type_code", "description", "is_business")
VALUES (104, 'TYPE-NULL-DESC', NULL, FALSE);

-- 6. reject account types is business null. Expected: is_business, SQLSTATE 23502.
INSERT INTO portfolio."account_types" ("type_id", "type_code", "description", "is_business")
VALUES (105, 'TYPE-NULL-BUSINESS', 'Test type', NULL);

-- 7. reject accounts pk. Expected: pk_accounts, SQLSTATE 23505.
INSERT INTO portfolio."accounts" ("account_id", "account_ref", "type_id", "currency", "opened_on", "status")
VALUES (201, 'SYN-ACCOUNT-PK-TEST', 101, 'USD', '2025-03-01', 'active');

-- 8. reject accounts unique. Expected: uq_accounts_0, SQLSTATE 23505.
INSERT INTO portfolio."accounts" ("account_id", "account_ref", "type_id", "currency", "opened_on", "status")
VALUES (202, 'SYN-ACCOUNT-001', 101, 'EUR', '2025-03-01', 'active');

-- 9. reject accounts fk. Expected: fk_accounts_0, SQLSTATE 23503.
INSERT INTO portfolio."accounts" ("account_id", "account_ref", "type_id", "currency", "opened_on", "status")
VALUES (203, 'SYN-ACCOUNT-BAD-TYPE', 9001, 'USD', '2025-03-01', 'active');

-- 10. reject accounts account id null. Expected: account_id, SQLSTATE 23502.
INSERT INTO portfolio."accounts" ("account_id", "account_ref", "type_id", "currency", "opened_on", "status")
VALUES (NULL, 'SYN-ACCOUNT-NULL-ID', 101, 'USD', '2025-03-01', 'active');

-- 11. reject accounts account ref null. Expected: account_ref, SQLSTATE 23502.
INSERT INTO portfolio."accounts" ("account_id", "account_ref", "type_id", "currency", "opened_on", "status")
VALUES (204, NULL, 101, 'USD', '2025-03-01', 'active');

-- 12. reject accounts type id null. Expected: type_id, SQLSTATE 23502.
INSERT INTO portfolio."accounts" ("account_id", "account_ref", "type_id", "currency", "opened_on", "status")
VALUES (205, 'SYN-ACCOUNT-NULL-TYPE', NULL, 'USD', '2025-03-01', 'active');

-- 13. reject accounts currency null. Expected: currency, SQLSTATE 23502.
INSERT INTO portfolio."accounts" ("account_id", "account_ref", "type_id", "currency", "opened_on", "status")
VALUES (206, 'SYN-ACCOUNT-NULL-CURRENCY', 101, NULL, '2025-03-01', 'active');

-- 14. reject accounts opened on null. Expected: opened_on, SQLSTATE 23502.
INSERT INTO portfolio."accounts" ("account_id", "account_ref", "type_id", "currency", "opened_on", "status")
VALUES (207, 'SYN-ACCOUNT-NULL-DATE', 101, 'USD', NULL, 'active');

-- 15. reject accounts status null. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."accounts" ("account_id", "account_ref", "type_id", "currency", "opened_on", "status")
VALUES (208, 'SYN-ACCOUNT-NULL-STATUS', 101, 'USD', '2025-03-01', NULL);

-- 16. reject transactions pk. Expected: pk_transactions, SQLSTATE 23505.
INSERT INTO portfolio."transactions" ("txn_id", "account_id", "occurred_at", "amount", "direction", "status", "external_ref")
VALUES (301, 201, '2025-02-02T10:30:00Z', 25, 'outflow', 'posted', 'SYN-REQUEST-PK-TEST');

-- 17. reject transactions fk. Expected: fk_transactions_0, SQLSTATE 23503.
INSERT INTO portfolio."transactions" ("txn_id", "account_id", "occurred_at", "amount", "direction", "status", "external_ref")
VALUES (302, 9002, '2025-02-02T10:30:00Z', 25, 'outflow', 'posted', 'SYN-REQUEST-BAD-ACCOUNT');

-- 18. reject transactions txn id null. Expected: txn_id, SQLSTATE 23502.
INSERT INTO portfolio."transactions" ("txn_id", "account_id", "occurred_at", "amount", "direction", "status", "external_ref")
VALUES (NULL, 201, '2025-02-02T10:30:00Z', 25, 'outflow', 'posted', 'SYN-REQUEST-NULL-ID');

-- 19. reject transactions account id null. Expected: account_id, SQLSTATE 23502.
INSERT INTO portfolio."transactions" ("txn_id", "account_id", "occurred_at", "amount", "direction", "status", "external_ref")
VALUES (303, NULL, '2025-02-02T10:30:00Z', 25, 'outflow', 'posted', 'SYN-REQUEST-NULL-ACCOUNT');

-- 20. reject transactions occurred at null. Expected: occurred_at, SQLSTATE 23502.
INSERT INTO portfolio."transactions" ("txn_id", "account_id", "occurred_at", "amount", "direction", "status", "external_ref")
VALUES (304, 201, NULL, 25, 'outflow', 'posted', 'SYN-REQUEST-NULL-TIME');

-- 21. reject transactions amount null. Expected: amount, SQLSTATE 23502.
INSERT INTO portfolio."transactions" ("txn_id", "account_id", "occurred_at", "amount", "direction", "status", "external_ref")
VALUES (305, 201, '2025-02-02T10:30:00Z', NULL, 'outflow', 'posted', 'SYN-REQUEST-NULL-AMOUNT');

-- 22. reject transactions direction null. Expected: direction, SQLSTATE 23502.
INSERT INTO portfolio."transactions" ("txn_id", "account_id", "occurred_at", "amount", "direction", "status", "external_ref")
VALUES (306, 201, '2025-02-02T10:30:00Z', 25, NULL, 'posted', 'SYN-REQUEST-NULL-DIRECTION');

-- 23. reject transactions status null. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."transactions" ("txn_id", "account_id", "occurred_at", "amount", "direction", "status", "external_ref")
VALUES (307, 201, '2025-02-02T10:30:00Z', 25, 'outflow', NULL, 'SYN-REQUEST-NULL-STATUS');

-- 24. reject transactions amount check. Expected: txn_amount_positive, SQLSTATE 23514.
INSERT INTO portfolio."transactions" ("txn_id", "account_id", "occurred_at", "amount", "direction", "status", "external_ref")
VALUES (308, 201, '2025-02-02T10:30:00Z', 0, 'outflow', 'posted', 'SYN-REQUEST-BAD-AMOUNT');

-- 25. reject transactions direction check. Expected: txn_direction_allowed, SQLSTATE 23514.
INSERT INTO portfolio."transactions" ("txn_id", "account_id", "occurred_at", "amount", "direction", "status", "external_ref")
VALUES (309, 201, '2025-02-02T10:30:00Z', 25, 'sideways', 'posted', 'SYN-REQUEST-BAD-DIRECTION');

-- 26. reject transactions partial unique. Expected: txn_external_ref_once, SQLSTATE 23505.
INSERT INTO portfolio."transactions" ("txn_id", "account_id", "occurred_at", "amount", "direction", "status", "external_ref")
VALUES (310, 201, '2025-02-02T10:30:00Z', 25, 'outflow', 'posted', 'SYN-REQUEST-001');
