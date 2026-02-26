INSERT INTO transactions_text_demo
SELECT
  gs AS transaction_id,
  (RANDOM() * 200)::INT + 1 AS customer_id,

  CASE (gs % 6)
    WHEN 0 THEN '   077600945  '
    WHEN 1 THEN '077-600-045'
    WHEN 2 THEN '(374)-77-600-945'
    WHEN 3 THEN '37477600945'
    WHEN 4 THEN '77600945'
    ELSE '077600945'
  END AS raw_phone,

  CASE (gs % 5)
    WHEN 0 THEN 'Accessories (Promo)'
    WHEN 1 THEN 'Accessories (Test)'
    WHEN 2 THEN 'Electronics (Old)'
    WHEN 3 THEN 'Electronics (Promo)'
    ELSE 'Accessories'
  END AS category_raw,

  (RANDOM() * 5)::INT + 1 AS quantity,
  (RANDOM() * 500 + 10)::NUMERIC(10,2) AS price
FROM generate_series(1, 1000) AS gs;


SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT raw_phone) AS distinct_raw_phones,
  COUNT(DISTINCT category_raw) AS distinct_categories
FROM transactions_text_demo;

SELECT
raw_phone,
LENGTH(raw_phone) AS phone_length,
POSITION('-' IN raw_phone) AS dash_position,
STRPOS(raw_phone, '(') AS open_paren_position,
COUNT(*) AS rows_per_pattern
FROM transactions_text_demo
GROUP BY
raw_phone,
LENGTH(raw_phone),
POSITION('-' IN raw_phone),
STRPOS(raw_phone, '(');

SELECT
category_raw,
COUNT(*) AS transaction_count
FROM transactions_text_demo
GROUP BY category_raw
ORDER BY COUNT(*) DESC;

SELECT
category_raw,
SUM(quantity * price) AS revenue_by_category,
COUNT(DISTINCT raw_phone) AS unique_customers,
AVG(price) AS average_transaction_value
FROM transactions_text_demo
GROUP BY category_raw
ORDER BY revenue_by_category DESC;

SELECT
SUBSTRING(REGEXP_REPLACE(raw_phone, '[^0-9]', '', 'g')
FROM LENGTH(REGEXP_REPLACE(raw_phone, '[^0-9]', '', 'g')) - 7 FOR 8)
AS clean_phone,
TRIM(REGEXP_REPLACE(category_raw, '\s*\(.*?\)', '', 'g'))
AS clean_category,
(quantity * price) AS revenue
FROM transactions_text_demo;

SELECT
category_raw AS category,
SUM(quantity * price) AS total_revenue,
'Raw Data' AS data_source
FROM transactions_text_demo
GROUP BY category_raw

SELECT
TRIM(REGEXP_REPLACE(category_raw, '\s*\(.*?\)', '', 'g')) AS category,
SUM(quantity * price) AS total_revenue,
'Cleaned Data' AS data_source
FROM transactions_text_demo
GROUP BY 1
ORDER BY data_source, total_revenue DESC;


SELECT
COUNT(DISTINCT raw_phone) AS raw_unique_customers,
COUNT(DISTINCT RIGHT(REGEXP_REPLACE(raw_phone, '[^0-9]', '', 'g'), 8)) AS cleaned_unique_customers
FROM transactions_text_demo;

--The KPIs changed because we eliminated data fragmentation. In the raw dataset, the same business entities (customers and categories) were split across multiple formats
--Standardization normalized these values, allowing GROUP BY and COUNT(DISTINCT) to aggregate the data accurately.

--The phone number standardization (REGEXP_REPLACE + SUBSTRING) had the most significant impact.
--By isolating the unique 8-digit identifier, we merged duplicate records that appeared as different users. This corrected the artificial inflation of the "Unique Customers" metric.

--The last 8 digits of a phone number are sufficient to uniquely identify a customer within this dataset.
--Additionally, text within parentheses in the category field (e.g., Promo, Test) represents metadata rather than a distinct business category.

--The logic could fail if new data formats are introduced, such as phone numbers shorter than 8 digits, which would cause SUBSTRING to return incorrect values without triggering an error. 
--Furthermore, if parentheses are used for essential category names rather than just annotations, the REGEXP will silently delete critical information.
