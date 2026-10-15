CREATE TABLE IF NOT EXISTS learning_items (
    id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name text NOT NULL UNIQUE
);

INSERT INTO learning_items (name)
VALUES ('persistent-volume-evidence')
ON CONFLICT (name) DO NOTHING;
