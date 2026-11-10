# Banking and Fintech Transaction Processing Platform — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| account_id | transactions records (list) |
| --- | --- |
| 201 | [301] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| transactions.txn_id | transactions.account_id | transactions.direction | accounts.account_id | accounts.account_ref | accounts.type_id | account_types.type_id | account_types.type_code |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 301 | 201 | inflow | 201 | SYN-ACCOUNT-001 | 101 | 101 | PERSONAL |

Key: txn_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## transactions_example

| transactions.txn_id | transactions.account_id | transactions.direction | accounts.account_id | accounts.account_ref | accounts.type_id | account_types.type_id | account_types.type_code |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 301 | 201 | inflow | 201 | SYN-ACCOUNT-001 | 101 | 101 | PERSONAL |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## account_types

| type_id | type_code | description | is_business |
| --- | --- | --- | --- |
| 101 | PERSONAL | Personal account | false |

## accounts

| account_id | account_ref | type_id | currency | opened_on | status |
| --- | --- | --- | --- | --- | --- |
| 201 | SYN-ACCOUNT-001 | 101 | USD | 2025-01-15 | active |

## transactions

| txn_id | account_id | occurred_at | amount | direction | status | external_ref |
| --- | --- | --- | --- | --- | --- | --- |
| 301 | 201 | 2025-02-01T10:30:00+00:00 | 125.5 | inflow | posted | SYN-REQUEST-001 |

## Dependencies

- account_types: (type_id) → type_code, description, is_business
- accounts: (account_id) → account_ref, type_id, currency, opened_on, status
- transactions: (txn_id) → account_id, occurred_at, amount, direction, status, external_ref

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
