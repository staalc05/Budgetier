-- PostgreSQL schema for the Budgetier backend
-- This schema captures the core entities needed for budgeting, goals, fixed
-- costs and multi‑user groups. It is intentionally simplified for an MVP and
-- does not include every column that a production system might need (e.g.
-- audit fields, indexes, constraints such as ON DELETE CASCADE).

-- Users of the platform. Each user can optionally belong to one or more
-- groups and can connect multiple bank accounts.
CREATE TABLE users (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  locale TEXT DEFAULT 'de_AT',
  currency TEXT DEFAULT 'EUR',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Groups allow multiple users to share budgets and goals. Groups can link
-- their own bank connections and accounts separate from personal ones.
CREATE TABLE groups (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Membership table linking users to groups. The role field can be used to
-- differentiate between owners and regular members.
CREATE TABLE group_members (
  id BIGSERIAL PRIMARY KEY,
  group_id BIGINT NOT NULL REFERENCES groups(id),
  user_id BIGINT NOT NULL REFERENCES users(id),
  role TEXT NOT NULL DEFAULT 'member'
);

-- Bank connections represent a consented access token with an aggregator
-- provider (e.g. Tink). Each connection is associated with a user but can
-- optionally be shared with a group via the account_share table.
CREATE TABLE bank_connections (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id),
  provider TEXT NOT NULL,
  consent_status TEXT NOT NULL,
  access_token_ref TEXT NOT NULL,
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Accounts linked via a bank connection. An account may belong to a user or
-- group depending on whether it has been shared. The type field denotes
-- checking, savings, credit card, etc.
CREATE TABLE accounts (
  id BIGSERIAL PRIMARY KEY,
  bank_connection_id BIGINT NOT NULL REFERENCES bank_connections(id),
  user_id BIGINT NOT NULL REFERENCES users(id),
  group_id BIGINT REFERENCES groups(id),
  iban TEXT,
  bank_name TEXT,
  currency TEXT,
  type TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Transactions imported from bank statements. The raw_desc column stores the
-- unparsed description from the bank. Category_id may be null when
-- categorisation has not yet occurred. Meta can hold JSON data for
-- enrichment.
CREATE TABLE transactions (
  id BIGSERIAL PRIMARY KEY,
  account_id BIGINT NOT NULL REFERENCES accounts(id),
  booking_date DATE NOT NULL,
  amount NUMERIC(14, 2) NOT NULL,
  currency TEXT NOT NULL,
  counterparty TEXT,
  raw_desc TEXT,
  category_id BIGINT REFERENCES categories(id),
  is_recurring BOOLEAN DEFAULT FALSE,
  meta JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Category definitions for transaction categorisation and budget allocations.
-- Prepopulate with Groceries, Housing, Entertainment, Savings, etc.
CREATE TABLE categories (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

-- A budget period groups allocations and spend for a user or group. The
-- scope_type distinguishes between user and group. Status can be used to
-- close periods.
CREATE TABLE budget_periods (
  id BIGSERIAL PRIMARY KEY,
  scope_type TEXT NOT NULL CHECK (scope_type IN ('user','group')),
  scope_id BIGINT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('monthly','biweekly','weekly')),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  status TEXT NOT NULL DEFAULT 'active'
);

-- Planned allocations per category within a budget period. The rollover_rule
-- defines how underspend should be handled (e.g. to savings or to remaining
-- days). For fixed costs (housing, rent) this rule can be ignored.
CREATE TABLE budget_allocations (
  id BIGSERIAL PRIMARY KEY,
  period_id BIGINT NOT NULL REFERENCES budget_periods(id),
  category_id BIGINT NOT NULL REFERENCES categories(id),
  planned_amount NUMERIC(14, 2) NOT NULL,
  rollover_rule JSONB
);

-- Financial goals that reserve money over multiple periods. The scope_type
-- behaves like in budget_periods. The reserved_amount_to_date tracks how
-- much has been saved so far.
CREATE TABLE goals (
  id BIGSERIAL PRIMARY KEY,
  scope_type TEXT NOT NULL CHECK (scope_type IN ('user','group')),
  scope_id BIGINT NOT NULL,
  name TEXT NOT NULL,
  target_amount NUMERIC(14, 2) NOT NULL,
  target_date DATE NOT NULL,
  reserved_amount_to_date NUMERIC(14, 2) DEFAULT 0,
  is_paused BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Fixed costs (rent, utilities, car payments) that reduce the available
-- variable budget. Cadence can be monthly, biweekly or weekly. Due_day can
-- indicate the day of month or week when the cost is applied.
CREATE TABLE fixed_costs (
  id BIGSERIAL PRIMARY KEY,
  scope_type TEXT NOT NULL CHECK (scope_type IN ('user','group')),
  scope_id BIGINT NOT NULL,
  name TEXT NOT NULL,
  amount NUMERIC(14, 2) NOT NULL,
  cadence TEXT NOT NULL CHECK (cadence IN ('monthly','biweekly','weekly')),
  due_day INTEGER,
  account_id BIGINT REFERENCES accounts(id)
);

-- Ledger tracking inflows and outflows to the savings bucket. The direction
-- field distinguishes between contributions to savings (IN) and reassignments
-- out to a period (OUT). The source column indicates why the entry was
-- recorded (undershoot, manual, goal, adjustment).
CREATE TABLE savings_ledger (
  id BIGSERIAL PRIMARY KEY,
  scope_type TEXT NOT NULL CHECK (scope_type IN ('user','group')),
  scope_id BIGINT NOT NULL,
  period_id BIGINT REFERENCES budget_periods(id),
  amount NUMERIC(14, 2) NOT NULL,
  direction TEXT NOT NULL CHECK (direction IN ('IN','OUT')),
  source TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- User notification preferences for push notifications. Soft_muted_until and
-- hard_muted_until allow temporary silencing of warnings.
CREATE TABLE notification_preferences (
  user_id BIGINT PRIMARY KEY REFERENCES users(id),
  push_enabled BOOLEAN DEFAULT TRUE,
  soft_muted_until TIMESTAMPTZ,
  hard_muted_until TIMESTAMPTZ
);

-- Sharing settings for accounts within groups. Visibility can be PERSONAL
-- (only the owner sees the account) or GROUP (all group members see it).
CREATE TABLE account_share (
  account_id BIGINT NOT NULL REFERENCES accounts(id),
  group_id BIGINT NOT NULL REFERENCES groups(id),
  visibility TEXT NOT NULL CHECK (visibility IN ('PERSONAL','GROUP')),
  PRIMARY KEY (account_id, group_id)
);