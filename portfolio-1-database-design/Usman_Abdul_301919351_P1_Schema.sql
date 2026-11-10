-- Banking and Fintech Transaction Processing Platform: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."account_types" (
  "type_id" bigint NOT NULL,
  "type_code" text NOT NULL,
  "description" text NOT NULL,
  "is_business" boolean NOT NULL,
  CONSTRAINT "pk_account_types" PRIMARY KEY ("type_id"),
  CONSTRAINT "uq_account_types_0" UNIQUE ("type_code")
);
CREATE TABLE portfolio."accounts" (
  "account_id" bigint NOT NULL,
  "account_ref" text NOT NULL,
  "type_id" bigint NOT NULL,
  "currency" text NOT NULL,
  "opened_on" date NOT NULL,
  "status" text NOT NULL,
  CONSTRAINT "pk_accounts" PRIMARY KEY ("account_id"),
  CONSTRAINT "uq_accounts_0" UNIQUE ("account_ref")
);
CREATE TABLE portfolio."transactions" (
  "txn_id" bigint NOT NULL,
  "account_id" bigint NOT NULL,
  "occurred_at" timestamptz NOT NULL,
  "amount" numeric(18,2) NOT NULL,
  "direction" text NOT NULL,
  "status" text NOT NULL,
  "external_ref" text,
  CONSTRAINT "pk_transactions" PRIMARY KEY ("txn_id")
);
ALTER TABLE portfolio."accounts" ADD CONSTRAINT "fk_accounts_0" FOREIGN KEY ("type_id") REFERENCES portfolio."account_types" ("type_id");
ALTER TABLE portfolio."transactions" ADD CONSTRAINT "fk_transactions_0" FOREIGN KEY ("account_id") REFERENCES portfolio."accounts" ("account_id");
ALTER TABLE portfolio."transactions" ADD CONSTRAINT "txn_amount_positive" CHECK ("amount" > 0);
ALTER TABLE portfolio."transactions" ADD CONSTRAINT "txn_direction_allowed" CHECK (("direction" = 'inflow') OR ("direction" = 'outflow'));
CREATE UNIQUE INDEX "txn_external_ref_once" ON portfolio."transactions" ("external_ref") WHERE ("external_ref" IS NOT NULL);
COMMIT;
