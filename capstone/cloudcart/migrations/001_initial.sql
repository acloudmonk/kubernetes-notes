CREATE SCHEMA IF NOT EXISTS catalog;
CREATE SCHEMA IF NOT EXISTS inventory;
CREATE SCHEMA IF NOT EXISTS ordering;
CREATE SCHEMA IF NOT EXISTS messaging;
CREATE SCHEMA IF NOT EXISTS notification;

CREATE TABLE IF NOT EXISTS catalog.products (
    id uuid PRIMARY KEY,
    sku text NOT NULL UNIQUE,
    name text NOT NULL,
    price_cents integer NOT NULL CHECK (price_cents >= 0)
);

CREATE TABLE IF NOT EXISTS inventory.stock (
    product_id uuid PRIMARY KEY REFERENCES catalog.products(id),
    available integer NOT NULL CHECK (available >= 0)
);

CREATE TABLE IF NOT EXISTS ordering.orders (
    id uuid PRIMARY KEY,
    status text NOT NULL CHECK (status IN ('accepted', 'rejected')),
    total_cents integer NOT NULL CHECK (total_cents >= 0),
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS ordering.order_lines (
    order_id uuid NOT NULL REFERENCES ordering.orders(id),
    product_id uuid NOT NULL REFERENCES catalog.products(id),
    quantity integer NOT NULL CHECK (quantity > 0),
    unit_price_cents integer NOT NULL CHECK (unit_price_cents >= 0),
    PRIMARY KEY (order_id, product_id)
);

CREATE TABLE IF NOT EXISTS ordering.idempotency_keys (
    key text PRIMARY KEY,
    request_hash text NOT NULL,
    order_id uuid NOT NULL REFERENCES ordering.orders(id),
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS messaging.outbox (
    id uuid PRIMARY KEY,
    aggregate_id uuid NOT NULL,
    event_type text NOT NULL,
    payload jsonb NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    published_at timestamptz
);

CREATE INDEX IF NOT EXISTS outbox_unpublished_idx
    ON messaging.outbox (created_at) WHERE published_at IS NULL;

CREATE TABLE IF NOT EXISTS notification.processed_events (
    event_id uuid PRIMARY KEY,
    order_id uuid NOT NULL,
    processed_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO catalog.products (id, sku, name, price_cents)
VALUES
    ('10000000-0000-0000-0000-000000000001', 'MUG-001', 'CloudCart mug', 1299),
    ('10000000-0000-0000-0000-000000000002', 'TEE-001', 'CloudCart T-shirt', 2499)
ON CONFLICT (id) DO NOTHING;

INSERT INTO inventory.stock (product_id, available)
VALUES
    ('10000000-0000-0000-0000-000000000001', 20),
    ('10000000-0000-0000-0000-000000000002', 10)
ON CONFLICT (product_id) DO NOTHING;
