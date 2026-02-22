

ALTER TABLE public.employees
ADD CONSTRAINT uq_employees_email UNIQUE (email);

ALTER TABLE public.employees
ALTER COLUMN email SET NOT NULL;

ALTER TABLE public.products
ADD CONSTRAINT chk_products_price CHECK (price >= 0);

ALTER TABLE public.sales
ADD CONSTRAINT chk_sales_total CHECK (total_sales >= 0);

ALTER TABLE public.sales
ADD COLUMN sales_channel TEXT,
ADD CONSTRAINT chk_sales_channel
CHECK (sales_channel IN ('online', 'store'));

UPDATE public.sales
SET sales_channel = 'online'
WHERE transaction_id % 2 = 0;

UPDATE public.sales
SET sales_channel = 'store'
WHERE sales_channel IS NULL;
--added a new analytical attribute called 'sales_channel' to the sales table to categorize each transaction based on its source—either 'online' or 'store';
--This will allow for future data analysis to determine which channel generates more revenue or has a higher volume of sales;
--  a CHECK constraint was implemented to maintain data integrity, ensuring that no invalid categories are entered into the system 

 --create index on product_id for faster joins and filtering
 CREATE INDEX IF NOT EXISTS idx_sales_product_id
ON public.sales (product_id);

 --create index on customer_id for faster joins
 CREATE INDEX IF NOT EXISTS idx_sales_customer_id
ON public.sales (customer_id);

 --create index on product category for faster grouping and filtering
 CREATE INDEX IF NOT EXISTS idx_products_category
ON public.products (category);

EXPLAIN
SELECT
  product_id,
  SUM(total_sales) AS total_revenue
FROM public.sales
GROUP BY product_id;

---'seq scan on sales' means that a sequential scan was used.
---In this case PostgreSQL did not leverage the index as the data volume is too small (5000rows)
---The planner chose this plan as for this small data volume the sequential plan is faster

SELECT
  transaction_id,
  product_id,
  total_sales
FROM public.sales;
--- This reduces cost as database reads less data, less data is sent over the network and less memory is used in the computer RAM.
---SELECT * might be acceptable when dealing with small tables and during the initial phase when we don't know which columns we'll need

SELECT
  product_id,
  SUM(total_sales) AS total_revenue
FROM sales
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 5;

EXPLAIN
SELECT
  product_id,
  SUM(total_sales) AS total_revenue
FROM sales
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 5;
---The cost is low as I'm sorting limited number of columns and rows.
---Indexes do not help as a seq scan is performed due to small data

EXPLAIN
SELECT DISTINCT
  category,
  price
FROM public.products;

EXPLAIN
SELECT
  category,
  price
FROM public.products
GROUP BY category, price;

--The query plans are similar (Seq scan and HashAggregate ) 
--In both cases cost =3.50..4.50
--Both commands ask the db to find unique combinations of category and price 
--so the engine realizes they want the same result and uses the same plan to save time and energy.

INSERT INTO public.products (product_id, product_name, price)
VALUES (105, 'broken products', '-10.50');
---Check constraint was triggered in the price column.
---As the product cannot have a negative price the db rejected the entry of -10.50

SELECT product_id
FROM public.products 
ORDER BY product_id DESC LIMIT 1;

UPDATE public.sales
SET product_id = 45
WHERE transaction_id = (SELECT transaction_id FROM public.sales LIMIT 1); 

SELECT DISTINCT product_id
FROM public.sales 
LIMIT 10;

UPDATE public.sales
SET product_id = 5
WHERE transaction_id = (SELECT transaction_id FROM public.sales LIMIT 1); 

UPDATE public.sales
SET product_id = 44444
WHERE transaction_id = (SELECT transaction_id FROM public.sales LIMIT 1); 
    ---I tried to update a sale record with a non-existent product_id (44444).
    ---The database rejected the change because of the Foreign Key constraint.
    ---This ensures Data Integrity, meaning we can't have sales for products that don't exist in our list.

     ---FOREIGN KEY constraints provide the highest business value as they ensure data integrity across tables. 
     ---In a production environment, I would prioritize indexes on frequently queried columns, such as product_id or transaction_date, to significantly improve performance.
	 ---Slow query execution or frequent sequential scans in the query plan are clear signals that optimization is needed.
