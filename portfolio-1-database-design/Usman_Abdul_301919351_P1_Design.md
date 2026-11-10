# Banking and Fintech Transaction Processing Platform — database design

My case study records account_types, accounts, transactions.

## Users

- Operations analysts reviewing account activity
- Platform engineers maintaining transaction integrity

## Main operations

- Record a transaction against an account
- Review transactions for an account over a date range
- Summarize transaction amounts by account and direction

## Entities

| Entity | Information stored |
| --- | --- |
| account_types | Stores shared account category attributes used by multiple accounts. |
| accounts | Stores the account-level facts that are shared by the account's transaction history. |
| transactions | Stores individual account transactions and an optional deduplication reference for submitted requests. |

## account_types

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| type_id | BIGINT | PK | Yes |
| type_code | TEXT | Unique | Yes |
| description | TEXT |  | Yes |
| is_business | BOOLEAN |  | Yes |
- Unique key: (type_code).

## accounts

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| account_id | BIGINT | PK | Yes |
| account_ref | TEXT | Unique | Yes |
| type_id | BIGINT | FK | Yes |
| currency | TEXT |  | Yes |
| opened_on | DATE |  | Yes |
| status | TEXT |  | Yes |
- type_id → account_types.type_id
- Unique key: (account_ref).

## transactions

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| txn_id | BIGINT | PK | Yes |
| account_id | BIGINT | FK | Yes |
| occurred_at | TIMESTAMPTZ |  | Yes |
| amount | NUMERIC(18,2) |  | Yes |
| direction | TEXT |  | Yes |
| status | TEXT |  | Yes |
| external_ref | TEXT |  | No |
- account_id → accounts.account_id

## Relationships and business rules

- Each account type code identifies at most one account type.
- Each account reference identifies at most one account.
- Every account must reference an existing account type.
- Every transaction must reference an existing account.
- Transaction amount must be greater than zero.
- Direction must be one of the allowed values for inflow or outflow activity.
- A non-null external_ref may appear on at most one transaction, preventing reuse of a submitted request reference.

## Assumptions

- All records in this exercise are synthetic and do not represent a production bank.
- Each account belongs to exactly one account type and one currency; the currency is not modelled as an independent entity.
- A transaction amount is positive; direction distinguishes inflows from outflows and is checked by a row rule.
- A non-null external_ref identifies one submitted transaction request and cannot be reused across transactions.
- The normalisation example starts from a transaction row that repeats account reference and account type. The account facts are moved to accounts and account_types, leaving only the foreign keys in transactions to avoid repeated ancestor roles.
- This case uses account and transaction processing only; no card network, customer profile library, or payment scheme is substituted.

