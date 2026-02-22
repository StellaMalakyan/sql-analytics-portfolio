DROP TABLE IF EXISTS transactions_text_demo;

CREATE TABLE transactions_text_demo (
  transaction_id INTEGER,
  customer_id    INTEGER,
  raw_phone      TEXT,
  category_raw   TEXT,
  quantity       INTEGER,
  price          NUMERIC(10,2)
);