# Banking and Fintech Transaction Processing Platform — ER diagram

```mermaid
erDiagram
    direction LR
    account_types {
        bigint type_id PK
        text type_code UK
        text description
        boolean is_business
    }
    accounts {
        bigint account_id PK
        text account_ref UK
        bigint type_id FK
        text currency
        date opened_on
        text status
    }
    transactions {
        bigint txn_id PK
        bigint account_id FK
        timestamptz occurred_at
        numeric amount
        text direction
        text status
        text external_ref "Optional"
    }
    account_types ||--o{ accounts : "type_id"
    accounts ||--o{ transactions : "account_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Usman_Abdul_301919351_ERDiagram.png)
