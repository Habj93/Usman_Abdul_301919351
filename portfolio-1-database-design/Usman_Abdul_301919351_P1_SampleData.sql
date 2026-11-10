-- Fictional sample records for Banking and Fintech Transaction Processing Platform.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."account_types" ("type_id", "type_code", "description", "is_business") VALUES (101, 'PERSONAL', 'Personal account', FALSE);
INSERT INTO portfolio."accounts" ("account_id", "account_ref", "type_id", "currency", "opened_on", "status") VALUES (201, 'SYN-ACCOUNT-001', 101, 'USD', '2025-01-15', 'active');
INSERT INTO portfolio."transactions" ("txn_id", "account_id", "occurred_at", "amount", "direction", "status", "external_ref") VALUES (301, 201, '2025-02-01T10:30:00Z', 125.5, 'inflow', 'posted', 'SYN-REQUEST-001');
COMMIT;
